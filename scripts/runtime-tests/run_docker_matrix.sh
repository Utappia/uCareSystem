#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT=${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}
UCARE_DOCKER_IMAGES=${UCARE_DOCKER_IMAGES:-"ubuntu:22.04 ubuntu:24.04 ubuntu:25.10"}
UCARE_SCENARIOS=${UCARE_SCENARIOS:-"smoke maintenance"}
UCARE_RUNTIME_TIMEOUT=${UCARE_RUNTIME_TIMEOUT:-1800}
UCARE_DOCKER_BASE_PREFIX=${UCARE_DOCKER_BASE_PREFIX:-"ucaresystem-runtime-base"}
UCARE_DOCKER_NO_CACHE=${UCARE_DOCKER_NO_CACHE:-0}

sanitize_image_tag() {
    local raw_tag=$1
    echo "$raw_tag" | tr '/:@' '---'
}

ensure_runtime_base_image() {
    local source_image=$1
    local safe_tag
    local base_image
    safe_tag=$(sanitize_image_tag "$source_image")
    base_image="${UCARE_DOCKER_BASE_PREFIX}:${safe_tag}"

    if [ "$UCARE_DOCKER_NO_CACHE" != "1" ] && docker image inspect "$base_image" >/dev/null 2>&1; then
        echo "Reusing cached runtime base image: $base_image" >&2
        echo "$base_image"
        return 0
    fi

    echo "Building runtime base image: $base_image" >&2
    docker pull "$source_image" >/dev/null

    local temp_dir
    temp_dir=$(mktemp -d)
    cat > "$temp_dir/Dockerfile" <<EOF
FROM ${source_image}
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \\
    bash \\
    sudo \\
    curl \\
    lsb-release \\
    iputils-ping \\
    lsof \\
    procps \\
    coreutils \\
    findutils \\
    gawk \\
    grep \\
    util-linux \\
    ca-certificates \\
    ncurses-bin \\
    tzdata \\
    && rm -rf /var/lib/apt/lists/*
EOF

    docker build -t "$base_image" "$temp_dir" >/dev/null
    rm -rf "$temp_dir"

    echo "$base_image"
}

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not available on this runner"
    exit 3
fi

for image in $UCARE_DOCKER_IMAGES; do
    echo "=== Runtime tests in Docker image: ${image} ==="

    runtime_base_image=$(ensure_runtime_base_image "$image")
done

    # Use a temp file to capture the log from inside the container
    safe_tag=$(sanitize_image_tag "$image")
    timestamp=$(date +%Y%m%d-%H%M%S)
    report_file="$REPO_ROOT/.runtime-test-logs/runtime-${timestamp}-${safe_tag}.log"
    mkdir -p "$REPO_ROOT/.runtime-test-logs"

    docker run --rm --privileged \
        -e DEBIAN_FRONTEND=noninteractive \
        -e UCARE_SCENARIOS="$UCARE_SCENARIOS" \
        -e UCARE_RUNTIME_TIMEOUT="$UCARE_RUNTIME_TIMEOUT" \
        -e REPO_ROOT=/workspace \
        -v "$REPO_ROOT:/workspace" \
        -w /workspace \
        "$runtime_base_image" \
        bash -lc '
            set -Eeuo pipefail
            bash scripts/runtime-tests/scenario_runner.sh
        ' | tee "$report_file"

    echo "--- uCareSystem runtime log for $image saved to $report_file ---"

echo "Docker runtime matrix finished successfully"

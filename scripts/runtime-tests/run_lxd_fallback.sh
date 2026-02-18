#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT=${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}
UCARE_LXD_IMAGE=${UCARE_LXD_IMAGE:-"images:ubuntu/24.04"}
UCARE_SCENARIOS=${UCARE_SCENARIOS:-"smoke maintenance"}
UCARE_RUNTIME_TIMEOUT=${UCARE_RUNTIME_TIMEOUT:-1800}
CONTAINER_NAME=${CONTAINER_NAME:-"ucare-runtime-$(date +%s)"}

if ! command -v lxc >/dev/null 2>&1; then
    echo "LXD is not available on this runner"
    exit 3
fi

cleanup() {
    lxc delete --force "$CONTAINER_NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

# Prepare log file name (use image name and timestamp)
safe_tag=$(echo "$UCARE_LXD_IMAGE" | tr '/:@' '---')
timestamp=$(date +%Y%m%d-%H%M%S)
report_file="$REPO_ROOT/.runtime-test-logs/runtime-${timestamp}-${safe_tag}.log"
mkdir -p "$REPO_ROOT/.runtime-test-logs"

echo "=== Runtime tests in LXD image: ${UCARE_LXD_IMAGE} ==="
lxc launch "$UCARE_LXD_IMAGE" "$CONTAINER_NAME"

lxc exec "$CONTAINER_NAME" -- bash -lc 'until ping -c1 archive.ubuntu.com >/dev/null 2>&1; do sleep 1; done'

tar -C "$REPO_ROOT" -cz . | lxc exec "$CONTAINER_NAME" -- bash -lc 'mkdir -p /workspace && tar -xzf - -C /workspace'

lxc exec "$CONTAINER_NAME" -- bash -lc '
    set -Eeuo pipefail
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y --no-install-recommends \
        bash \
        sudo \
        curl \
        lsb-release \
        iputils-ping \
        lsof \
        procps \
        coreutils \
        findutils \
        gawk \
        grep \
        util-linux \
        ca-certificates \
        ncurses-bin \
        tzdata
    cd /workspace
    REPO_ROOT=/workspace UCARE_SCENARIOS="'"$UCARE_SCENARIOS"'" UCARE_RUNTIME_TIMEOUT="'"$UCARE_RUNTIME_TIMEOUT"'" UCARE_LOG_FILE="/workspace/.runtime-test-logs/runtime-'"$timestamp"'-'"$safe_tag"'.log" bash scripts/runtime-tests/scenario_runner.sh
'

# Copy the log file back from the container
lxc file pull "$CONTAINER_NAME"/workspace/.runtime-test-logs/runtime-${timestamp}-${safe_tag}.log "$report_file"

echo "--- uCareSystem runtime log for $UCARE_LXD_IMAGE saved to $report_file ---"

echo "LXD fallback runtime tests finished successfully"

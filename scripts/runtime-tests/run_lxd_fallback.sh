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
    REPO_ROOT=/workspace UCARE_SCENARIOS="'"$UCARE_SCENARIOS"'" UCARE_RUNTIME_TIMEOUT="'"$UCARE_RUNTIME_TIMEOUT"'" bash scripts/runtime-tests/scenario_runner.sh
'

echo "LXD fallback runtime tests finished successfully"

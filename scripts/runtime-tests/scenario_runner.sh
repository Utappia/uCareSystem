#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT=${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}
UCARE_SCENARIOS=${UCARE_SCENARIOS:-"smoke maintenance"}
UCARE_RUNTIME_TIMEOUT=${UCARE_RUNTIME_TIMEOUT:-1800}
UCARE_LOG_DIR=${UCARE_LOG_DIR:-"$REPO_ROOT/.runtime-test-logs"}

mkdir -p "$UCARE_LOG_DIR"
RUN_LOG="$UCARE_LOG_DIR/runtime-$(date +%Y%m%d-%H%M%S).log"
: > "$RUN_LOG"

log() {
    echo "[$(date +%H:%M:%S)] $*" | tee -a "$RUN_LOG"
}

require_cmd() {
    local cmd=$1
    if ! command -v "$cmd" >/dev/null 2>&1; then
        log "Missing required command: $cmd"
        return 1
    fi
}

run_and_capture() {
    local name=$1
    shift

    local cmd_log
    cmd_log=$(mktemp)

    log "Running scenario step: $name"
    if "$@" >"$cmd_log" 2>&1; then
        cat "$cmd_log" >> "$RUN_LOG"
        rm -f "$cmd_log"
        return 0
    fi

    cat "$cmd_log" >> "$RUN_LOG"
    rm -f "$cmd_log"
    log "Step failed: $name"
    return 1
}

assert_no_known_critical_errors() {
    local patterns='command not found|syntax error|no such file or directory|permission denied|Traceback|segmentation fault|core dumped'
    if grep -Eiq "$patterns" "$RUN_LOG"; then
        log "Critical error signature matched in runtime log"
        return 1
    fi

    return 0
}

ensure_root() {
    if [ "${EUID}" -eq 0 ]; then
        return 0
    fi

    if command -v sudo >/dev/null 2>&1; then
        log "Re-running as root via sudo"
        exec sudo --preserve-env=REPO_ROOT,UCARE_SCENARIOS,UCARE_RUNTIME_TIMEOUT,UCARE_LOG_DIR "$0"
    fi

    log "Root privileges are required to run ucaresystem-core"
    return 1
}

run_smoke() {
    require_cmd bash
    require_cmd sh

    cd "$REPO_ROOT"

    run_and_capture "core version" bash src/ucaresystem-core --version
    run_and_capture "core help" bash src/ucaresystem-core --help

    run_and_capture "launcher via sh" env PATH="$REPO_ROOT/src:$PATH" DISPLAY= WAYLAND_DISPLAY= sh src/launch-ucaresystemcore --help
}

run_maintenance() {
    require_cmd timeout

    cd "$REPO_ROOT"

    log "Executing maintenance scenario with timeout ${UCARE_RUNTIME_TIMEOUT}s"
    if ! timeout --signal=SIGINT "$UCARE_RUNTIME_TIMEOUT" bash src/ucaresystem-core >> "$RUN_LOG" 2>&1; then
        log "Maintenance scenario exited non-zero or timed out"
        return 1
    fi
}

main() {
    ensure_root

    local scenario
    for scenario in $UCARE_SCENARIOS; do
        case "$scenario" in
            smoke)
                run_smoke || return 1
                ;;
            maintenance)
                run_maintenance || return 1
                ;;
            *)
                log "Unknown scenario: $scenario"
                return 1
                ;;
        esac
    done

    assert_no_known_critical_errors || return 1
    log "All runtime scenarios passed"
}

main "$@"

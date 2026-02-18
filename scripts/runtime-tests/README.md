# Runtime Compatibility Tests

This directory provides runtime-focused checks for `ucaresystem-core` execution across disposable environments.

## Priority order

1. Docker (primary)
2. LXD (fallback)
3. VM (last resort, manual/self-hosted)

## Scenarios

- `smoke`: checks `--version`, `--help`, and launcher invocation from `sh`
- `maintenance`: runs the default maintenance flow in a disposable environment

## Local usage

Run the default Docker matrix:

```bash
bash scripts/runtime-tests/run_docker_matrix.sh
```

Run LXD fallback explicitly:

```bash
bash scripts/runtime-tests/run_lxd_fallback.sh
```

Override scenarios:

```bash
UCARE_SCENARIOS="smoke" bash scripts/runtime-tests/run_docker_matrix.sh
```

Override image matrix:

```bash
UCARE_DOCKER_IMAGES="ubuntu:22.04 ubuntu:24.04" bash scripts/runtime-tests/run_docker_matrix.sh
```

Docker runner optimization (enabled by default):

- The script builds and reuses a cached runtime base image per source image tag.
- This avoids reinstalling dependencies on repeated runs.

Force cache bypass:

```bash
UCARE_DOCKER_NO_CACHE=1 bash scripts/runtime-tests/run_docker_matrix.sh
```

## Exit codes

- `0`: all selected runtime scenarios passed
- `3`: required platform tool unavailable on runner (used to trigger escalation)
- other non-zero: runtime regression or test failure

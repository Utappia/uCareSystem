# Scripts Directory

This directory contains utility scripts for maintaining the uCareSystem project.

## update_honored_releases.sh

A helper script to update the honored releases tracking files when creating a new version.

### Usage

```bash
./scripts/update_honored_releases.sh VERSION "HONORED_NAME" "RELEASE_DATE" "NOTES"
```

### Example

```bash
./scripts/update_honored_releases.sh 25.08.01 "John Doe" "2025-08-01" "New feature release"
```

This will:
1. Update `HONORED_RELEASES.md` with the new release information
2. Update `scripts/honored_releases.dat` with the new entry
3. Create backup files (.bak)
4. Provide instructions for updating the main script variables

### After running the script

Remember to manually update the following variables in `src/ucaresystem-core`:
- `UCARE_VERSION`
- `VER_CODENAME`
- `PREV_VER`
- `SUPPORTERS` array (if needed)

## Files Structure

- `HONORED_RELEASES.md` - Human-readable markdown file with detailed release history
- `scripts/honored_releases.dat` - Machine-readable data file with pipe-separated values
- `src/ucaresystem-core` - Main script containing current version variables

#!/bin/bash
# Helper script to update honored releases when creating a new version
# Usage: ./update_honored_releases.sh VERSION "HONORED_NAME" "RELEASE_DATE" "NOTES"

set -e

if [ $# -ne 4 ]; then
    echo "Usage: $0 VERSION 'HONORED_NAME' 'RELEASE_DATE' 'NOTES'"
    echo "Example: $0 25.08.01 'John Doe' '2025-08-01' 'New feature release'"
    exit 1
fi

VERSION="$1"
HONORED_NAME="$2"
RELEASE_DATE="$3"
NOTES="$4"

# Check if files exist
if [ ! -f "HONORED_RELEASES.md" ] || [ ! -f "scripts/honored_releases.dat" ]; then
    echo "Error: HONORED_RELEASES.md or scripts/honored_releases.dat not found"
    echo "Please run this script from the project root directory"
    exit 1
fi

# Backup files
cp HONORED_RELEASES.md HONORED_RELEASES.md.bak
cp scripts/honored_releases.dat scripts/honored_releases.dat.bak

echo "Updating honored releases files..."

# Update the markdown file
# Find the line with "### Version" and "Current" and replace it
sed -i "/^### Version.*Current)$/c\\
### Version $VERSION (Current)\\
- **Honored To**: $HONORED_NAME\\
- **Release Date**: $RELEASE_DATE\\
- **Notes**: $NOTES" HONORED_RELEASES.md

# Remove "(Current)" from the previous version line
sed -i '0,/^### Version.*Current)$/! s/^### Version \([0-9.]*\) (Current)$/### Version \1/' HONORED_RELEASES.md

# Add new entry to data file
sed -i "1i\\
$VERSION|$HONORED_NAME|$RELEASE_DATE|$NOTES" scripts/honored_releases.dat

echo "Files updated successfully!"
echo "Please review the changes and update the ucaresystem-core script variables:"
echo "- UCARE_VERSION=\"$VERSION\""
echo "- VER_CODENAME=\"$HONORED_NAME\""
echo "- PREV_VER should be updated to the previous version"
echo ""
echo "Backups created: HONORED_RELEASES.md.bak and scripts/honored_releases.dat.bak"

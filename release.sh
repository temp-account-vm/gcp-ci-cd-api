#!/bin/bash

set -e

LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "Dernier tag : $LAST_TAG"

NEW_TAG=$(echo $LAST_TAG | awk -F. '{printf "v%d.%d.%d", $1, $2, $3+1}')
echo "Nouveau tag : $NEW_TAG"

echo "## Changelog $NEW_TAG" > CHANGELOG.md
git log $LAST_TAG..HEAD --pretty=format:"- %s" >> CHANGELOG.md

git add CHANGELOG.md
git commit -m "chore(release): $NEW_TAG [skip ci]"
git tag $NEW_TAG

git push origin main --tags
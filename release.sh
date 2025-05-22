#!/bin/bash
set -e

git fetch --tags --force

LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "Dernier tag : $LAST_TAG"

NEW_TAG=$(echo "$LAST_TAG" | sed 's/^v//' | awk -F. '{printf "v%d.%d.%d", $1, $2, $3+1}')
echo "Nouveau tag : $NEW_TAG"

if git rev-parse "$NEW_TAG" >/dev/null 2>&1; then
  echo "Le tag $NEW_TAG existe déjà. Annulation."
  exit 0
fi

echo "## Changelog $NEW_TAG" > CHANGELOG.md
git log "${LAST_TAG}..HEAD" --pretty=format:"- %s" >> CHANGELOG.md || true

echo "--- Contenu de CHANGELOG.md ---"
cat CHANGELOG.md

git add CHANGELOG.md
git commit -m "chore(release): $NEW_TAG [skip ci]"
git tag "$NEW_TAG"

#!/bin/bash
set -e

git fetch --tags

if git describe --tags --abbrev=0 >/dev/null 2>&1; then
  LAST_TAG=$(git describe --tags --abbrev=0)
  FROM_REF="$LAST_TAG..HEAD"
else
  echo "Aucun tag trouvé. Première release."
  LAST_TAG="v0.0.0"
  FROM_REF=""
fi

echo "Dernier tag : $LAST_TAG"

NEW_TAG=$(echo $LAST_TAG | sed 's/^v//' | awk -F. '{printf "v%d.%d.%d", $1, $2, $3+1}')
echo "Nouveau tag : $NEW_TAG"

echo "## Changelog $NEW_TAG" > CHANGELOG.md

if [ -n "$FROM_REF" ]; then
  git log $FROM_REF --pretty=format:"- %s" >> CHANGELOG.md
else
  git log --pretty=format:"- %s" >> CHANGELOG.md
fi

echo "--- Diff de CHANGELOG.md ---"
git diff CHANGELOG.md || true

if ! git diff --quiet CHANGELOG.md; then
  git add CHANGELOG.md
  git commit -m "chore(release): $NEW_TAG [skip ci]"
  git tag $NEW_TAG
else
  echo "Pas de nouveau changelog, pas de commit ni de tag."
fi

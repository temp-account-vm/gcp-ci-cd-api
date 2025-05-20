#!/usr/bin/env bash

# 2. Versionning
TAG="v$(date +'%Y.%m.%d')"
git tag $TAG && git push origin $TAG

# 3. Générer changelog
npx standard-version --release-as minor

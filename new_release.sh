#!/bin/bash

export NEW_VERSION=${NEW_VERSION}
sed -i "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml
git add pubspec.yaml && git commit -m "Bumping version to v${NEW_VERSION}" && git push
git tag "v${NEW_VERSION}" && git push origin "v${NEW_VERSION}"

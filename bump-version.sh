#!/bin/bash
VERSION=$(date '+%Y-%m-%d')
echo $VERSION > VERSION_NAME
git add VERSION_NAME
git commit -m "Bump to $VERSION"
git tag -s -m "$VERSION" "$VERSION" HEAD

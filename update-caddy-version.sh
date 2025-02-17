#!/bin/sh

set -eu

echo "Checking Caddy"

# Get current version from Dockerfile
VERSION="$(sed -n 's/^FROM caddy:\([0-9.]*\)$/\1/p' Dockerfile)"
echo "Current version: $VERSION"

# Get latest version from GitHub
LATEST="$(
  curl -s 'https://github.com/caddyserver/caddy/releases' |
    sed -n 's_^.*href="/caddyserver/caddy/tree/v\([^"-]*\)".*$_\1_p' |
    head -n1
)"
echo "Latest version:  $LATEST"

# Check if we want to update
if [ "$LATEST" != "$VERSION" ]; then
  echo "Caddy $VERSION -> $LATEST"

  # Get version segments
  MAJOR="$(echo "$LATEST" | cut -d. -f1)"
  MINOR="$(echo "$LATEST" | cut -d. -f2)"
  PATCH="$(echo "$LATEST" | cut -d. -f3)"

  # Print executed commands
  set -x

  # Set new version and commit
  sed -i "s/FROM caddy:${VERSION}/FROM caddy:${LATEST}/" Dockerfile
  git commit Dockerfile -m "Update caddy to ${LATEST}"

  # Tag version
  git tag "$LATEST"
  git tag --force "${MAJOR}.${MINOR}"
  git tag --force "${MAJOR}"

  # Push changes
  git push
  git push origin "$LATEST"
  git push origin --force "${MAJOR}.${MINOR}"
  git push origin --force "${MAJOR}"
fi

#!/usr/bin/env bash
set -e

# See https://github.com/platformsh/legacy-cli/releases for version numbers
# and SHA-256 hashes.
version="4.28.2"
sha256="30a43806809056aa8369e304743eb3c086ed382fa3dcc8745fac82470321e670"

# Install the Platform.sh CLI.
if [ ! -f /usr/local/bin/platform ] || [[ ! "$(platform --version)" == *"$version" ]]; then
  echo "Downloading the Platform.sh CLI version $version"
  curl -sfSL -o platform.phar https://github.com/platformsh/legacy-cli/releases/download/v"$version"/platform.phar
  if [[ "$(shasum -a 256 platform.phar 2>/dev/null)" != "$sha256"* ]]; then
    echo "SHA256 checksum mismatch for platform.phar"
    exit 1
  fi
  chmod +x platform.phar
  mv platform.phar /usr/local/bin/platform
fi

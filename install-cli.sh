#!/usr/bin/env bash
set -e

# See https://github.com/platformsh/legacy-cli/releases for version numbers
# and SHA-256 hashes.
version="4.7.2"
sha256="7df2eb82ab34d8f6e9de9e7a572c8e65a33463ae9ed34cc8d2a154accb7ec768"

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

#!/usr/bin/env bash
set -e

# See https://github.com/platformsh/platformsh-cli/releases for version numbers
# and SHA-256 hashes.
version="3.82.2"
sha256="40d5853b958d30a895a884b1b062ea7ae5701063823b5dcb33c612e115311ac0"

# Install the Platform.sh CLI.
if [ ! -f /usr/local/bin/platform ] || [[ ! "$(platform --version)" == *"$version" ]]; then
  echo "Downloading the Platform.sh CLI version $version"
  curl -sfSL -o platform.phar https://github.com/platformsh/platformsh-cli/releases/download/v"$version"/platform.phar
  if [[ "$(shasum -a 256 platform.phar 2>/dev/null)" != "$sha256"* ]]; then
    echo "SHA256 checksum mismatch for platform.phar"
    exit 1
  fi
  chmod +x platform.phar
  mv platform.phar /usr/local/bin/platform
fi

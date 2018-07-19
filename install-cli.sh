#!/usr/bin/env bash
set -e

# See https://github.com/platformsh/platformsh-cli/releases for version numbers
# and SHA-256 hashes.
version="3.34.0"
sha256="21fa3b8612b5b89c9bf82b213bcc72f50bd72ee97153042edab24d3a03e8efc4"

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

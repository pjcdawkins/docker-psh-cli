#!/usr/bin/env bash
set -e

# See https://github.com/platformsh/legacy-cli/releases for version numbers
# and SHA-256 hashes.
version="4.23.0"
sha256="2723c13c2c9abec9913b2501ab83845c248ff32ab8b3473c8b51596f715dd092"

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

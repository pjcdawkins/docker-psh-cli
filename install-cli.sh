#!/usr/bin/env bash
set -e

# See https://github.com/platformsh/platformsh-cli/releases for version numbers
# and SHA-256 hashes.
version="3.50.0"
sha256="f624181167f2f782f0e456111442cf764c81ef52cb5f6e6547e654b97639f9ed"

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

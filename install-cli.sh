#!/usr/bin/env bash
set -e

# See https://github.com/platformsh/platformsh-cli/releases for version numbers
# and SHA-256 hashes.
version="3.75.1"
sha256="e584ef412e1eb5ac62074f85fb616adae17d629811b6868df11bc83b21c2c4eb"

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

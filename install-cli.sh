#!/usr/bin/env bash
set -e

version="3.19.0"
sha1="4fe9b0465ca33513b4cb7b94209314e6845786a5"

# Install the Platform.sh CLI.
if [ ! -f /usr/local/bin/platform ] || [[ ! "$(platform --version)" == *"$version" ]]; then
  echo "Downloading the Platform.sh CLI version $version"
  curl -sfSL -o platform.phar https://github.com/platformsh/platformsh-cli/releases/download/v"$version"/platform.phar
  if [[ "$(shasum platform.phar 2>/dev/null)" != "$sha1"* ]]; then
    echo "SHA1 checksum mismatch for platform.phar"
    exit 1
  fi
  chmod +x platform.phar
  mv platform.phar /usr/local/bin/platform
fi

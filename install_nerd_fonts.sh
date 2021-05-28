#!/bin/bash

set -e

# Set source and target directories
downloaded_fonts_dir="/tmp/downloaded_fonts_dir"

mkdir -p "${downloaded_fonts_dir}"
pushd "${downloaded_fonts_dir}"

wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

if test "$(uname)" = "Darwin" ; then
  # MacOS
  target_fonts_dir="$HOME/Library/Fonts"
else
  # Linux
  target_fonts_dir="$HOME/.local/share/fonts"
  mkdir -p "${target_fonts_dir}"
fi

# Copy all fonts to user fonts directory
echo "Copying nerd fonts..."
cp "${downloaded_fonts_dir}/*.ttf" "${target_fonts_dir}"

# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$target_fonts_dir"
fi

popd
echo "Installed nerd fonts to $target_fonts_dir"

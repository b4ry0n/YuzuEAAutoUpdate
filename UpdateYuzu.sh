#! /bin/bash

YUZU_DIR=/home/deck/Applications
YUZU_EA="$YUZU_DIR"/yuzu-pea.AppImage
PINEAPPLE_DIR="$YUZU_DIR"/pineappleEA

# Check if internet access exists
if ping -q -c 1 -W 1 google.com >/dev/null; then

    mkdir -p $PINEAPPLE_DIR

    asset=$(curl -s https://api.github.com/repos/pineappleEA/pineapple-src/releases/latest | jq -r '.assets[] | select(.name|endswith(".AppImage"))')

    filename=$(jq -nr --argjson asset "$asset" '$asset.name')
    download_url=$(jq -nr --argjson asset "$asset" '$asset.browser_download_url')

    if [[ ! -e "$PINEAPPLE_DIR/$filename" ]]; then

        # Download latest Yuzu EA
        curl -sL "$download_url" -o "$PINEAPPLE_DIR/$filename"

        # Give it executable permissions
        chmod +x "$PINEAPPLE_DIR/$filename"

        # Link to YUZU_EA
        ln -srf "$PINEAPPLE_DIR/$filename" "$YUZU_EA"
    fi

fi

# Launch Yuzu EA
"$YUZU_EA" "$@"

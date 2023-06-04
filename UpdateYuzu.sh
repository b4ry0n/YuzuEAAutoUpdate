#! /bin/bash

APP_DIR="$HOME"/Applications
YUZU_EA_LATEST="$APP_DIR"/yuzu-ea-latest.AppImage
YUZU_EA_DIR="$APP_DIR"/YuzuEA

# Check if internet access exists
if ping -q -c 1 -W 1 google.com >/dev/null; then

    mkdir -p "$YUZU_EA_DIR"

    asset=$(curl -s https://api.github.com/repos/pineappleEA/pineapple-src/releases/latest | jq -r '.assets[] | select(.name|endswith(".AppImage"))')

    filename=$(jq -nr --argjson asset "$asset" '$asset.name')
    download_url=$(jq -nr --argjson asset "$asset" '$asset.browser_download_url')

    if [[ ! -e "$YUZU_EA_DIR/$filename" ]]; then

        # Download latest Yuzu EA
        curl -sL "$download_url" -o "$YUZU_EA_DIR/$filename"

        # Give it executable permissions
        chmod +x "$YUZU_EA_DIR/$filename"

        # Link to latest
        ln -srf "$YUZU_EA_DIR/$filename" "$YUZU_EA_LATEST"
    fi

fi

# Launch Yuzu EA latest
"$YUZU_EA_LATEST" "$@"

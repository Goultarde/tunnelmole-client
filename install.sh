#!/bin/bash

# Tunnelmole Installation Script with IPv6 Fix
# Repository: https://github.com/Goultarde/tunnelmole-client

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing Tunnelmole with IPv6 fix...${NC}"

# Detect architecture
ARCH=$(uname -m)
OS=$(uname -s)

# Determine binary
case "${OS}" in
    "Linux")
        case "${ARCH}" in
            "x86_64"|"amd64")
                BINARY="tmole-linux-amd64"
                ;;
            "aarch64"|"arm64")
                BINARY="tmole-linux-arm64"
                ;;
            *)
                echo "Unsupported architecture: ${ARCH}"
                exit 1
                ;;
        esac
        ;;
    "Darwin")
        BINARY="tmole-macos-arm64"
        ;;
    *)
        echo "Unsupported OS: ${OS}"
        exit 1
        ;;
esac
echo "Selected binary: ${BINARY}"
# Download and install
echo "Downloading ${BINARY}..."

# Download from GitHub release
curl -L -s "https://github.com/Goultarde/tunnelmole-client/releases/download/tmole/${BINARY}" --output "${BINARY}"

if [ ! -f "${BINARY}" ] || [ $(stat -c%s "${BINARY}") -lt 1000000 ]; then
    echo "Download failed. Please check if the release exists on GitHub."
    echo "Repository: https://github.com/Goultarde/tunnelmole-client"
    exit 1
fi

chmod +x "${BINARY}"
mv "${BINARY}" tmole
sudo mv tmole /usr/local/bin/tmole
sudo ln -sf /usr/local/bin/tmole /usr/local/bin/tunnelmole

if test -f /usr/local/bin/tmole; then
    echo ""
    echo -e "${GREEN}  _______                     _                 _      ${NC}";
    echo -e "${GREEN} |__   __|                   | |               | |     ${NC}";
    echo -e "${GREEN}    | |_   _ _ __  _ __   ___| |_ __ ___   ___ | | ___ ${NC}";
    echo -e "${GREEN}    | | | | | '_ \| '_ \ / _ \ | '_ \` _ \ / _ \| |/ _ \ ${NC}";
    echo -e "${GREEN}    | | |_| | | | | | | |  __/ | | | | | | (_) | |  __/${NC}";
    echo -e "${GREEN}    |_|\__,_|_| |_|_| |_|\___|_|_| |_| |_|\___/|_|\___|${NC}";
    echo -e "${GREEN}                                                       ${NC}";
    echo ""
    echo -e "${GREEN}Congrats! Tunnelmole is now installed 😃${NC}"
    echo ""
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo -e "${BLUE}  tmole <port>                    # Random URL${NC}"
    echo -e "${BLUE}  tmole 80 as mysite.tunnelmole.net  # Custom domain${NC}"
    echo ""
    echo -e "${YELLOW}Repository: https://github.com/Goultarde/tunnelmole-client${NC}"
else
    echo "Installation failed. Check your internet connection and sudo access."
    exit 1
fi

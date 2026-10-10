#!/usr/bin/env bash

set -e

# Intended as global settings hence the prefix
LONELY_CLAUDE_CPUS="${LONELY_CLAUDE_CPUS:-2}"
LONELY_CLAUDE_MEMORY="${LONELY_CLAUDE_MEMORY:-4}"
LONELY_CLAUDE_DISK="${LONELY_CLAUDE_DISK:-20}"


# Override during call to use something else besides current directory
WORKING_DIR="${TARGET_PATH:-$PWD}"

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
VM_NAME=$(${SCRIPT_DIR}/lonely-claude-vm-name.sh)

if ! [ "$(limactl list --format '{{.Status}}' $VM_NAME 2>/dev/null)" = "Running" ]; then
    if limactl list -q | grep -qx $VM_NAME; then
        limactl start $VM_NAME
        limactl shell $VM_NAME -- sudo apt-get update -y
        limactl shell $VM_NAME -- sudo apt-get upgrade -y

    else 
        limactl create --name=$VM_NAME \
            --mount-only ${WORKING_DIR}:w \
            --cpus=$LONELY_CLAUDE_CPUS --memory=$LONELY_CLAUDE_MEMORY --disk=$LONELY_CLAUDE_DISK \
            template:debian-13
        limactl start $VM_NAME
        limactl shell $VM_NAME -- sudo apt-get update -y
        limactl shell $VM_NAME -- sudo apt-get upgrade -y
        limactl shell $VM_NAME -- sudo apt-get install -y git ripgrep curl ca-certificates build-essential
        limactl shell $VM_NAME -- bash -c 'curl -fsSL https://claude.ai/install.sh | bash'
        limactl shell $VM_NAME -- bash -c 'echo "export PATH=\$HOME/.local/bin:\$PATH" >> ~/.bash_profile'

        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | limactl shell $VM_NAME -- sh -s -- -y

    fi
fi

exec limactl shell --workdir "$PWD" $VM_NAME bash -lc 'claude "$@"' _ "$@"

#!/usr/bin/env bash

set -e

# Override during call to use something else besides current directory
WORKING_DIR="${TARGET_PATH:-$PWD}"

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
VM_NAME=$(${SCRIPT_DIR}/lonely-claude-vm-name.sh)

limactl stop $VM_NAME

#!/usr/bin/env bash

set -e

WORKING_DIR="${TARGET_PATH:-$PWD}"

WORKING_DIR_HASH=$(echo -n "$WORKING_DIR" | sha256sum | cut -c1-12)
DIR_NAME=$(basename "$WORKING_DIR")
echo ${DIR_NAME}-${WORKING_DIR_HASH}

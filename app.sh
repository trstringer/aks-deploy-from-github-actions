#!/bin/bash

SCRIPT_PATH=$(dirname "$(realpath "$0")")
VERSION=$(cat "${SCRIPT_PATH}/version")

while true; do
    echo "$(date) - Current version is $VERSION"
    sleep 5
done

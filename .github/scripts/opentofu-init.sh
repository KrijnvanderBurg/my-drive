#!/bin/bash
set -e

STATE_KEY="${1:?Error: State key parameter is required}"

echo "Initializing with state key: ${STATE_KEY}"
tofu init -backend-config="key=${STATE_KEY}"

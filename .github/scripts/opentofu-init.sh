#!/bin/bash
target_path="${1:-}" && echo "Initializing OpenTofu in: $target_path"

tofu init

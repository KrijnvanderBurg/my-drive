#!/bin/bash
target_path="${1:-$PWD/infrastructure}" && echo "Initializing OpenTofu in: $target_path"

tofu init

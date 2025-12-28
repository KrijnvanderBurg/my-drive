#!/bin/bash
target_path="${1:?Target path is required}"
var_file="${2:-}"

source "$(dirname "$0")/opentofu-install.sh"

cd "$target_path" || exit 1

plan_binary_file="/tmp/tfplan"
plan_text_file="/tmp/tfplan.txt"

tofu plan -no-color -out="$plan_binary_file" ${var_file:+-var-file="$var_file"} 2>&1 | tee "$plan_text_file"
exitcode=${PIPESTATUS[0]}

echo "plan_file=$plan_text_file" >> "$GITHUB_OUTPUT"
echo "plan_binary_file=$plan_binary_file" >> "$GITHUB_OUTPUT"

exit $exitcode

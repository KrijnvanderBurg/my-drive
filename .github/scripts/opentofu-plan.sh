#!/bin/bash
target_path="${1:?Target path is required}"
var_file="${2:-}"
plan_binary_file="${3:?Plan binary file path is required}"
plan_text_file="${4:?Plan text file path is required}"
pr_number="${5:-}"

source "$(dirname "$0")/opentofu-install.sh"

cd "$target_path" || exit 1

tofu plan -no-color -out="$plan_binary_file" ${var_file:+-var-file="$var_file"} ${pr_number:+-var="pr_number=$pr_number"} 2>&1 | tee "$plan_text_file"
exitcode=${PIPESTATUS[0]}

echo "plan_text_file=$plan_text_file" >> "$GITHUB_OUTPUT"
echo "plan_binary_file=$plan_binary_file" >> "$GITHUB_OUTPUT"

exit $exitcode

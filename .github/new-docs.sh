#!/bin/bash
declare -r diff=$(git diff --ignore-cr-at-eol --numstat HEAD docs | grep "\.html$")
echo "$diff"

declare -r changes=$(echo "$diff" | grep -Pv "1\s1" | wc -l)
echo "$changes"
if (( $changes > 0 )); then
	echo "::set-output name=status::change"
	exit 0
fi

echo "::set-output name=status::nochange"
exit 0
#!/bin/bash
declare -r changes=$(git diff --ignore-cr-at-eol --numstat HEAD docs | grep "\.html$" | grep -Pv "1\s1" | wc -l)
if (( $changes > 0 )); then
	echo "::set-output name=status::change"
	exit 0
fi

echo "::set-output name=status::nochange"
exit 0
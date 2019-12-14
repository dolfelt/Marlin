#!/bin/sh

. some-scripts/allted-env

for branch in $ALLTED_BRANCHES; do
	dir=config/examples/$(echo $branch | sed 's@_@/@')
	mkdir -p "$dir"
	cp config/default/* "$OUT/_Bootscreen.h" "$dir"
done

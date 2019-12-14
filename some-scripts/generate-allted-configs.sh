#!/bin/sh

. some-scripts/allted-env

set -e

for branch in $ALLTED_BRANCHES; do
	echo -n "Generating $branch ..."
	PATH=$PATH:buildroot/bin sh "$OUT/$branch"_config.sh
	dir=config/examples/$(echo $branch | sed 's@_@/@')
	mkdir -p "$dir"
	cp Marlin/Configuration{.h,_adv.h} "$OUT/_Bootscreen.h" $dir
	echo " done"
done

#!/bin/sh

. some-scripts/allted-env

mkdir -p "$OUT"
for branch in $ALLTED_BRANCHES; do
	git checkout $ALLTED_REMOTE/$branch || exit 2
	( for f in Configuration.h Configuration_adv.h; do
		diff -u config/default/$f Marlin/$f
	  done ) > "$OUT/$branch"_config.patch
	sh some-scripts/extract-config.sh > "$OUT/$branch"_config.sh
	git reset --hard
done

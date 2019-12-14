#!/bin/sh

. some-scripts/allted-env

for branch in $ALLTED_BRANCHES; do
        dir=config/examples/$(echo $branch | sed 's@_@/@')
	cat "$OUT/$branch"_config.patch | (cd "$dir" && patch -p1 --merge)
done

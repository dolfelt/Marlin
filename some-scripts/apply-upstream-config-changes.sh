#!/bin/sh

[ -z "$1" ] && set -- config/examples/{MPCNC,MP3DP,ZenXY}

find "$@" -name "Configuration.h" -printf 'git diff HEAD..origin/2.0.x config/default | git apply -p3 --index -3 --directory="%h"\n' | sh

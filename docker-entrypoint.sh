#!/usr/bin/env bash
set -eo pipefail

export LC_COLLATE=C

case "$1" in
    gulp|npm)
        gosu node npm install
        set -- gosu node "$@"
        ;;
esac

exec "$@"

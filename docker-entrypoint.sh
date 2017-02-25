#!/usr/bin/env bash
set -eo pipefail

# Fix permissions if needed.
find /app ! -user app -exec chown app:app {} \;

case "$1" in
    npm|gulp|webpack|-)
        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        gosu node npm install

        set -- gosu node "$@"
        ;;
esac

exec "$@"

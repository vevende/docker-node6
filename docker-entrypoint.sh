#!/usr/bin/env bash
set -eo pipefail

# Fix permissions if needed.
find /app ! -user $APP_USER -exec chown $APP_USER:$APP_USER {} \;

case "$1" in
    npm|gulp|webpack|-)
        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        gosu $APP_USER npm install

        set -- gosu $APP_USER "$@"
        ;;
esac

exec "$@"

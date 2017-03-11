#!/usr/bin/env bash
set -eo pipefail

# Fix permissions if needed.
find /app ! -user $APP_USER -exec chown $APP_USER:$APP_USER {} \;

update-node-env() {
    if [ -f /app/package.json ] && [ ! -d /app/node_modules ]; then
    echo -n "* Installing packages"
    cd /app && gosu $APP_USER npm install
    echo "[Done]"
    fi
}

export -f update-node-env

case "$1" in
    npm|gulp|webpack|-)
        update-node-env

        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        set -- gosu $APP_USER "$@"
        ;;
esac

exec "$@"

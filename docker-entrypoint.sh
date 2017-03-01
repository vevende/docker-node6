#!/usr/bin/env bash
set -eo pipefail

# Fix permissions if needed.
find /app ! -user $APP_USER -exec chown $APP_USER:$APP_USER {} \;

update-node-env() {
    if [ -f /app/package.json ]; then
    echo -n "* Installing packages"
    gosu app npm install /app/package.json
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

        gosu $APP_USER npm install

        set -- gosu $APP_USER "$@"
        ;;
esac

exec "$@"

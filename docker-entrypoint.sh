#!/bin/sh
set -eo pipefail
shopt -s nullglob

for f in /docker-entrypoint.d/*; do
    case "$f" in
        *.sh)
            echo "$0: running $@"
            . "$f";
            echo "$0: completed $@" ;;
        *.js)
            echo "$0: running: $@";
            gosu ${APP_USER} node "$f";
            echo "$0: completed $@" ;;
        *) echo "$0: ignoring $f" ;;
    esac
done

case "$1" in
    npm|gulp|webpack|-)
        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        set -- gosu $APP_USER "$@"
        ;;
esac

echo "running: $@"
exec "$@"

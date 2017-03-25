#!/bin/sh
set -eo pipefail

for f in /docker-entrypoint.d/*; do
    # Deals with dash not having support for nullglob
    if [ ! -e "$f" ] ; then
        continue
    fi

    case "$f" in
        *.sh)
            echo "$0: running $f"
            . "$f";
            echo "$0: completed $f" ;;
        *.js)
            echo "$0: running: $f";
            gosu node node "$f";
            echo "$0: completed $f" ;;
        *) echo "$0: ignoring $f" ;;
    esac
done

case "$1" in
    npm|gulp|webpack|-)
        # Cleanup shortcut
        if [ ${1} = '-' ]; then
            shift
        fi

        set -- gosu node "$@"
        ;;
esac

echo "running: $@"
exec "$@"

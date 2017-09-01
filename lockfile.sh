
set -C # Sets the noclobber option
lockfile="/tmp/locktest.lock"
if echo "$$" > "$lockfile"; then
    echo "Successfully acquired lock"
    # do work
    rm "$lockfile" # or via trap:
    # trap 'rm "$lockfile"' EXIT
else
    echo "Cannot acquire lock - already locked by $(cat "$lockfile")"
fi



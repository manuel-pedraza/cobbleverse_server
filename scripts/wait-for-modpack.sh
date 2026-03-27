#!/bin/sh
set -e

READY_FILE="/modpack/.ready-${SERVER_WORLDNAME}"

cleanup() {
    echo "[shutdown] Starting cleanup..."

    # Don't crash if commands fail
    set +e

    if command -v rcon-cli >/dev/null 2>&1; then
        rcon-cli tellraw @a '{"text":"Server shutting down...","color":"red"}'
        rcon-cli save-all
        sleep 5
        rcon-cli stop
    else
        echo "[shutdown] rcon-cli not available"
    fi

    # if [ -n "$child" ]; then
    #     wait "$child"
    # fi

    echo "[shutdown] Backing up world..."

    mkdir -p /backup

    WORLD_DIR=$(dirname "$(find /data -type f -name "level.dat" | head -n 1)")

    echo "[shutdown] World dir detected: $WORLD_DIR"

    mkdir -p /backup

    tar -czf /backup/world.tar.gz -C "$WORLD_DIR" .

    echo "[shutdown] Backup complete"

    exit 0
}

# Trap container stop
trap cleanup TERM INT

echo "[wait-for-modpack] Waiting for modpack install..."

while [ ! -f "$READY_FILE" ]; do
  sleep 1
done

echo "[start] Modpack ready. Starting Minecraft..."

cron -l 2 &

# Start server in background (IMPORTANT: no exec)
/start &
child=$!

# Wait for server process
wait $child
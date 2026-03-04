#!/bin/sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

PID_FILE="/tmp/home-kindle-trmnl/trmnl-client.pid"

# Create temp directory (if it doesn't already exist).
mkdir -p "/tmp/home-kindle-trmnl"

# Nothing to do if a PID file exists and it points to an existing process.
if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
	exit 0
fi

# Run the TRMNL client.
"$(dirname "$0")/trmnl-client.sh" &

# Store the process ID so we can use it to stop later.
echo $! > "$PID_FILE"

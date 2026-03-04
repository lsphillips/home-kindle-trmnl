#!/bin/sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

PID_FILE="/tmp/home-kindle-trmnl/trmnl-client.pid"

# Nothing to do if the PID file does not exist.
if [ ! -f "$PID_FILE" ]; then
	exit 0
fi

PID="$(cat "$PID_FILE")"

# Nothing to do if the process in the PID does not exist.
if ! kill -0 "$PID" 2>/dev/null; then
	rm -f "$PID_FILE"
	exit 0
fi

# Stop.
kill "$PID"

# Clean up.
rm -f "$PID_FILE"

#!/bin/sh

# Settings
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

API_KEY="<api-key>"
BASE_URL="<base-url>"
DEBUG=false
APP_DIR="/mnt/us/home-kindle-trmnl"
LOG_DIR="$APP_DIR/logs"

# Utility Functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

log() {
	if [ "$DEBUG" = "true" ]; then
		local name=$(date '+%Y-%m-%d')
		echo "$(date '+%H:%M:%S') - $1" >> "$LOG_DIR/$name.log"
	fi
}

get_firmware_version() {
	if [ -f /etc/prettyversion.txt ]; then
		head -n1 /etc/prettyversion.txt | awk '{print $2}'
	else
		echo "0.0.0"
	fi
}

get_model() {
	echo "Kindle"
}

get_screen_width() {
	local result=$(eips -i)
	echo "$result" | grep "xres:" | head -1 | awk '{print $2}' | tr -d ','
}

get_screen_height() {
	local result=$(eips -i)
	echo "$result" | grep "yres:" | head -1 | awk '{print $4}' | tr -d ','
}

get_mac_address() {
	local address=$(cat /sys/class/net/wlan0/address | tr '[:lower:]' '[:upper:]')
	echo "$address"
}

get_battery_level() {
	local result=$(lipc-get-prop com.lab126.powerd status)
	echo "$result" | grep "Battery Level:" | cut -d ":" -f2 | tr -d '% '
}

get_signal_strength() {
	grep "wlan0" /proc/net/wireless | awk '{print $4}' | tr -d '.'
}

# Client
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create application directories.
mkdir -p "$APP_DIR"
mkdir -p "$LOG_DIR"

# Fetch device information.
WIDTH=$(get_screen_width)
HEIGHT=$(get_screen_height)
MAC_ADDRESS=$(get_mac_address)
MODEL=$(get_model)
FIRMWARE_VERSION=$(get_firmware_version)

log "Width: $WIDTH"
log "Height: $HEIGHT"
log "MAC Address: $MAC_ADDRESS"
log "Model: $MODEL"
log "Firmware: $FIRMWARE_VERSION"

while true; do

	# Fetch signal strength & battery level.
	RSSI=$(get_signal_strength)
	BATTERY=$(get_battery_level)

	log "RSSI: $RSSI"
	log "Battery: $BATTERY"

	# Fetch next screen.
	SCREEN=$(
		curl -s --connect-timeout 5 \
		  -H "access-token: $API_KEY" \
		  -H "battery-voltage: $BATTERY" \
		  -H "width: $WIDTH" \
		  -H "height: $HEIGHT" \
		  -H "rssi: $RSSI" \
		  -H "id: $MAC_ADDRESS" \
		  -H "model: $MODEL" \
		  -H "fw-version: $FIRMWARE_VERSION" \
		"${BASE_URL}/api/display"
	)

	if [ -z "$SCREEN" ]; then
		log "Screen request failed. Waiting for 30 seconds to try again."
		sleep 30
		continue
	fi

	# Parse screen response.
	IMAGE_URL=$(echo "$SCREEN" | sed -n 's/.*"image_url":"\([^"]*\)".*/\1/p' | sed 's/\\u0026/\&/g')
	REFRESH_RATE=$(echo "$SCREEN" | sed -n 's/.*"refresh_rate":\([^,}]*\).*/\1/p')

	log "Image URL: $IMAGE_URL"
	log "Refresh Rate: $REFRESH_RATE"

	if [ -z "$IMAGE_URL" ]; then
		log "Screen image could not be found in the screen response. Waiting for 30 seconds to try again."
		sleep 30
		continue
	fi

	if [ -z "$REFRESH_RATE" ]; then
		log "Screen refresh rate could not be found in the screen response. Defaulting to 30 seconds."
		REFRESH_RATE="30"
	fi

	# Download screen image.
	if ! curl -s --connect-timeout 5 -o "$APP_DIR/screen.tmp.png" "$IMAGE_URL" || [ ! -s "$APP_DIR/screen.tmp.png" ]; then
		rm -f "$APP_DIR/screen.tmp.png"
		log "Failed to download screen image. Waiting for 30 seconds to try again."
		sleep 30
		continue
	fi

	mv "$APP_DIR/screen.tmp.png" "$APP_DIR/screen.png"

	log "Downloaded screen image successfully."

	# Clear screen.
	eips -c
	sleep 1

	# Render screen image.
	eips -g "$APP_DIR/screen.png" -x "0" -y "0"

	log "Rendered screen image successfully."

	# Prevent screen saver.
	lipc-set-prop com.lab126.powerd touchScreenSaverTimeout 2147483647
	lipc-set-prop com.lab126.powerd preventScreenSaver 1

	# Sleep until we should fetch the next screen.
	sleep "$REFRESH_RATE"

done

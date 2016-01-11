#!/bin/bash

##
# MQTT-to-MPD Proxy
#   heavily based on https://bitbucket.org/dmn/mmh
#   https://bitbucket.org/dmn/mmh/src/63148ff9254b05c9ba7db61ae6a43032452fcc7f/mqtt-listener.sh?at=default&fileviewer=file-view-default
#

# include config.sh 
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "${SCRIPT_DIR}/config.sh"
if [[ "$?" != "0" ]]; then
	echo 'config.sh not found' ; exit 2
fi
# 

cmd="mpc"

handle_code() {
	echo "handling $*"
	#pub "handling $1"

	case $1 in
		'play' )
			( $cmd play ) &
			;;
		'pause' )
			( $cmd pause ) &
			;;
		'next' )
			( $cmd next ) &
			;;
		'previous' )
			( $cmd prev ) &
			;;
		'toggle' )
			($cmd toggle ) &
			;;
		'volume up' )
			( $cmd volume '+2' ) &
			;;
		'volume down' )
			( $cmd volume '-2' ) &
			;;
	esac
}

read_next_line() {
	read LINE
	local RET=$?
	LINE="${LINE//%20/ }"
	return $RET
}

read_sub() {
	while read_next_line; do
		handle_code "$LINE"
	done
}

mosquitto_sub -h $MQTT_HOST -t $MQTT_LISTEN_TOPIC | read_sub

#!/bin/sh
## Startup script for tor.

set -E

###############################################################################
# Environment
###############################################################################

TOR_CONF="/config/torrc"
TOR_LOGS="/var/log/tor"
TOR_PASS="/var/lib/tor"

###############################################################################
# Script
###############################################################################
echo $TOR_ENABLED
if [ "$TOR_ENABLED" = 1 ]; then

  echo "Initializing Tor"

  ## Create missing paths.
  [ ! -d "$TOR_LOGS" ] && mkdir -p -m 700 $TOR_LOGS
  [ ! -d "$TOR_PASS" ] && mkdir -p -m 700 $TOR_PASS

  ## Start tor then tail the logfile to search for the completion phrase.
  tmux new -d -s tor "tor -f $TOR_CONF" && sleep 1
  tail -f $TOR_LOGS/notice.log | while read line; do
    echo "$line" && echo "$line" | grep "Bootstrapped 100%" > /dev/null 2>&1
    if [ $? = 0 ]; then 
      echo "Tor initialized!" && exit 0
    fi
  done

  ## Enable tor in param string.
  printf "$(cat $ARGS_FILE) --onion=127.0.0.1:9050" > "$ARGS_FILE"

  ## Add hostname
  printf "$(cat $DATA_PATH/tor/hidden/hostname)" > "$HOST_FILE"
fi

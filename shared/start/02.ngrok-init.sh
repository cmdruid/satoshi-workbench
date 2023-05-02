#!/usr/bin/env sh
## Ngrok init script.

set -E

###############################################################################
# Environment
###############################################################################

API_HOST="localhost:4040/api/tunnels"

[ -z "$NGROK_PROTO" ] && NGROK_PROTO="http"
[ -z "$NGROK_LHOST" ] && NGROK_LHOST="http://127.0.0.1"

###############################################################################
# Main
###############################################################################

if [ "$NGROK_ENABLED" = 1 ] && [ -n "$NGROK_PORT" ] && [ -n "$NGROK_TOKEN" ]; then

  echo "Initializing Ngrok"

  ## Add auth token to ngrok config and start Ngrok.
  ngrok config add-authtoken "$NGROK_TOKEN"
  tmux new -d -s ngrok "ngrok $NGROK_PROTO $NGROK_LHOST:$NGROK_PORT" && sleep 2
  
  ## Call API to get NGROK host, and save formatted host string.
  NGROK_HOST="$(curl -s $API_HOST | jq -r .tunnels[0].public_url | tr -d 'https://')"
  printf "$NGROK_HOST:443" > "$HOST_FILE"
fi

#!/usr/bin/env sh
## Entrypoint Script

set -E

###############################################################################
# Environment
###############################################################################

## Set environment.
CMD="bitcoind"
CONF="/config/bitcoin.conf"
ARGS_FILE="$DATA_PATH/.args"

[ -z "$NETWORK" ]  && NETWORK="regtest"
[ -z "$RPC_PORT" ] && REST_PORT="8080"
[ -n "$RPC_AUTH" ] && RPC_AUTH="-rpcauth=$RPC_AUTH"

export NETWORK
export REST_PORT
export ARGS_FILE="$DATA_PATH/.args"
export HOST_FILE="$DATA_PATH/.hostname"

[ ! -f "/root/.bitcoin" ]     && mkdir -p /root/.bitcoin
[ ! -f "$DATA_PATH/bitcoin" ] && mkdir -p $DATA_PATH/bitcoin
[ ! -f "$ARGS_FILE" ] && touch $ARGS_FILE
[ ! -f "$HOST_FILE" ] && printf "$(hostname -I | tr -d ' ')" > "$HOST_FILE"

[ -f "$CONF" ] && ln -s "$CONF" /root/.bitcoin/bitcoin.conf

###############################################################################
# Methods
###############################################################################

init() {
  ## Execute startup scripts.
  for script in `find $SHARE_PATH/start -name *.*.sh | sort`; do
    $script; state="$?"
    [ $state -ne 0 ] && exit $state
  done
}

###############################################################################
# Main
###############################################################################

## Ensure script files are executable.
for FILE in $SHARE_PATH/bin/*   ; do chmod a+x $FILE; done
for FILE in $SHARE_PATH/start/* ; do chmod a+x $FILE; done

## Initialize startup scripts.
init

## Ensure main binary exists.
[ -z "$(which $CMD)" ] && (echo "$CMD file is missing!" && exit 1)

## Construct argument string.
ARGS="--chain=$NETWORK --conf=$CONF $RPC_AUTH $(cat $ARGS_FILE) $@"

## Execute main binary.
echo "Executing $CMD with arguments:"
for arg in $ARGS; do echo $arg; done && echo

$CMD $ARGS

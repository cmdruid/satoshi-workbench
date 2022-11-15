## This file can be used to customize your environment.
## Feel free to add your own aliases and shortcuts!

## Configure bitcoin-cli.
alias bcli='bitcoin-cli --chain=$NETWORK'

## Useful for checking open sockets.
alias listen='lsof -i -P -n | grep LISTEN'

## Shortcuts to logfiles.
debug() { 
  tail -f "/root/.bitcoin/$NETWORK/debug.log" 
}

## Get QR codes for exporting complex strings.
qrcode() { 
  echo && printf $1 | qrencode -m 2 -t "UTF8" && echo
}
#!/bin/bash

set -euo pipefail

ZCASH_DIR=/root/.zcash
ZCASH_CONF=${ZCASH_DIR}/zcash.conf

# If config doesn't exist, initialize with sane defaults for running a
# non-mining node.

if [ ! -e "${ZCASH_CONF}" ]; then
  tee -a >${ZCASH_CONF} <<EOF

# For documentation on the config file, see
#
# the bitcoin source:
#   https://github.com/bitcoin/bitcoin/blob/master/contrib/debian/examples/bitcoin.conf
# the wiki:
#   https://en.bitcoin.it/wiki/Running_Bitcoin

# server=1 tells Bitcoin-Qt and bitcoind to accept JSON-RPC commands
server=1

# You must set rpcuser and rpcpassword to secure the JSON-RPC api
rpcuser=${ZEC_RPCUSER:-btc}
rpcpassword=${ZEC_RPCPASSWORD:-changemeplz}

# How many seconds bitcoin will wait for a complete RPC HTTP request.
# after the HTTP connection is established.
rpcclienttimeout=${ZEC_RPCCLIENTTIMEOUT:-30}

rpcallowip=${ZEC_RPCALLOWIP:-::/0}

# Listen for RPC connections on this TCP port:
rpcport=${ZEC_RPCPORT:-8332}

# Print to console (stdout) so that "docker logs bitcoind" prints useful
# information.
printtoconsole=${ZEC_PRINTTOCONSOLE:-1}

# We probably don't want a wallet.
disablewallet=${ZEC_DISABLEWALLET:-1}

# Enable an on-disk txn index. Allows use of getrawtransaction for txns not in
# mempool.
txindex=${ZEC_TXINDEX:-0}
testnet=${ZEC_TESTNET:-0}
dbcache=${ZEC_DBCACHE:-512}
zmqpubrawblock=${ZEC_ZMQPUBRAWBLOCK:-tcp://0.0.0.0:28333}
zmqpubrawtx=${ZEC_ZMQPUBRAWTX:-tcp://0.0.0.0:28333}
zmqpubhashtx=${ZEC_ZMQPUBHASHTX:-tcp://0.0.0.0:28333}
zmqpubhashblock=${ZEC_ZMQPUBHASHBLOCK:-tcp://0.0.0.0:28333}

EOF
fi

if [ $# -eq 0 ]; then
  exec zcashd -datadir=${ZCASH_DIR} -conf=${ZCASH_CONF}
else
  exec "$@"
fi

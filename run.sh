#!/bin/bash
docker pull fullnodes/zcash:latest
docker stop zcashd
docker rm zcashd
docker volume create zcash
docker run -dit --name zcashd --restart=always -e 'ZEC_RPCUSER=admin' -e 'ZEC_RPCPASSWORD=changeme' -e 'ZEC_TXINDEX=1' -e 'ZEC_DISABLE_WALLET=0' -v zcash:/root/.zcash fullnodes/zcash:latest

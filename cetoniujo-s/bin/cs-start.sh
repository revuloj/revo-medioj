#!/bin/bash
#set -x

echo "Lanĉi Cetoniujon en docker swarm (stack)"

#if [ "$REDAKTANTO_RETPOSHTO" != ""]; then
#    export REDAKTANTO_RETPOSHTO
#fi

mkdir -p ./ekstraj

docker stack deploy -c docker-compose.yml cetoniujo

# ĉu sufiĉas? aliokaze skribu maŝon, kiu reprovas plurfoje...
sleep 10

cetonio_id=$(docker ps --filter name=cetoniujo_cetonio -q) && echo "Cetonio: ${cetonio_id}"

# Plibonigu: kiel ni povas montri tion en "bats"?
if [ "${cetonio_id}" = "" ]; then echo "Cetonio ne aktiva!" 1>&2; exit 1; fi

docker service logs cetoniujo_cetonio 

# wait

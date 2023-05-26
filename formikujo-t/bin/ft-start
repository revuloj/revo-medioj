#!/bin/bash
#set -x

stack=formikotesto
nw=$(docker network ls --filter name=${stack}_default -q)
#formiko_id=$(docker ps --filter name=formikujo_formiko -q)
#echo "nw: $nw"
#echo "fm: $formiko_id"
#if [[ ( ! ${nw} = "" && ${formiko_id} = "" ) ]]; then
if [[ ! ${nw} = "" ]]; then
  echo "${stack}_default: $nw"
  echo "Ankoraŭ ekzistas reto '${stack}_default.'"
  echo "Post 'docker stack rm ${stack}' necesos iom atendi"
  echo "ĝis la reto foriĝas. Bv. reprovi poste."
  exit 1
fi

docker stack deploy -c docker-compose.yml ${stack}

# ĉu sufiĉas aliokaze skribu maŝon, kiu reprovas plurfoje...
sleep 10

#afido_id=$(docker ps --filter name=${stack}_afido -q) && echo "Afido: ${afido_id}"
#tomocero_id=$(docker ps --filter name=${stack}_tomocero -q) && echo "Tomocero: ${tomocero_id}"
formiko_id=$(docker ps --filter name=${stack}_formiko -q) && echo "Formiko: ${formiko_id}"

# Plibonigu: kiel ni povas montri tion en "bats"?
#if [ "${afido_id}" = "" ]; then echo "Afido ne aktiva!" 1>&2; exit 1; fi
#if [ "${tomocero_id}" = "" ]; then echo "Tomocero ne aktiva!" 1>&2; exit 1; fi
if [ "${formiko_id}" = "" ]; then echo "Formiko ne aktiva!" 1>&2; exit 1; fi

docker service logs ${stack}_formiko 

# wait

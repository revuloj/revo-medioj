#!/bin/bash
#set -x

nw=$(docker network ls --filter name=araneujo_default --filter scope=swarm -q)

if [[ ! ${nw} = "" ]]; then
  echo "araneujo_default: $nw"
  echo "Ankoraŭ ekzistas reto 'araneujo_default.'"
  echo "Post 'docker stack rm araneujo' necesos iom atendi"
  echo "ĝis la reto foriĝas. Bv. reprovi poste."
  exit 1
fi

docker stack deploy -c docker-compose.yml araneujo

# ĉu sufiĉas aliokaze skribu maŝon, kiu reprovas plurfoje...
sleep 10

#afido_id=$(docker ps --filter name=formikujo_afido -q) && echo "Afido: ${afido_id}"
#tomocero_id=$(docker ps --filter name=formikujo_tomocero -q) && echo "Tomocero: ${tomocero_id}"
#formiko_id=$(docker ps --filter name=formikujo_formiko -q) && echo "Formiko: ${formiko_id}"
#
## Plibonigu: kiel ni povas montri tion en "bats"?
#if [ "${afido_id}" = "" ]; then echo "Afido ne aktiva!" 1>&2; exit 1; fi
#if [ "${tomocero_id}" = "" ]; then echo "Tomocero ne aktiva!" 1>&2; exit 1; fi
#if [ "${formiko_id}" = "" ]; then echo "Formiko ne aktiva!" 1>&2; exit 1; fi
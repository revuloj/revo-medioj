#!/bin/bash
#set -x

if [ ! -e cvsroot ]; then
  echo "Mankas la loka dosierujo cvsroot/ !"
  exit 1
fi

if [ ! -e revo ]; then
  echo "Mankas la loka dosierujo revo/ !"
  exit 1
fi

if [ ! -e revo/cfg/agordo ]; then
  echo "AVERTO: Mankas la agordo-dosiero revo/cfg/agordo !"
  echo "Formiko kreos iun kun aprioraj valoroj."
else
  chmod 777 revo
fi

if [ ! -e revo/xml ]; then
  mkdir -p revo/xml
  chown 1074 revo/xml
fi

nw=$(docker network ls --filter name=formikujo_default -q)
#formiko_id=$(docker ps --filter name=formikujo_formiko -q)
#echo "nw: $nw"
#echo "fm: $formiko_id"
#if [[ ( ! ${nw} = "" && ${formiko_id} = "" ) ]]; then
if [[ ! ${nw} = "" ]]; then
  echo "formikujo_default: $nw"
  echo "Ankoraŭ ekzistas reto 'formikujo_default.'"
  echo "Post 'docker stack rm formikujo' necesos iom atendi"
  echo "ĝis la reto foriĝas. Bv. reprovi poste."
  exit 1
fi

docker stack deploy -c docker-compose.yml formikujo

# ĉu sufiĉas aliokaze skribu maŝon, kiu reprovas plurfoje...
sleep 10

afido_id=$(docker ps --filter name=formikujo_afido -q) && echo "Afido: ${afido_id}"
tomocero_id=$(docker ps --filter name=formikujo_tomocero -q) && echo "Tomocero: ${tomocero_id}"
formiko_id=$(docker ps --filter name=formikujo_formiko -q) && echo "Formiko: ${formiko_id}"

# Plibonigu: kiel ni povas montri tion en "bats"?
if [ "${afido_id}" = "" ]; then echo "Afido ne aktiva!" 1>&2; exit 1; fi
if [ "${tomocero_id}" = "" ]; then echo "Tomocero ne aktiva!" 1>&2; exit 1; fi
if [ "${formiko_id}" = "" ]; then echo "Formiko ne aktiva!" 1>&2; exit 1; fi
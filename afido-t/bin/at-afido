#!/bin/bash

### Ĉu Afido estas aktiva? Ni bezonas la n-ron...
afido_id=$(docker ps --filter name=afidotesto_afido -q) && echo "Afido: ${afido_id}"

exec docker exec -it -u1074 ${afido_id} $@
#docker exec -it -u1001 ${formiko_id} $@


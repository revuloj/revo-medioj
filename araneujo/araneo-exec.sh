#!/bin/bash

### Ĉu Afido estas aktiva? Ni bezonas la n-ron...
araneo_id=$(docker ps --filter name=araneujo_araneo -q) && echo "Araneo: ${araneo_id}"

exec docker exec -it -u1074 ${araneo_id} $@


#!/bin/bash

### Ĉu Afido estas aktiva? Ni bezonas la n-ron...
cetonio_id=$(docker ps --filter name=cetoniujo_cetonio -q) && echo "Cetonio: ${cetonio_id}"

exec docker exec -it -u1088 ${cetonio_id} $@


#!/bin/bash

### Ĉu Afido estas aktiva? Ni bezonas la n-ron...
formiko_id=$(docker ps --filter name=formikujo_formiko -q) && echo "Formiko: ${formiko_id}"

exec docker exec -it -u0 ${formiko_id} $@
#docker exec -it -u1001 ${formiko_id} $@


#!/bin/bash

echo
echo "ĉu formiko estas aktiva? Ni bezonas la n-ron..."
formiko_id=$(docker ps --filter name=formikujo_formiko -q) && echo ${formiko_id}

echo
echo "testo de la komunikado inter formiko -> afido per ssh..."
docker exec -u1001 -it  ${formiko_id} ssh -i /run/secrets/voko-formiko.ssh_key -o StrictHostKeyChecking=no \
    -o PasswordAuthentication=no afido@afido ls -l /usr/local/bin/processmail.pl

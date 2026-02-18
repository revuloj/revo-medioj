#!/bin/bash

stack=formikotesto
#afido_id=$(docker ps --filter name=${stack}_afido -q) && echo "Afido: ${afido_id}"
#tomocero_id=$(docker ps --filter name=${stack}_tomocero -q) && echo "Tomocero: ${tomocero_id}"
#
## necesas manipulita processmail.pl por akcepti mesaĝon de $testmail_addr
## kaj ni metas ankaŭ $debug=1
#
#local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) 
#docker exec -u0 ${afido_id} bash -c \
#    "sed \"s/\s*[\$]redaktilo_from\s*=.*/\\\$redaktilo_from='${testmail_addr}';/\" /usr/local/bin/processmail.pl \
#    > /usr/local/bin/processmail.test.pl && chmod 755 /usr/local/bin/processmail.test.pl"
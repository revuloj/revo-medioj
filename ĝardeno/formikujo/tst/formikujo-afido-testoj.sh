#!/bin/bash

echo
echo "### Ĉu afido estas aktiva? Ni bezonas la n-ron..."
afido_id=$(docker ps --filter name=formikujo_afido -q) && echo ${afido_id}
echo
echo "### Ĉu tomocero estas aktiva? Ni bezonas la n-ron kaj la poŝtfakon..."
tomocero_id=$(docker ps --filter name=formikujo_tomocero -q) && echo ${tomocero_id}
testmail_addr=$(docker  exec -it -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) && echo ${testmail_addr}

echo
echo "### Testoj de ssmtp..."
docker exec -u1074 -it ${afido_id} cat /etc/ssmtp/ssmtp.conf
docker exec -u1074 -it ${afido_id} bash -c "echo -e \"Subject: Saluto de afido\n\nTesto de retpoŝtsendo per ssmtp.\n\" | ssmtp -v ${testmail_addr}"
# docker exec -u1074 -it ${afido_id} bash -c "echo \"testo-retpoŝto\" | mail -s \"testo 1\" revo-servo@steloj.de"

echo
echo "### Ni atendos iomete..."
sleep 30
echo
echo "### Ĉu la retpoŝto al ${testmail_addr} jam revenis?..."
docker exec -it -u1074 ${tomocero_id} fetchmail
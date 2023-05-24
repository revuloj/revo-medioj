#!/bin/bash

echo
echo "### Ĉu formiko estas aktiva? Ni bezonas la n-ron..."
formiko_id=$(docker ps --filter name=formikujo_formiko -q) && echo ${formiko_id}

echo
echo "### Testo de la komunikado inter formiko -> afido per ssh..."
docker exec -u1001 -it  ${formiko_id} ssh -i /run/secrets/voko-formiko.ssh_key -o StrictHostKeyChecking=no \
    -o PasswordAuthentication=no afido@afido ls -l /usr/local/bin/processmail.pl

echo
echo "### Testo de ant redaktoservo..."
docker exec -u1001 -it ${formiko_id} bash -c "ant -f \${VOKO}/ant/redaktoservo.xml -p"
docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-agordo"
docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-shlosu"
docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-malshlosu"


echo
echo "### Testo de skripto formiko..."
docker exec -u1001 -it ${formiko_id} formiko art-helpo
docker exec -u1001 -it ${formiko_id} formiko inx-helpo

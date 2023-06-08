#!/bin/bash
stack=formikotesto

### Ĉu Afido ktp. estas aktivaj? Ni bezonas iliajn n-rojn...
#afido_id=$(docker ps --filter name=${stack}_afido -q) && echo "Afido: ${afido_id}"
#tomocero_id=$(docker ps --filter name=${stack}_tomocero -q) && echo "Tomocero: ${tomocero_id}"
formiko_id=$(docker ps --filter name=${stack}_formiko -q) && echo "Formiko: ${formiko_id}"

# Plibonigu: kiel ni povas montri tion en "bats"?
#if [ "${afido_id}" = "" ]; then echo "Afido ne aktiva!" 1>&2; exit 1; fi
#if [ "${tomocero_id}" = "" ]; then echo "Tomocero ne aktiva!" 1>&2; exit 1; fi
if [ "${formiko_id}" = "" ]; then 
    echo "Formiko ne aktiva!" 1>&2
    exit 1
else
    docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/tmp/inx_tmp/*"
    docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/art"
    docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/hst"
    docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/inx"
    docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/xml"
    docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/tez"
    docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/tgz/*"
    docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo-fonto"
    docker cp tst/create_test_repo.sh ${formiko_id}:/usr/local/bin/
    docker exec -it ${formiko_id} bash -c "create_test_repo.sh"
    docker exec -u1001 -it ${formiko_id} bash -c "git clone ./test-repo revo-fonto"
fi



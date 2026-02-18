#!/bin/bash

stack=afidotesto

### Ĉu Afido ktp. estas aktivaj? Ni bezonas ĝian n-ron...
abelo_id=$(docker ps --filter name=${stack}_abelo -q) && echo "abelo: ${abelo_id}"

# Plibonigu: kiel ni povas montri tion en "bats"?
if [ "${abelo_id}" = "" ]; then echo "abelo ne aktiva!" 1>&2; exit 1; fi

docker cp $(pwd)/bin/create_test_submetoj_araneo.sh ${abelo_id}:/
docker exec -it ${abelo_id} bash -c "TEST_RETADRESO=${TEST_RETADRESO} /create_test_submetoj_araneo.sh"





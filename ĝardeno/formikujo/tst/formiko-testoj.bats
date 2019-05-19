#!/usr/bin/env bats

#set -x
# https://github.com/sstephenson/bats/issues/136
# https://github.com/sstephenson/bats/issues/10

@test "Agordo de redaktoservo" {
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-agordo"

  # srv.poshtoservilo=tomocero
  poshtilo=$(echo "${output}" | grep srv.poshtoservilo)
  #echo "$poshtilo"
  #echo "[${poshtilo##*=}]"
  [ ! "$output" = "" ]
  [[ "${poshtilo##*=}" == "tomocero"* ]]
  [ "$status" -eq 0 ]
}

@test "Ŝloso kaj malŝloso de la servo" {
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-shlosu srv-malshlosu"
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}


## echo
## echo "### Testo de la komunikado inter formiko -> afido per ssh..."
## docker exec -u1001 -it  ${formiko_id} ssh -i /run/secrets/voko-formiko.ssh_key -o StrictHostKeyChecking=no \
##     -o PasswordAuthentication=no afido@afido ls -l /usr/local/bin/processmail.pl
## 
## echo
## echo "### Testo de ant redaktoservo..."
## docker exec -u1001 -it ${formiko_id} bash -c "ant -f \${VOKO}/ant/redaktoservo.xml -p"
## docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-agordo"
## docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-shlosu"
## docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-malshlosu"
## 
## 
## echo
## echo "### Testo de skripto formiko..."
## docker exec -u1001 -it ${formiko_id} formiko art-helpo
## docker exec -u1001 -it ${formiko_id} formiko inx-helpo

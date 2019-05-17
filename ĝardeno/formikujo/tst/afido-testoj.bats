#!/usr/bin/env bats

#set -x
# https://github.com/sstephenson/bats/issues/136
# https://github.com/sstephenson/bats/issues/10

@test "Ĉu Afido enhavas /etc/ssmtp/ssmtp.conf?" {
  load test-preparo
  run docker exec ${afido_id} cat /etc/ssmtp/ssmtp.conf
  [ ! "$output" = "" ]
  [[ "$output" == "#"* ]]
  [ "$status" -eq 0 ]
}

@test "Ĉu ssmtp.conf enhavas 'hostname=afido'?" {
  load test-preparo
  result=$(docker exec ${afido_id} cat /etc/ssmtp/ssmtp.conf | grep "^hostname=")
  [[ "$result" = "hostname=afido" ]]
}

@test "Forsendo de retpoŝto" {
  #skip
  load test-preparo
  local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) 
  run docker exec -u1074 ${afido_id} bash -c "echo -e \"Subject: Saluto de afido\n\nTesto de retpoŝtsendo per ssmtp.\n\" | ssmtp -v ${testmail_addr}"
  [ "$status" -eq 0 ]
}

@test "Iom da atendo kaj poste provu legi la antaŭe senditan poŝtaĵon" {
  #skip
  load test-preparo
  sleep 20
  run docker exec -u1074 ${tomocero_id} fetchmail
  echo "out: $output"
  echo "lin: "${lines[1]}
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" == "reading message"* ]]
}

# echo -e "### Ĉu la retpoŝto al\n '${testmail_addr}' jam revenis?..."
# docker exec -it -u1074 ${tomocero_id} fetchmail
# 
# echo
# echo "### Ni traktu envenintajn retpoŝtojn..."
# docker exec -it -u1074 ${afido_id} processmail.pl

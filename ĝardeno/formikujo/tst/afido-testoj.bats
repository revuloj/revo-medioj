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

@test "Trakto de retpoŝto per processmail.pl kreu eraro-dosieron en ~/log/mailerr/" {
  #skip
  load test-preparo
  run docker exec -u1074 ${afido_id} processmail.pl
  local -r time_prefix=$(date --utc +"%Y%m%d_%H%M")
  local -r last_file=$(docker exec -u1074 ${afido_id} ls -l /var/afido/log/errmail/ | tail -1)
  echo "${last_file}"
  echo "${time_prefix}.."
  # la lasta dosiernomo en mailerr devus nomiĝi laŭ nuna minuto:
  [[ "${last_file##* }" == "${time_prefix}"* ]]
}


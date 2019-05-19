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

@test "Ĉu /var/mail/tomocero estas malplena, t.e. neniu malnova poŝto enestas?" {
  load test-preparo
  run docker exec ${afido_id} [ ! -s /var/mail/tomocero ]
  [ "${status}" -eq 0 ] || echo "Enestas malnova retpoŝto en /var/mail/tomocero, postaj testoj kun 'processmail' verŝajne fiaskos."
}

@test "Forsendo de ia retpoŝto per sendmail" {
  #skip
  load test-preparo
  local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) 
  run docker exec -u1074 ${afido_id} bash -c "echo -e \"Subject: Saluto de afido\n\nTesto de retpoŝtsendo per ssmtp.\n\" | /usr/lib/sendmail -i -v ${testmail_addr}"
  echo "out: $output"
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

@test "Trakto de retpoŝto per processmail.pl, poste estu eraro-dosiero en ~/log/errmail/" {
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

@test "Variablo CVSROOT ekzistu kaj dosierujoj cvsroot/revo kaj dict/xml estu nemalplenaj" {
  afido_id=$(docker ps --filter name=formikujo_afido -q) && echo "Afido: ${afido_id}"
  cvs=$(docker exec -u1074 ${afido_id} bash -c "ls \${CVSROOT}/revo" | wc -w)
  xml=$(docker exec -u1074 ${afido_id} bash -c "ls /home/afido/dict/xml" | wc -w)
  echo "${cvs}"
  echo "${xml}"
  [ "${cvs}" -gt 1 ]
  [ "${xml}" -gt 1 ]
}

@test "Forsendo de retpoŝto kun ŝanĝetita XML de test.xml" {
  #skip
  load test-preparo  
  local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) 
  local -r testfrom=$(docker  exec -u1074 ${afido_id} head -1 /run/secrets/voko.redaktantoj) 
  local -r testfrom_addr=${testfrom##* }
  run docker exec -u1074 ${afido_id} bash -c \
    "( echo -e \"Reply-To: ${testfrom_addr}\n\nredakto: testo per aldono de spaco post <vortaro\n\n\" && sed \"s/<vortaro/<vortaro /\" dict/xml/test.xml ) | /usr/lib/sendmail -i -v ${testmail_addr}"
  [ "$status" -eq 0 ]
}

@test "Iom da atendo kaj poste provu legi la antaŭe senditan poŝtaĵon kun test.xml" {
  #skip
  load test-preparo
  sleep 20
  run docker exec -u1074 ${tomocero_id} fetchmail
  echo "out: $output"
  echo "lin: "${lines[1]}
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" == "reading message"* ]]
}

@test "Trakto de retpoŝto kun test.xml per processmail.pl, poste estu eraro-dosiero en /var/afido/log/prcmail/" {
  #skip
  load test-preparo

  # necesas manipulita processmail.pl por akcepti mesaĝon de $testmail_addr
  # kaj ni metas ankaŭ $debug=1
  local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) 
  docker exec -u0 ${afido_id} bash -c \
    "sed \"s/\s*[\$]redaktilo_from\s*=.*/\\\$redaktilo_from='${testmail_addr}';/\" /usr/local/bin/processmail.pl \
    > /usr/local/bin/processmail.test.pl && chmod 755 /usr/local/bin/processmail.test.pl"
  docker exec -u0 ${afido_id} bash -c \
    "sed -i \"s/\s*[\$]debug\s*=.*/\\\$debug=1;/\" /usr/local/bin/processmail.test.pl"

  run docker exec -u1074 ${afido_id} processmail.test.pl
  echo "${output}"

  local -r time_prefix=$(date --utc +"%Y%m%d_%H%M")
  local -r last_file=$(docker exec -u1074 ${afido_id} ls -l /var/afido/log/prcmail/ | tail -1)
  echo "${last_file}"
  echo "${time_prefix}.."

  # la lasta dosiernomo en mailerr devus nomiĝi laŭ nuna minuto:
  [[ "${last_file##* }" == "${time_prefix}"* ]]
}


#!/usr/bin/env bats

#set -x
# https://github.com/sstephenson/bats/issues/136
# https://github.com/sstephenson/bats/issues/10

@test "Sintakso de formiko-skriptoj" {
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} bash -c "formiko-testo"

  # srv.poshtoservilo=tomocero
  echo "${output}"
  build_failed=$(echo "${output}" | grep "BUILD FAILED" || [[ $? == 1 ]] )
  [ -z "$build_failed" ]
  [ "$status" -eq 0 ]
}

@test "Agordo de redaktoservo" {  
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo-docker.xml srv-agordo"

  # srv.poshtoservilo=tomocero
  echo "${output}"
  poshtilo=$(echo "${output}" | grep srv.poshtoservilo)
  #echo "$poshtilo"
  #echo "[${poshtilo##*=}]"
  [ ! "$output" = "" ]
  [[ "${poshtilo##*=}" == "tomocero"* ]]
  [ "$status" -eq 0 ]
}

## echo
## echo "### Testo de skripto formiko..."
## docker exec -u1001 -it ${formiko_id} formiko art-helpo
## docker exec -u1001 -it ${formiko_id} formiko inx-helpo

@test "Testo de la komunikado inter formiko -> afido per ssh..." {
  #skip
  load test-preparo
#  run docker exec -u1001 -it  ${formiko_id} ssh -i /run/secrets/voko-formiko.ssh_key -o StrictHostKeyChecking=no \
#     -o PasswordAuthentication=no afido@afido ls /usr/local/bin/processmail.pl
  run docker exec -u1001 -it  ${formiko_id} ssh -i /run/secrets/voko-formiko.ssh_key \
     -o ConnectTimeout=10 -o PasswordAuthentication=no afido@afido ls /usr/local/bin/processmail.pl
  echo "${output}"
  [[ "${output}" == "/usr/local/bin/processmail.pl"* ]]
}

@test "Forsendo de retpoŝto kun ŝanĝetita XML de test.xml" {
  #skip
  load test-preparo  
  local -r testmail_addr=$(docker exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) 
  local -r testfrom=$(docker exec -u1074 ${formiko_id} head -1 /run/secrets/voko.redaktantoj) 
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


@test "Trakto de retpoŝto kun test.xml per processmail.pl" {
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

  run docker exec -u1001 -it ${formiko_id} bash -c \
    "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml -Dprocessmail=processmail.test.pl srv-trakti-poshton"

  # forigu processmail.test.pl
  docker exec -u0 ${afido_id} rm /usr/local/bin/processmail.test.pl

  echo "${output}"
  artikolo=$(echo "${output}" | grep '\[exec\] artikolo: $Id: test.xml')
  success=$(echo "${output}" | grep BUILD)
  [[ "${artikolo}" == *"test.xml"* ]]
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Refaro de artikoloj (test.xml). Povas daŭri longe unuafoje pro kompleta refaro de artikoloj en revo/art/." {
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} formiko -Duser-mail-file-exists=yes srv-refari-nur-artikolojn
  echo "${output}"
  artikolo=$(echo "${output}" | grep '\[xslt\] Processing /home/formiko/revo/xml/test.xml')
  success=$(echo "${output}" | grep BUILD)
  [[ "${artikolo}" == *"test.xml"* ]]
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}


## testu tion: sendu kaj ricevu retpoŝton kun ŝanĝita XML-dosiero tra tomocero (vokita per ssh)
## kaj voko redaktoservo-skripton en reĝimo -a (nur artikoloj), tio
## versiigu la ŝanĝon per afido (vokita tra ssh ... processmail.pl)
## refaru la koncernan artikolon


## testu nun simile refaron de la tuta vortaro
## ne necesas resendi retpoŝton, sed poste kontroli la ŝanĝon en la indekso...

## ĉu necesas malfari la ŝangon...? - nur se ni intencas uzi testadon ankaŭ en la vera medio, kion
## ni evitu eble lasante tiun teston en la ĝardeno.

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

@test "Sintakso de XSL-dosieroj" {
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} bash -c "\${VOKO}/bin/xsl-testo"

  # srv.poshtoservilo=tomocero
  echo "${output}"
  xsl_failed=$(echo "${output}" | grep "Failed" || [[ $? == 1 ]] )
  [ -z "$xsl_failed" ]
  [ "$status" -eq 0 ]
}

@test "Agordo de redaktoservo" {  
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-agordo"

  # srv.poshtoservilo=tomocero
  echo "${output}"
  poshtilo=$(echo "${output}" | grep srv.poshtoservilo)
  #echo "$poshtilo"
  #echo "[${poshtilo##*=}]"
  [ ! "$output" = "" ]
  [[ "${poshtilo##*=}" == "tomocero"* ]]
  [ "$status" -eq 0 ]
}

@test "Ŝloso kaj malŝloso de la servo per ant -f" {
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} bash -c "cd \${REVO}; ant -f \${VOKO}/ant/redaktoservo.xml srv-shlosu srv-malshlosu"
  # ĉu ni aldone kontrolu, ĉu la dosiero /home/formiko/tmp/inx_tmp/redaktoservo-laboranta-do-shlosita ekzistas kaj poste foriĝas...?
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Ŝloso de la servo per la skripto formiko" {
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} formiko srv-shlosu
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}


@test "Malŝloso de la servo per la skripto formiko" {
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} formiko srv-malshlosu
  # ĉu ni aldone kontrolu, ĉu la dosiero /home/formiko/tmp/inx_tmp/redaktoservo-laboranta-do-shlosita ekzistas kaj poste foriĝas...?
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

## echo
## echo "### Testo de skripto formiko..."
## docker exec -u1001 -it ${formiko_id} formiko art-helpo
## docker exec -u1001 -it ${formiko_id} formiko inx-helpo

@test "Testo de la komunikado inter formiko -> afido per ssh..." {
  skip
  load test-preparo
#  run docker exec -u1001 -it  ${formiko_id} ssh -i /run/secrets/voko-formiko.ssh_key -o StrictHostKeyChecking=no \
#     -o PasswordAuthentication=no afido@afido ls /usr/local/bin/processmail.pl
  run docker exec -u1001 -it  ${formiko_id} ssh -i /run/secrets/voko-formiko.ssh_key \
     -o ConnectTimeout=10 -o PasswordAuthentication=no afido@afido ls /usr/local/bin/processmail.pl
  echo "${output}"
  [[ "${output}" == "/usr/local/bin/processmail.pl"* ]]
}

@test "Forsendo de retpoŝto kun ŝanĝetita XML de test.xml" {
  skip
  load test-preparo  
  local -r testmail_addr=$(docker exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) 
  local -r testfrom=$(docker exec -u1074 ${formiko_id} head -1 /run/secrets/voko.redaktantoj) 
  local -r testfrom_addr=${testfrom##* }
  run docker exec -u1074 ${afido_id} bash -c \
    "( echo -e \"Reply-To: ${testfrom_addr}\n\nredakto: testo per aldono de spaco post <vortaro\n\n\" && sed \"s/<vortaro/<vortaro /\" dict/xml/test.xml ) | /usr/lib/sendmail -i -v ${testmail_addr}"
  [ "$status" -eq 0 ]
}

@test "Iom da atendo kaj poste provu legi la antaŭe senditan poŝtaĵon kun test.xml" {
  skip
  load test-preparo
  sleep 20
  run docker exec -u1074 ${tomocero_id} fetchmail
  echo "out: $output"
  echo "lin: "${lines[1]}
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" == "reading message"* ]]
}


@test "Trakto de retpoŝto kun test.xml per processmail.pl" {
  skip
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
  skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} formiko -Duser-mail-file-exists=yes srv-refari-nur-artikolojn
  echo "${output}"
  artikolo=$(echo "${output}" | grep '\[xslt\] Processing /home/formiko/revo/xml/test.xml')
  success=$(echo "${output}" | grep BUILD)
  [[ "${artikolo}" == *"test.xml"* ]]
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Refaro de artikoloj laŭ listo en dosiero." {
  skip
  load test-preparo
  local -r test_lst=$(pwd)/test.lst
  printf "test.xml\nabel.xml\ncxeval.xml\n" > ${test_lst}
  echo "${output}"
  docker cp ${test_lst} ${formiko_id}:/test.lst 
  run docker exec -u1001 -it ${formiko_id} formiko -Dart-listo=/test.lst art-listo
  echo "${output}"
  rm test.lst
  artikolo=$(echo "${output}" | grep '\[xslt\] Processing')
  success=$(echo "${output}" | grep BUILD)
  [[ "${artikolo}" == *"test.xml"* ]]
  [[ "${artikolo}" == *"abel.xml"* ]]
  [[ "${artikolo}" == *"cxeval.xml"* ]]
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Refaro de artikoloj laŭ listo en dosiero kun enpakado." {
  skip
  load test-preparo
  local -r test_lst=$(pwd)/test.lst
  printf "test.xml\nabel.xml\ncxeval.xml\n" > ${test_lst}
  echo "${output}"
  docker cp ${test_lst} ${formiko_id}:/test.lst 
  run docker exec -u1001 -it ${formiko_id} formiko -Dart-listo=/test.lst srv-art-listo
  echo "${output}"
  rm test.lst
  artikolo=$(echo "${output}" | grep '\[xslt\] Processing')
  success=$(echo "${output}" | grep BUILD)
  [[ "${artikolo}" == *"test.xml"* ]]
  [[ "${artikolo}" == *"abel.xml"* ]]
  [[ "${artikolo}" == *"cxeval.xml"* ]]
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Faro de Sqlite-datumbazo. (daŭras longe...)" {
  skip
  load test-preparo
  docker exec -u1001 -it ${formiko_id} bash -c "rm -f tmp/inx_tmp/sql/*"
  docker exec -u1001 -it ${formiko_id} bash -c "rm -f tmp/inx_tmp/indekso.xml"
  run docker exec -u1001 -it ${formiko_id} formiko inx-eltiro
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  run docker exec -u1001 -it ${formiko_id} formiko sql-tuto
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  # kontrolu, ĉu tmp/inx_tmp/sql/revo-inx.db ekzistas nun...
  run docker exec -u1001 -it ${formiko_id} ls -l tmp/inx_tmp/sql
  echo "${output}"
  [[ "${output}" == *"revo-inx.db"* ]]
  # kontrolu, ĉu tgz/revosql{-inx}_20*.zip ekzistas nun...
  run docker exec -u1001 -it ${formiko_id} ls -l tgz
  echo "${output}"
  [[ "${output}" == *"revosql-inx_20"*".zip"* ]]
  [[ "${output}" == *"revosql_20"*".zip"* ]]
  [ "$status" -eq 0 ]
}

@test "Preparu medion de la vortaro." {
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} formiko med-kadro
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Kontrolu XML per Jing (RelaxNG), (daŭras iom ...)" {
  skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} formiko inx-relax
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Konvertu artikolojn de XML al HTML. (daŭras ...)" {
  skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} formiko inx-eltiro
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  run docker exec -u1001 -it ${formiko_id} formiko art-tuto
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Kreu indeksojn de la vortaro. (daŭras ...)" {
  skip
  load test-preparo
  docker exec -u1001 -it ${formiko_id} bash -c "rm -f tmp/inx_tmp/*.xml"
  run docker exec -u1001 -it ${formiko_id} formiko inx-tuto
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Kreu tezaŭron de la vortaro. (daŭras ...)" {
  skip
  load test-preparo
  docker exec -u1001 -it ${formiko_id} bash -c "rm -f tmp/inx_tmp/*.xml"
  run docker exec -u1001 -it ${formiko_id} formiko tez-tuto
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Kreu la vortaron (kiel en Github, povas iom daŭri)." {
  skip
  load test-preparo
  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/tmp/inx_tmp"
  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/art/*"
  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/xml/*"
  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/hst/*"
  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/inx/*"
  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/tez/*"
  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/tgz/*"
  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo-fonto"
  docker exec -it ${formiko_id} bash -c "create_test_repo.sh"
  docker exec -u1001 -it ${formiko_id} bash -c "git clone ./test-repo revo-fonto"
   
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha=v1 srv-servo-github-medinxtez
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha=v1 srv-servo-github-art
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha=v1 srv-servo-github-hst
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]

  # kontrolu, ĉu 
  # - tgz/revohtml_20*.zip 
  # - tgz/revoart_20*.zip 
  # - tgz/revohst_20*.zip 
  # ekzistas nun...
  today=$(date +'%Y-%m-%d')
  run docker exec -u1001 -it ${formiko_id} ls -l tgz
  echo "${output}"
  [[ "${output}" == *"revohtml_${today}.zip"* ]]
  [[ "${output}" == *"revoart_${today}.zip"* ]]
  [[ "${output}" == *"revohst_${today}.zip"* ]]

  # kontrolu, ĉu artefakt.html estas en art kaj hst
  run docker exec -u1001 -it ${formiko_id} unzip -l tgz/revoart_${today}.zip
  echo "${output}"
  [[ "${output}" == *"revo/art/artefakt.html"* ]]
  run docker exec -u1001 -it ${formiko_id} unzip -l tgz/revohst_${today}.zip
  echo "${output}"
  [[ "${output}" == *"revo/hst/artefakt.html"* ]]

  [ "$status" -eq 0 ]
}

@test "Ne kreu la vortaran diferencon, se du eldonoj samas." {
  skip
  load test-preparo
  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo.ref"
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha1=v1 -Dsha2=v1 srv-servo-github-diurne
  echo "${output}"
  result=$(echo "${output}" | grep BUILD)
  samas=$(echo "${output}" | grep "eldonoj samas")
  [[ "${samas}" == *"samas"* ]]
  [[ "${result##* }" == "FAILED"* ]]
  [ "$status" -eq 1 ]
}

@test "Kreu la vortaron en du eldonoj kaj arĥivu la diferencon (kiel en Github, povas iom daŭri)." {
  #skip
  load test-preparo-repo

#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/tmp/inx_tmp"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/art/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/xml/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/hst/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/inx/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/tez/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/tgz/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo-fonto"
#  docker exec -it ${formiko_id} bash -c "create_test_repo.sh"
#  docker exec -u1001 -it ${formiko_id} bash -c "git clone ./test-repo revo-fonto"

  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo.ref"
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha1=v1 -Dsha2=master srv-servo-github-diurne
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Aktualigu artikolojn kaj historion (kiel hore en Github)." {
  skip
  load test-preparo-repo
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/tmp/inx_tmp"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/art/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/xml/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/hst/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/inx/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo/tez/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/tgz/*"
#  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo-fonto"
#  docker exec -it ${formiko_id} bash -c "create_test_repo.sh"
#  docker exec -u1001 -it ${formiko_id} bash -c "git clone ./test-repo revo-fonto"
   
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha1=v1 -Dsha2=v4 srv-servo-github-hore
  echo "${output}"
  local -r success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]

# aldonita en v2: revo/modif.xml 
# forigita en v4: revo/artefakt.xml 

  tgz=$(docker exec -u1001 -it ${formiko_id} ls tgz/ | tr '\r' ' ')
  tgz=${tgz//[$'\t\r\n ']}
  content=$(docker exec -u1001 -it ${formiko_id} tar -tvzf tgz/${tgz})
  echo "${content}"

  [[ "${content}" == *"revo/art/modif.html"* ]]
  [[ "${content}" == *"revo/hst/modif.html"* ]]
  [[ "${content}" == *"bv_forigu_tiujn.lst"* ]]

  forig=$(docker exec -u1001 -it ${formiko_id} cat tmp/inx_tmp/bv_forigu_tiujn.lst)
  echo "${forig}"
  [[ "${forig}" == *"revo/art/artefakt.html"* ]]
  [[ "${forig}" == *"revo/hst/artefakt.html"* ]]
  [[ "${forig}" == *"revo/xml/artefakt.xml"* ]]

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

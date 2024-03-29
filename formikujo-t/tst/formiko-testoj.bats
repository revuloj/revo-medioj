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

@test "Faro de Sqlite-datumbazo. (daŭras longe...)" {
  #skip
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

@test "Preparu klas-liston en medio de la vortaro." {
  #skip
  load test-preparo
  run docker exec -u1001 -it ${formiko_id} formiko med-kls
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Kontrolu XML per Jing (RelaxNG), (daŭras iom ...)" {
  #skip
  load test-preparo-repo
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha=v2 art-git-co
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  run docker exec -u1001 -it ${formiko_id} formiko inx-relax
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Konvertu artikolojn de XML al HTML. (daŭras ...)" {
  #skip
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
  #skip
  load test-preparo
  docker exec -u1001 -it ${formiko_id} bash -c "rm -f tmp/inx_tmp/*.xml"
  run docker exec -u1001 -it ${formiko_id} formiko inx-tuto
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Kreu tezaŭron de la vortaro. (daŭras ...)" {
  #skip
  load test-preparo
  docker exec -u1001 -it ${formiko_id} bash -c "rm -f tmp/inx_tmp/*.xml"
  run docker exec -u1001 -it ${formiko_id} formiko tez-tuto
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Kreu la vortaron (kiel en Github, povas iom daŭri)." {
  #skip
  load test-preparo-repo
   
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha=v1 srv-servo-github-medinxtez
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha=v1 srv-servo-github-art
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha=v1 srv-servo-github-hst
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  #[ "$status" -eq 0 ]

  # kontrolu, ĉu 
  # - tgz/revohtml_20*.zip 
  # - tgz/revoart_20*.zip 
  # - tgz/revohst_20*.zip 
  # ekzistas nun...
  today=$(date +'%Y-%m-%d')
  run docker exec -u1001 -it ${formiko_id} ls -l tgz
  echo "${output}"
  ##?? [[ "${output}" == *"revohtml_${today}.zip"* ]]
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
  #skip
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

  docker exec -it ${formiko_id} bash -c "rm -rf /home/formiko/revo.ref"
  run docker exec -u1001 -it ${formiko_id} formiko -Dsha1=v1 -Dsha2=master srv-servo-github-diurne
  echo "${output}"
  success=$(echo "${output}" | grep BUILD)
  [[ "${success##* }" == "SUCCESSFUL"* ]]
  [ "$status" -eq 0 ]
}

@test "Aktualigu artikolojn kaj historion (kiel hore en Github)." {
  skip
  # tiu testo eble ne plu estas konforma al la efektiva procedo. (ftp-alŝuto...)
  load test-preparo-repo
   
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



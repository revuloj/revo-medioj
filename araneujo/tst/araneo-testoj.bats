#!/usr/bin/env bats

@test "Kontroli, ĉu la artikolo 'abel' estas servata" {
  load test-preparo
  url="http://${araneo_host}:${pnum}/revo/art/abel.html"
  html=$(curl -Ls ${url})
  # tio eliĝas nur se okazas problemoj...

  [[ ${html} == *"<title>abel/o"* ]]
}

@test "Kontroli, ĉu la artikolo 'abel' estas trovebla per la serĉo" {
  load test-preparo
  url="http://${araneo_host}:${pnum}/cgi-bin/sercxu.pl?sercxata=abelo"
  html=$(curl -Ls ${url})
  # tio eliĝas nur se okazas problemoj...

  body=$(echo ${html} | grep -oz '<body.*body>' | tr '\000' '\n')
  echo "$body"
  [[ ${body} == *"<b>abelo</b>"* ]]
}

@test "Kontroli, ĉu la artikolo 'test' estas redaktebla per vokomail.pl" {
  skip
  load test-preparo
  url="http://${araneo_host}:${pnum}/cgi-bin/vokomail.pl?art=test"
  html=$(curl -Ls ${url})
  # tio eliĝas nur se okazas problemoj...

  body=$(echo ${html} | grep -oz '<body.*body>' | tr '\000' '\n')
  echo "$html"
  [[ ${body} == *"<rad>test</rad>/o"* ]]
}

@test "Provi sendi redakton por la artikolo 'test' al vokomail.pl" {
  skip
  load test-preparo

  # kiel redaktanto ni uzas la unuan en la listo
  local -r testfrom=$(docker exec -u1074 ${abelo_id} head -1 /run/secrets/voko.redaktantoj) 
  local -r testfrom_1=${testfrom##* }
  testfrom_2=${testfrom_1%">"*}

  testfrom_addr=${testfrom_2#"<"*}
  # tio necesas por "debug" en vokomail.pl
  #testfrom_addr='Wieland@wielandpusch.de'

  # echo "$testfrom_addr"
  # local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress)

  url="http://${araneo_host}:${pnum}/cgi-bin/vokomail.pl?art=test"
  tst_dir=$(dirname $BATS_TEST_FILENAME)
  html=$(curl -Ls -X POST -F "button=konservu" -F "art=test" -F "sxangxo=testo per araneo-testoj.bats" \
    -F "redaktanto=${testfrom_addr}" -F "xmlTxt=<${tst_dir}/revo/xml/test.xml" ${url})
  body=$(echo ${html} | grep -oz '<body.*body>' | tr '\000' '\n')

  # tio eliĝas nur se ne okazas problemoj...
  echo "$body"
  [[ ${body} == *"XML en ordo"* ]]
  [[ ${body} == *"oteksto en ordo:"* ]]
  [[ ! ${body} == *"ne konservita"* ]]
# Ankoraŭ ne funkcias forsendo:
#  [[ ${body} == *"sendita al"* ]]
#  [[ ! ${body} == *"refused"* ]]
# Konservo</b></span></p>
# sendmail: can't connect to remote host (127.0.0.1): Connection refused
# sendita al xxxx@mondo.eo, revo@retavortaro.de

}

@test "La antaŭrigardo de nova vokomailx.pl..." {
  #skip
  load test-preparo

  # kiel redaktanto ni uzas la unuan en la listo
  local -r testfrom=$(docker exec -u1074 ${abelo_id} head -1 /run/secrets/voko.redaktantoj) 
  local -r testfrom_1=${testfrom##* }
  testfrom_2=${testfrom_1%">"*}

  testfrom_addr=${testfrom_2#"<"*}
  # tio necesas por "debug" en vokomail.pl
  #testfrom_addr='Wieland@wielandpusch.de'

  # echo "$testfrom_addr"
  # local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress)

  url="http://${araneo_host}:${pnum}/cgi-bin/vokomailx.pl?art=test"
  echo "$url"
  tst_dir=$(dirname $BATS_TEST_FILENAME)

  ## curl status codes: https://curl.haxx.se/libcurl/c/libcurl-errors.html
  html=$(curl -Ls --ignore-content-length -X POST -F "button=konservu" -F "art=test" -F "sxangxo=testo per araneo-testoj.bats" ${url})
  # \
  #  -F "redaktanto=${testfrom_addr}" -F "xmlTxt=<${tst_dir}/revo/xml/test.xml" ${url})
  body=$(echo ${html} | grep -oz '<body.*body>' | tr '\000' '\n')

  # tio eliĝas nur se ne okazas problemoj...
  echo "$html"
  [[ ${body} == *"XML en ordo"* ]]
  [[ ${body} == *"oteksto en ordo:"* ]]
  [[ ! ${body} == *"ne konservita"* ]]  
}


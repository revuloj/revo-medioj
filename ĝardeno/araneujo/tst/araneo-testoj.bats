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

  echo "$html"
  [[ ${html} == *"<b>abelo</b>"* ]]
}

@test "Kontroli, ĉu la artikolo 'test' estas redaktebla per vokomail.pl" {
  load test-preparo
  url="http://${araneo_host}:${pnum}/cgi-bin/vokomail.pl?art=test"
  html=$(curl -Ls ${url})
  # tio eliĝas nur se okazas problemoj...

  echo "$html"
  [[ ${html} == *"<rad>test</rad>/o"* ]]
}

@test "Provi sendi redakton por la artikolo 'test' al vokomail.pl" {
  load test-preparo

  local -r testfrom=$(docker exec -u1074 ${abelo_id} head -1 /run/secrets/voko.redaktantoj) 
  local -r testfrom_1=${testfrom##* }
  testfrom_2=${testfrom_1%">"*}
  testfrom_addr=${testfrom_2#"<"*}
  # echo "$testfrom_addr"
  # local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress)

  url="http://${araneo_host}:${pnum}/cgi-bin/vokomail.pl?art=test"
  tst_dir=$(dirname $BATS_TEST_FILENAME)
  html=$(curl -Ls -X POST -F "button=konservu" -F "sxangxo=testo per araneo-testoj.bats" \
    -F "redaktanto=${testfrom_addr}" -F xmlText=@${tst_dir}/revo/xml/test.xml ${url})
  body=$(echo ${html} | grep -oz '<body.*body>' | tr '\000' '\n')

  # tio eliĝas nur se okazas problemoj...
  echo "$body"
  [[ ${body} == *"XML en ordo"* ]]
  [[ ${body} == *"oteksto en ordo:"* ]]
  [[ ${body} == *"sendita al"* ]]
  [[ ! ${body} == *"refused"* ]]

# <p><span style="color: rgb(207, 118, 6); font-size: 140%;"><b>Anta&#365;rigardo</b></span></p>

# Konservo</b></span></p>
# sendmail: can't connect to remote host (127.0.0.1): Connection refused
# sendita al diestel@steloj.de, revo@retavortaro.de</div><br>

}


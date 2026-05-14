#shebang ne plu funkcias, voku kiel: bats -t testoj.bats
#!/usr/bin/env bats

#set -x
# https://github.com/sstephenson/bats/issues/136
# https://github.com/sstephenson/bats/issues/10

if [[ -z "$TEST_RETADRESO" ]]; then
  echo "Vi devas antaŭdifini variablon TEST_RETADRESO por doni unu retadreson kien sendiĝas raportoj dum testoj."
  exit 1
fi 

@test "Ĉu mailsender.conf ekzistas" {
  skip
  load test-preparo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} ls /etc/mailsender.conf

  echo "${output}"
  [[ "$output" == *"mailsender.conf"* ]]
  [ "$status" -eq 0 ]
}

@test "Ĉu Perl-moduloj estas instalitaj ĝuste?" {
  skip
  load test-preparo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} bash -c "perl -MMIME::Entity -MAuthen::SASL::Perl -MIO::Socket::SSL -e1"

  echo "${output}"
  [[ "$output" == "" ]]
  [ "$status" -eq 0 ]
}

@test "Sendu retpoŝton por testi mailsender.pm" {  
  skip
  load test-preparo
  docker cp bin/test-mailsender.pl ${afido_id}:/usr/local/bin/
  run docker exec -u1074 -it -e TEST_RETADRESO ${afido_id} bash -c "perl /usr/local/bin/test-mailsender.pl"

  echo "${output}"
  [[ "$output" == *"OK Authenticated"* ]]
  [ "$status" -eq 0 ]
}


@test "Malpaku la git-arĥivon al revo-fonto" {  
  skip

  # tio preparas test-repo kaj gistojn
  load test-preparo-repo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} git-clone-repo.sh

  echo "${output}"
  [[ "$output" == *"done."* ]]
  [ "$status" -eq 0 ]
}

@test "Traktu submetojn de Araneo" {  
  skip
  load test-preparo-repo
  load test-preparo-mysql

  run docker exec -u1074 -it ${afido_id} git-clone-repo.sh
  echo "${output}"
  [[ "$output" == *"done."* ]]

  run docker exec -u1074 -it ${afido_id} ls etc/redaktantoj.json
  echo "${output}"
  [[ "$output" == *"redaktantoj.json"* ]]

  run docker exec -u1074 -it ${afido_id} bash -c "perl /usr/local/bin/processsubm.pl"
  echo "${output}"
  [[ "$output" == *"id:111111"* ]]
  [[ "$output" == *"id:2222222"* ]]
  #[[ "$output" == *"revo-fonto/revo/cxeval.xml': No such file"* ]]
  [[ "$output" == *"vi redaktis (cxeval)"* ]]
  [[ "$output" == *"create mode 100644 revo/abel.xml"* ]]
  [[ "$output" == *"master -> master"* ]]
  [[ "$output" == *"ŝovas /home/afido/dict/tmp/mailsend al /home/afido/dict/log/mail_sent"* ]]
  [ "$status" -eq 0 ]
}


@test "Traktu submetojn de Cetonio" {  
  #skip
  load test-preparo-repo
  load test-preparo-sqlite

  #run docker exec -u1074 -it ${afido_id} git-clone-repo.sh
  #run docker compose run --rm afido afido repo  
  #echo "${output}"
  #[[ "$output" == *"done."* ]]
#
  ##run docker exec -u1074 -it ${afido_id} ls etc/redaktantoj.json
  #run docker compose run --rm --network afidotesto_reto afido afido redl
  #echo "${output}"
  #[[ "$output" == *"redaktantoj.json"* ]]
  echo "PREPARITA"
  #run docker exec -u1074 -it ${afido_id} bash -c "perl /usr/local/bin/processsubm.pl"
  # vi devas antaŭdifini la du medivariablojn por submetoj: TEST_RETADRESO kaj ADM_PASSWORD
  run docker compose run --rm -e ADM_PASSWORD -e TEST_RETADRESO afido afido subm
  echo "${output}"
    # preno de redaktantoj
  [[ "$output" == *"/home/afido/etc/redaktantoj.json <- http://cetonio:8080/admin/redaktantoj-json.pl"* ]]
  # kopiado de Git-repo
  [[ "$output" == *"Elŝutante /home/afido/test-repo al revo-fonto..."* ]]
  [[ "$output" == *"Trovitaj novaj submetoj: 3"* ]]
  [[ "$output" == *"nova artikolo: cxeval"* ]]
  [[ "$output" == *"create mode 100644 revo/cxeval.xml"* ]]
#  [[ "$output" == *"master -> master"* ]]
#  [[ "$output" == *"ŝovas /home/afido/dict/tmp/mailsend al /home/afido/dict/log/mail_sent"* ]]
  [ "$status" -eq 0 ]
}



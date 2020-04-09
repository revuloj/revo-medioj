#!/usr/bin/env bats

#set -x
# https://github.com/sstephenson/bats/issues/136
# https://github.com/sstephenson/bats/issues/10

if [[ -z "$TEST_RETADRESO" ]]; then
  echo "Vi devas antaŭdifini variablon TEST_RETADRESO por doni unu retadreson kien sendiĝas raportoj dum testoj."
  exit 1
fi 

@test "Ĉu mailsender.conf ekzistas" {
  load test-preparo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} ls /etc/mailsender.conf

  echo "${output}"
  [[ "$output" == *"mailsender.conf"* ]]
  [ "$status" -eq 0 ]
}

@test "Ĉu Perl-moduloj estas instalitaj ĝuste?" {
  load test-preparo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} bash -c "perl -MMIME::Entity -MAuthen::SASL::Perl -MIO::Socket::SSL -e1"

  echo "${output}"
  [[ "$output" == "" ]]
  [ "$status" -eq 0 ]
}

@test "Sendu retpoŝton por testi mailsender.pm" {  
  #skip
  load test-preparo
  run docker exec -u1074 -it -e TEST_RETADRESO ${afido_id} bash -c "perl /usr/local/bin/test-mailsender.pl"

  echo "${output}"
  [[ "$output" == *"OK Authenticated"* ]]
  [ "$status" -eq 0 ]
}


@test "Malpaku la arĥivon al revo-fonto" {  
  #skip

  # tio preparas test-repo kaj gistojn
  load test-preparo-repo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} git-clone-repo.sh

  echo "${output}"
  [[ "$output" == *"done."* ]]
  [ "$status" -eq 0 ]
}

@test "Traktu gistojn" {  
  #skip
  load test-preparo-repo

  run docker exec -u1074 -it ${afido_id} git-clone-repo.sh
  echo "${output}"
  [[ "$output" == *"done."* ]]

  run docker exec -u1074 -it ${afido_id} ls etc/redaktantoj.json
  echo "${output}"
  [[ "$output" == *"redaktantoj.json"* ]]

  run docker exec -u1074 -it ${afido_id} bash -c "perl /usr/local/bin/processgist.pl"
  echo "${output}"

  [[ "$output" == *"revo-fonto/revo/cxeval.xml': No such file"* ]]
  [[ "$output" == *"create mode 100644 revo/abel.xml"* ]]
  [[ "$output" == *"master -> master"* ]]
  [ "$status" -eq 0 ]
}



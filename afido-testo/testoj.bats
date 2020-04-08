#!/usr/bin/env bats

#set -x
# https://github.com/sstephenson/bats/issues/136
# https://github.com/sstephenson/bats/issues/10

@test "Ĉu redaktantoj.json ekzistas" {
  load test-preparo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} ls etc/redaktantoj.json

  echo "${output}"
  [[ "$output" == *"redaktantoj.json"* ]]
  [ "$status" -eq 0 ]
}

@test "Ĉu mailsender.conf ekzistas" {
  load test-preparo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} ls /etc/mailsender.conf

  echo "${output}"
  [[ "$output" == *"mailsender.conf"* ]]
  [ "$status" -eq 0 ]
}

@test "Malpaku la arĥivon al revo-fonto" {  
  #skip

  # tio preparas test-repo kaj gistojn
  load test-preparo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} git-clone-repo.sh

  echo "${output}"
  [[ "$output" == *"done."* ]]
  [ "$status" -eq 0 ]
}


@test "Traktu gistojn" {  
  #skip
  load test-preparo
  run docker exec -u1074 -it ${afido_id} processgist.pl

  echo "${output}"
  [[ "$output" == *"xxxyyy"* ]]
  [ "$status" -eq 0 ]
}



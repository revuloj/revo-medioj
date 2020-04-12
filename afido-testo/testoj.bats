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

@test "Testu sigeladon per ŝelo kaj Perlo" {
  load test-preparo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  local -r sigelilo=$(docker exec -u1074 -it ${afido_id} cat /run/secrets/voko-afido.sigelilo)
  [[ ! -z "$sigelilo" ]]
  datumoj=$(echo $TEST_RETADRESO && cat /dev/urandom | tr -dc A-Z_a-z-0-9 | head -c${1:-32})
  #datumoj="123xyz"
  #datumoj="$TEST_RETADRESO"
    # OpenSSL: https://www.openssl.org/docs/man1.0.2/man1/openssl-dgst.html
    # -fips-fingerprint -macopt key:string 
    # JS, PHP: https://stackoverflow.com/questions/19884738/openssl-hmac-sha1-digest-does-not-match-cryptos
    # multaj lingvoj:
    # https://www.jokecamp.com/blog/examples-of-creating-base64-hashes-using-hmac-sha256-in-different-languages/
  HMAC1=$( echo -n "$datumoj" | openssl dgst -sha256 -hmac "${sigelilo}" ); HMAC1=${HMAC1#*= }
  HMAC2=$( perl -MDigest::SHA='hmac_sha256_hex' -e"print hmac_sha256_hex('${datumoj}','${sigelilo}')" )
  # https://metacpan.org/pod/Digest::HMAC

  echo "HMAC1: $HMAC1"
  echo "HMAC2: $HMAC2"
  [[ "$HMAC1" == "$HMAC2" ]]
  #[ "$status" -eq 0 ]
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


@test "Malpaku la arĥivon al revo-fonto" {  
  skip

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
  [ "$status" -eq 1 ]
}



#!/usr/bin/env bats

#set -x
# https://github.com/sstephenson/bats/issues/136
# https://github.com/sstephenson/bats/issues/10

echo "ATENTU: Tiuj testoj ne plu estas aktualaj!"
echo "Aktualaj testoj estas en medioj ../../afido-testo kaj ../../formikujo-t"
echo "Finante nun sen daŭrigi testadon!"
exit 1


@test "Ĉu mailsender.conf ekzistas" {
  #skip
  load test-preparo
  # elsuto test-repo (adresita per GIT_REPO_REVO)
  run docker exec -u1074 -it ${afido_id} ls /etc/mailsender.conf

  echo "${output}"
  [[ "$output" == *"mailsender.conf"* ]]
  [ "$status" -eq 0 ]
}

@test "Ĉu Perl-moduloj estas instalitaj ĝuste?" {
  #skip
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

@test "Variablo CVSROOT ekzistu kaj dosierujoj cvsroot/revo, dict/xml kaj dict/revo-fonto estu nemalplenaj" {
  afido_id=$(docker ps --filter name=formikujo_afido -q) && echo "Afido: ${afido_id}"
  cvs=$(docker exec -u1074 ${afido_id} bash -c "ls \${CVSROOT}/revo" | wc -w)
  xml=$(docker exec -u1074 ${afido_id} bash -c "ls /home/afido/dict/xml" | wc -w)
  git=$(docker exec -u1074 ${afido_id} bash -c "ls /home/afido/dict/revo-fonto/revo" | wc -w)
  echo "${cvs}"
  echo "${xml}"
  echo "${git}"
  [ "${cvs}" -gt 1 ]
  [ "${xml}" -gt 1 ]
  [ "${git}" -gt 1 ]
}

@test "Forsendo de retpoŝto kun ŝanĝetita XML de test.xml" {
  skip
  load test-preparo  
  local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) 
  local -r testfrom=$(docker  exec -u1074 ${afido_id} head -1 /run/secrets/voko.redaktantoj) 
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

@test "Trakto de retpoŝto kun test.xml per processmail.pl, poste estu trakto-dosiero en /var/afido/log/prcmail/" {
  skip
  load test-preparo
  load processmail-preparo

  docker exec -u0 ${afido_id} bash -c \
    "sed -i \"s/\s*[\$]debug\s*=.*/\\\$debug=1;/\" /usr/local/bin/processmail.test.pl"

  run docker exec -u1074 ${afido_id} processmail.test.pl
  echo "${output}"

  # forigu processmail.test.pl
  # vd. malsupredocker exec -u0 ${afido_id} rm /usr/local/bin/processmail.test.pl

  local -r time_prefix=$(date --utc +"%Y%m%d_%H%M")
  local -r last_file=$(docker exec -u1074 ${afido_id} ls -l /var/afido/log/prcmail/ | tail -1)
  echo "${last_file}"
  echo "${time_prefix}.."

  local -r git_status=$(docker exec -u1074 ${afido_id} bash -c "cd /home/afido/dict/revo-fonto ; git status")
  echo "${git_status}"

  load processmail-purigo

  # la lasta dosiernomo en mailerr devus nomiĝi laŭ nuna minuto:
  [[ "${last_file##* }" == "${time_prefix}"* ]]
  [[ "${git_status}" ==  *"up-to-date"* ]]
}

@test "Forsendo de retpoŝto kun nova XML de test007.xml" {
  #skip
  load test-preparo  
  local -r testmail_addr=$(docker  exec -u1074 ${tomocero_id} cat /run/secrets/voko-tomocero.relayaddress) 
  local -r testfrom=$(docker  exec -u1074 ${afido_id} head -1 /run/secrets/voko.redaktantoj) 
  local -r testfrom_addr=${testfrom##* }
  run docker exec -u1074 ${afido_id} bash -c \
    "echo -e \"Reply-To: ${testfrom_addr}\n\naldono: test007\n\n<?xml version='1.0'?>
    <!DOCTYPE vortaro SYSTEM '../dtd/vokoxml.dtd'><vortaro><art mrk='\$Id'><kap>007</kap></art></vortaro>\" | /usr/lib/sendmail -i -v ${testmail_addr}"
  [ "$status" -eq 0 ]
}

@test "Iom da atendo kaj poste provu legi la antaŭe senditan poŝtaĵon kun test007.xml" {
  #skip
  load test-preparo
  sleep 20
  run docker exec -u1074 ${tomocero_id} fetchmail
  echo "out: $output"
  echo "lin: "${lines[1]}
  [ "$status" -eq 0 ]
  [[ "${lines[1]}" == "reading message"* ]]
}

@test "Trakto de retpoŝto kun test007.xml per processmail.pl, poste estu trakto-dosiero en /var/afido/log/prcmail/" {
  #skip
  load test-preparo
  load processmail-preparo

  docker exec -u0 ${afido_id} bash -c \
    "sed -i \"s/\s*[\$]debug\s*=.*/\\\$debug=1;/\" /usr/local/bin/processmail.test.pl"

  run docker exec -u1074 ${afido_id} processmail.test.pl
  echo "${output}"

  # forigu processmail.test.pl
  # vd. malsupre... docker exec -u0 ${afido_id} rm /usr/local/bin/processmail.test.pl

  local -r time_prefix=$(date --utc +"%Y%m%d_%H%M")
  local -r last_file=$(docker exec -u1074 ${afido_id} ls -l /var/afido/log/prcmail/ | tail -1)
  local -r new_file=$(docker exec -u1074 ${afido_id} bash -c "ls -l /home/afido/dict/revo-fonto/revo/test007.*" | tail -1)
  echo "${last_file}"
  echo "${new_file}"
  echo "${time_prefix}.."

  local -r git_status=$(docker exec -u1074 ${afido_id} bash -c "cd /home/afido/dict/revo-fonto ; git status")
  echo "${git_status}"

  load processmail-purigo

  # la lasta dosiernomo en mailerr devus nomiĝi laŭ nuna minuto:
  [[ "${last_file##* }" == "${time_prefix}"* ]]
  [[ "${new_file##* }" == *"test007.xml"* ]]
  [[ "${git_status}" ==  *"up-to-date"* ]]
}



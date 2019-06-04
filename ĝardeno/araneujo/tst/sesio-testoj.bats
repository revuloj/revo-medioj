#!/usr/bin/env bats

@test "Sesio estas aktiva ĉe pordo 21" {

  ports=$(docker ps -f name=araneujo_sesio --format '{{.Ports}}')
  pnum=${ports%/tcp}

  echo "sesio: $(docker ps -f name=araneujo_sesio -q)"
  echo "ports: $ports"
  echo "port-num: $pnum"

  [ "$pnum" = "21" ]
}

@test "La uzanto 'sesio' ne povu skribi al /home/vsftpd sed sub-ujo sesio/" {
  sesio_id=$(docker ps --filter name=araneujo_sesio -q)
  wr_ftp=$(docker exec ${sesio_id} ls -ld /home/vsftpd | awk '{ print $1 }' | grep w || true)
  owner_ftp=$(docker exec ${sesio_id} ls -ld /home/vsftpd | awk '{ print $3 }')
  wr_sesio=$(docker exec ${sesio_id} ls -l /home/vsftpd | awk '/sesio/ { print $1 }' | grep drwx || true)
  owner_sesio=$(docker exec ${sesio_id} ls -l /home/vsftpd | awk '/sesio/ { print $3 }')

  [ -z ${wr_ftp} ]
  [ "${owner_ftp}" = "ftp" ]
  [ ! -z ${wr_sesio} ]
  [ "${owner_sesio}" = "sesio" ]
}

@test "Legi la pasvorton kiel sekreto kaj konekti per ftp" {
  sesio_id=$(docker ps --filter name=araneujo_sesio -q)
  ftp_pw=$(docker exec $sesio_id cat /run/secrets/voko-sesio.ftp-password)
  #echo $ftp_pw
  run ftp -n <<EOFTP
open localhost
user sesio ${ftp_pw}
quit
EOFTP
  # tio eliĝas nur se okazas problemoj...
  echo $output
  [ ! "$ftp_pw" = "" ]
  [ "$status" -eq 0 ]
}


@test "Alŝuti arĥivon kun dosiero per ftp al Sesio kaj malpaki ĝin per Perl en Araneo" {
  sesio_id=$(docker ps --filter name=araneujo_sesio -q)
  ftp_pw=$(docker exec $sesio_id cat /run/secrets/voko-sesio.ftp-password)
  #tst_dir=$(dirname "${BASH_SOURCE[0]}")
  tst_dir=$(dirname $BATS_TEST_FILENAME)
  echo ${tst_dir}
  #echo $ftp_pw
  # kreu arĥivon kun test.xml
  tar -czf test.tgz ${tst_dir}/test.xml
  run ftp -p -n <<EOFTP
open localhost
user sesio ${ftp_pw}
cd sesio
rename test.tgz test.old
put test.tgz
ls
quit
EOFTP
  rm test.tgz
  # tio eliĝas nur se okazas problemoj...
  echo $output
  [ ! "$ftp_pw" = "" ]
  [[ "$output" == *"test.tgz" ]]
#  [[ ! "$output" == *"denied"* ]]
#  [[ ! "$output" == *"failed"* ]]
#  [[ ! "$output" == *"not"* ]]
  [ "$status" -eq 0 ]
}
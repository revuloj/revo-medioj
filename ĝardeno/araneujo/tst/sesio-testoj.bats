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
  tgz="revo-$(date +"%Y%m%d"_120000).tgz"
  #echo $ftp_pw
  # kreu arĥivon kun test.xml
  tar -czf ${tgz} ${tst_dir}/test.xml
  run ftp -p -n <<EOFTP
open localhost
user sesio ${ftp_pw}
cd alveno
rename *.tgz *.old
put ${tgz}
ls
quit
EOFTP
  rm ${tgz}
  # tio eliĝas nur se okazas problemoj...
  echo $output
  [ ! "$ftp_pw" = "" ]
  [[ "$output" == *"_120000.tgz" ]]
#  [[ ! "$output" == *"denied"* ]]
#  [[ ! "$output" == *"failed"* ]]
#  [[ ! "$output" == *"not"* ]]
  [ "$status" -eq 0 ]
}


#http://reta-vortaro.de/cgi-bin/admin/uprevo.pl?fname=
@test "Trakti la arĥivon per uprevo.pl en Araneo" {
  araneo_id=$(docker ps --filter name=araneujo_araneo -q)
  #ftp_pw=$(docker exec $araneo_id cat /run/secrets/voko-sesio.ftp-password)

  araneo_host=localhost
  ports=$(docker service ls -f name=araneujo_araneo --format '{{.Ports}}')
  ip_port=${ports%->*}
  pnum=${ip_port#*:}
  echo "port-num: $pnum"
  tgz="revo-$(date +"%Y%m%d"_120000).tgz"

  url="http://${araneo_host}:${pnum}/cgi-bin/admin/uprevo.pl?fname=${tgz}"
  run curl -Ls -o uprevo.log ${url}
  # tio eliĝas nur se okazas problemoj...
  echo $output
  [ "$status" -eq 1 ]
}

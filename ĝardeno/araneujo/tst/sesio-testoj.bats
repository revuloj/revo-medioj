#!/usr/bin/env bats

@test "Sesio estas aktiva ĉe pordo 20-21" {

  ports=$(docker ps -f name=araneujo_sesio --format '{{.Ports}}')
  pnum=${ports%/tcp}

  echo "sesio: $(docker ps -f name=araneujo_sesio -q)"
  echo "ports: $ports"
  echo "port-num: $pnum"

  [ "$pnum" = "20-21" ]
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


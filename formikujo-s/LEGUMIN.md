Formikujo estas la redaktoservo, kiu povas akcepti redaktojn kaj rekalkuli la HTML-dosierojn de Reta Vortaro.
Normale ĝi funkcias kiel Gihub-ago, difinita per skripto en la projekto `revo-fontoj`. Tiu ĉi medio estas uzata por elprovi loke novajn eldonojn, analizi erarojn ktp.

Vi povas lanĉi Formikujon loke en medio de `docker swarm` per la komando `./fs-start.sh`. Antaŭe necesas krei la sekretojn kaj la reton `ghardeno`. Vd. la skriptojn `bin/*-sekretoj.sh` kaj `../bin/kreu_reton.sh`.

Formikujo konsistas el pluraj procezujoj (voko-formiko, voko-afido, evtl-e voko-tomocero). La kompono estas difinita en la dosiero `docker-compose.yml`.

Post sukcesa lanĉo de Formikujo vi povas lanĉi individuajn celojn por la programo `Apache Ant` per la skripto `formiko`. Ĝi ankaŭ enhavas helpinformojn pri kiuj celoj ekzistas. Voku do ekzemple:

```
  # ĝeneralaj informoj kaj eblaj prefiksoj
  ./fs-formikujo.sh formiko -h

  # celoj de la prefikso inx- por krei diversajn indeksojn
  ./fs-formiko.sh formiko inx-?

  # por krei ĉiujn indeks-dosierojn (daŭras!)
  ./fs-formiko.sh formiko inx-tuto
```
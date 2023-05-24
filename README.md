# revo-medioj
La agordoj por la servoj de Reta Vortaro


Superrigardo pri Revujo:
![Revujo - superrigardo](https://github.com/revuloj/revo-medioj/blob/master/Revujo-superrigardo.png "Revujo - superrigardo")


Estas tri retaplikaĵoj, kiuj kune formas la Revujon:
- araneujo - la retservo por uzantoj, siavice konsistanta el pluraj servetoj:
  - araneo - la retpaĝaro kun la retservilo
  - abelo - la serĉdatumbazo 
  - abelisto - administrilo de la datumbazo
  - sesio - akceptas ŝanĝojn de formiko/vaneso kaj aktualigas la datumbazon
  - tomocero - retpoŝtservo, kiu kolektas retpoŝtojn por forsendo kaj komunikas kun poŝtservo de la provizanto
- cetoniujo - la grafika redaktilo, konsistanta el:
  - cetonio - la redakto-servilo
  - grilo - la sintaks-kontrolilo
  - cikado - la citaĵo-serĉilo
  - akrido - la vortanalizilo
  - tomocero - retpoŝtservo, kiu kolektas retpoŝtojn por forsendo kaj komunikas kun poŝtservo de la provizanto
- formikujo - la transform-servo, konsistanta el:
  - afido - la redaktoservo, t.e. akceptilo de retpoŝtoj kun redaktoj, ĝi ankaŭ kontrolas la sintakson kaj stokas versiojn
  - formiko - la transformilo, kiu kretas ĉiujn retpaĝojn de la artikoloj, indeksoj, erarolistoj ktp.
  - vaneso - fakte du vanesoj, unu sendas ŝanĝojn de artikolversioj al la retservo kaj alia ŝanĝojn de la retpaĝoj kreitaj de formiko
  - tomocero - retpoŝtservo, kiu kolektas retpoŝtojn por forsendo kaj komunikas kun poŝtservo de la provizanto
  
Ni provizas agordojn de tiuj tri aplikaĵoj por kelkaj diversaj medioj:

- 'docker swarm' (sufikso -s), tio estas la preferata medio kaj taŭgas same por lokaj programedo kaj testado kiel por
  servado tra virtuala servilo.
- 'docker compose' (sufikso -c), tio estas simila sed pli simpla rimedo, kiu ekzemple rezignas pri kelkaj aferoj kiel
  speciala aranĝo de virtuala reto, kaŝitaj sekretoj kaj agordoj. En kelkaj cirkonstancoj 'docker swarm' ne
  funkcias aŭ ne estas dezirate, tiam vi povas uzi tiun pli tradician kaj simplan agordon
- 'kubernetes' (sufikso -k8s). Tio estas la profesia medio, kiun uzas renomaj provizantoj kiel Amazon, Google, MS k.a., tamen manke de konkreta bezono ni nur iom preparis tiujn mediojn, sed ne fintestis.

Krome por Formikujo ni ankaŭ havas duan agordon por 'docker swarm' kun sufikso (-t), kiun ni uzas por lokaj testoj. Por la testoj cetere ni precipe uzas testan kadron por ŝelo [bats](https://github.com/bats-core/bats-core). La test-skriptoj habvas finaĵon `.bats`.

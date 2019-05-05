# revo-medioj
La agordoj por la servoj de Reta Vortaro

Ni uzas tri mediojn:
- kelo: tio estas loka medio por la programado, kiu funkcias sur unu komputilo (loka "docker swarm"),
  sen bezono de veraj   poŝtfako, ret-atestiloj, retkontoj por redaktado
- ĝardeno: tio estas medio por testi ĉion kune kun veraj retpoŝtfakoj, retserviloj k.s. sed izolite de la veraj servoj
- mondo: tio estas la medio kie okazas la vera redaktado de Reta Vortaro

Superrigardo pri Revujo:
![Revujo - superrigardo](https://github.com/revuloj/revo-medioj/Revujo-superrigardo.png "Revujo - superrigardo")


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
  
  
  

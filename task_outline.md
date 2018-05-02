###
Aufgabe Titel
Beschreibung

Laufende Nummer
Schwierigkeit
Webseite
Autor
Keywords
OS

##


Task komplett wenn:
Tasks komplett

Es müssen alle Tasks gelöst werden damit die Aufgabe als gelöst gilt.
Tasks betehen aus:

Titel
Beschreibung
Kategorie: security
Zeitaufwand in min: max 60
Lösungsbeschriebung:
Hinweis:
Priorität low, mid, high

Der Score wird berechnet:
pro task: 1
multiplier prio 1,2,3
multiplier time <10 x1, <30x2 <60< x4


Beispiel:
################
title: Installiere einen apache webserver und bringe die demo webseite an den Start
why:
Der Apache websever ist eine der am meist genutzten Webserver.
Er ist teilweise sogar vorinstalliert. Muss aber aufgrund seiner Kompliexität auch konfiguriert werden.
categorie: web
time:
prio:
hint:
solution:
if [ -e "/usr/sbin/apache2" ]; then
    return 0;
else
    return 1;
fi
test: apt-get update && apt-get install apache2
##############






solved if:
apt --list installed | grep  apache2

service apache2 status == 0

curl localhost  | grep "Welcome" == 0







################
title: Check if installed
categorie: install
time: 10
prio: 1
hint: apt get install
check:


################

################
title: Check if installed
categorie: web
time:
prio:
hint:
check:


################


################
title: Check if installed
categorie: web
time:
prio:
hint:
check:


################



solved if:
apt --list installed | grep  apache2

service apache2 status == 0

curl localhost  | grep "Welcome" == 0
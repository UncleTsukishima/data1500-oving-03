# Besvarelse av refleksjonsspørsmål - DATA1500 Oppgavesett 1.3

Skriv dine svar på refleksjonsspørsmålene fra hver oppgave her.

---

## Oppgave 1: Docker-oppsett og PostgreSQL-tilkobling

### Spørsmål 1: Hva er fordelen med å bruke Docker i stedet for å installere PostgreSQL direkte på maskinen?

Om man har PostgreSQL direkte i maskinen, må man installere den på OS-et, og systemet kan endres.
Ved bruk av Docker kjører man i en isolert container, lett å starte, slutte og endre versjon.


---

### Spørsmål 2: Hva betyr "persistent volum" i docker-compose.yml? Hvorfor er det viktig?

Persistent Volume er et sted der data kan lagres utenfor containern, det betyr at dataen eksisterer fortsatt uansett om containern 
stoppes, slettes eller restartes.
---

### Spørsmål 3: Hva skjer når du kjører `docker-compose down`? Mister du dataene?

Når man kjører docker-compose down vil slette alt som ble opprettet av docker-compose up, men hvis man har persistent volum så lever databasen fortsatt.

---

### Spørsmål 4: Forklar hva som skjer når du kjører `docker-compose up -d` første gang vs. andre gang.

Når man kjører docker-compose up -d første gang vil den laste ned images, bygge containere og starte dem, den andre gangen vil docker sjekke om de images og containers allerede finnes og gjenbruker dem, så starter den containersa på nytt, om noe er endret vil den prøve å gjenopprette dem.

---

### Spørsmål 5: Hvordan ville du delt docker-compose.yml-filen med en annen student? Hvilke sikkerhetshensyn må du ta?

Man kan dele filen via Git Repository. Man burde passe på at passordet ikke er kodet inni filen. Det kan man ha i en .env fil og bruke .gitignore for å ikke pushe det til git.

---

## Oppgave 2: SQL-spørringer og databaseskjema

### Spørsmål 1: Hva er forskjellen mellom INNER JOIN og LEFT JOIN? Når bruker du hver av dem?

INNER JOIN returnerer kun rader som finnes i begge tabeller, man bruker denne når man vil ha feks en elev som er med i flere tabeller, dne henter kun gyldige koblinger.

LEFT JOIN
Inkluderer alle radene uansett hva fra venstre tabell, og krever ikke at radene matcher. Man kan bruke dette for å se om noen elever mangler noe feks, for rapporter som viser NULLs osv.

---

### Spørsmål 2: Hvorfor bruker vi fremmednøkler? Hva skjer hvis du prøver å slette et program som har studenter?

En fremmednøkkel sørger for at en verdi i en tabell eksisterer i en annen tabell. For eksempel så har vi emneregistreringer.emne_id som peker mot en rad i emner.emne_id. En fremmednøkkel vil også hindre deg fra å slette data som andre rader er avhengige av. Så hvis man hadde prøvd å slette et program som har studenter, så ville det blitt hindret. Modelleringen blir ryddigere og ytelse kan forbedres i flere tilfeller.

---

### Spørsmål 3: Forklar hva `GROUP BY` gjør og hvorfor det er nødvendig når du bruker aggregatfunksjoner.

GROUP BY sorterer rader med like verdier i en eller flere kolonner. Dette gjør at man kan kjøre aggregatfunksjoner fordi de lager 1 verdi, men vanlige kolonner har flere verdier. GROUP BY vil fortelle SQL hvilke rader som hører sammen når den verdien lages.

---

### Spørsmål 4: Hva er en indeks og hvorfor er den viktig for ytelse?

En indeks forteller databasen hvor data ligger, så den slipper å gå gjennom hele tabellen. Det gjør at lesingen av filer går fortere og programmet slipper å lese alle individuelle radene. 

---

### Spørsmål 5: Hvordan ville du optimalisert en spørring som er veldig treg?

De fleste gangene så gjør indeksering den største forskjellen, så man kan starte med å finne hvor tiden blir brukt. Man kan finne ut hvilke indekser som ikke brukes også indeksere det programmet spørr om. Man kan også bruke SELECT på det man spesifikt spørr om istedetfor SELECT *. Man kan bruke WHERE for å filtrere vekk verdier som ikke trengs.

---

## Oppgave 3: Brukeradministrasjon og GRANT

### Spørsmål 1: Hva er prinsippet om minste rettighet? Hvorfor er det viktig?

Prinsippet går utover at en bruker, rolle eller applikasjon skal bare ha de rettighetene den trenger og ingenting mer. Dette er viktig for å sikre feks skade som kan komme av at data lekkkes, hvis en angriper får tak i noens bruker kan de bare gjøre det brukern har rettigheter til og ingenting mer. Det er også viktig for å ha bedre kontroll og oversikt.

---

### Spørsmål 2: Hva er forskjellen mellom en bruker og en rolle i PostgreSQL?

En rolle i PostgreSQL er et sett med rettigheter, ulike roller har ulike rettigheter, en bruker kan sees på som en rolle for å logge inn.

---

### Spørsmål 3: Hvorfor er det bedre å bruke roller enn å gi rettigheter direkte til brukere?

Fordi å lage roller som gis ut til brukere er lettere og mer oversiktlig enn å gi rettigheter individuelt. Hvis du vil endre rettighetene for noen brukere, så er det lettere å endre selve rollen som endrer det for alle brukerne i den gruppen.

---

### Spørsmål 4: Hva skjer hvis du gir en bruker `DROP` rettighet? Hvilke sikkerhetsproblemer kan det skape?

DROP rettigheten gjør at en kan slette databaseobjekter eller databaser generelt. Dette kan skape store problemer hvor en angriper kan få tak i en slik bruker og bruke det for å slette data, dette kan ledes til store tap og ransomware.

---

### Spørsmål 5: Hvordan ville du implementert at en student bare kan se sine egne karakterer, ikke andres?

Du kan sette en studentrolle med read only, deretter kan man sette en spørring hvor loginnen forteller programmet hvilke rader som studenten kan få tilgang til, og disse er karakterene til studenten.

---

## Notater og observasjoner

Bruk denne delen til å dokumentere interessante funn, problemer du møtte, eller andre observasjoner:




## Oppgave 4: Brukeradministrasjon og GRANT

1. **Hva er Row-Level Security og hvorfor er det viktig?**
   - Det er en funksjon som lar deg begrense hvilke rader en bruker kan lese, endre eller slette. Dette er viktig for at brukere ikke kan se eller endre data som er viktig, dette er et eksempel på hvordan studenter kan se egne karakterer.

2. **Hva er forskjellen mellom RLS og kolonnebegrenset tilgang?**
   - Row level access gir tilgang til rader, studenter kan bare se sine enge karakterer. Kolonnebegrenset tilgang gjør at feks en bruker kan styre ulike kolonner for flere brukere, men bare den spesifikke kolonnen, feks en som styrer lønn for arbeidsmiljøet kan bare se lønnen men ikke annet informasjon.

3. **Hvordan ville du implementert at en student bare kan se karakterer for sitt eget program?**
   - VIA row level acccess som gjør at studenten bare kan se sine karakterer.

4. **Hva er sikkerhetsproblemene ved å bruke views i stedet for RLS?**
   - Views alene beskytter ikke imot sqli, så en bruker kan få tilgang til andre rader.

5. **Hvordan ville du testet at RLS-policyer fungerer korrekt?**
   - Kan sette opp test data med en test bruker med RLS også se om studenten kan få tilgang til andre rader.

---

## Referanser

- PostgreSQL dokumentasjon: https://www.postgresql.org/docs/
- Docker dokumentasjon: https://docs.docker.com/


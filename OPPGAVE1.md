qqqq# Oppgave 1: Docker-oppsett og PostgreSQL-tilkobling

## Læringsmål

Etter å ha fullført denne oppgaven skal du:
- Forstå hva Docker er og hvorfor det brukes
- Installere Docker Desktop på din maskin
- Kjøre PostgreSQL i en Docker-container
- Koble til PostgreSQL-databasen med `psql`
- Verifisere at databasen er initialisert med testdata

## Bakgrunn

**Docker** er en virtualiseringplattform som gjør det mulig å pakke applikasjoner og deres avhengigheter i isolerte enheter kalt **containere**. En container inneholder alt som trengs for å kjøre en applikasjon - operativsystem, biblioteker, og kode.

**Fordeler med Docker:**
- Samme miljø på alle maskiner (macOS, Windows, Linux)
- Enkelt å dele og reprodusere miljøer
- Isolering - flere applikasjoner kan kjøre uten konflikter
- Lett å starte/stoppe/slette

**docker-compose** er et verktøy som lar deg definere og kjøre flere Docker-containere med en enkelt kommando.

## Oppgave

### Del 1: Installer Docker Desktop

Følg veiledningen i `DOCKER_INSTALLASJON.md` for din operativsystem:
- **macOS:** Apple Silicon eller Intel
- **Windows:** WSL 2
- **Linux:** Docker og docker-compose

Verifiser at Docker er installert:
```bash
docker --version
```

### Del 2: Start PostgreSQL med docker-compose

I mappen `data1500-oving-03` kjør:

```bash
docker-compose up -d
```

Verifiser at containeren kjører:

```bash
docker-compose ps
```

Du skal se:
```
NAME                  STATUS
data1500-postgres     Up (healthy)
```

### Del 3: Koble til PostgreSQL

Åpne en terminal og kjør:

```bash
docker-compose exec postgres psql -U admin -d data1500_db
```

Passord: `admin123` (ikke nødvendig siden bruker postgres)

Du skal nå være i PostgreSQL-prompten (`data1500_db=#`).

### Del 4: Verifiser initialisering

Kjør følgende SQL-spørringer for å verifisere at databasen er initialisert:

```sql
-- Vis alle tabeller
\dt

-- Tell antall programmer
SELECT COUNT(*) as antall_programmer FROM programmer;

-- Tell antall studenter
SELECT COUNT(*) as antall_studenter FROM studenter;

-- Tell antall emner
SELECT COUNT(*) as antall_emner FROM emner;

-- Vis alle roller
SELECT rolname FROM pg_roles WHERE rolname NOT LIKE 'pg_%';
```

### Del 5: Utforsk databasen

Kjør disse spørringene for å bli kjent med datastrukturen:

```sql
-- Vis alle programmer
SELECT * FROM programmer;

-- Vis alle studenter
SELECT * FROM studenter;

-- Vis alle emner
SELECT * FROM emner;

-- Vis emneregistreringer
SELECT * FROM emneregistreringer;
```

## Refleksjonsspørsmål

Besvar refleksjonsspørsmål i filen **besvarelse-refleksjon.md**


## Avslutning

Når du er ferdig:
- Databasen kjører i en Docker-container
- Du kan koble til med `psql`
- Testdata er lastet inn
- Du er klar for oppgave 2

For å stoppe PostgreSQL: `docker-compose down`
For å starte igjen: `docker-compose up -d`
For å slette alle data fra den lokale datamaskinen `docker volume rm <volum_navn>`

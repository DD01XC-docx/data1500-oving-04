# Oppgavesett 1.4: Databasemodell og implementasjon for Nettbasert Undervisning

I dette oppgavesettet skal du designe en database for et nettbasert undervisningssystem. Les casen nøye og løs de fire deloppgavene som følger.

Denne oppgaven er en øving og det forventes ikke at du kan alt som det er spurt etter her. Vi skal gå gjennom mange av disse tingene detaljert i de nærmeste ukene. En lignende oppbygging av oppgavesettet, er det ikke helt utelukket at, skal bli brukt i eksamensoppgaven.

Du bruker denne filen for å besvare deloppgavene. Du må eventuelt selv finne ut hvordan du kan legge inn bilder (images) i en Markdown-fil som denne. Da kan du ta et bilde av dine ER-diagrammer, legge bildefilen inn på en lokasjon i repository og henvise til filen med syntaksen i Markdown. 

Det er anbefalt å tegne ER-diagrammer med [mermaid.live](https://mermaid.live/) og legge koden inn i Markdown (denne filen) på følgende måte:
```
```mermaid
erDiagram
    studenter 
    ...
``` 
Det finnes bra dokumentasjon [EntityRelationshipDiagram](https://mermaid.js.org/syntax/entityRelationshipDiagram.html) for hvordan tegne ER-diagrammer med mermaid-kode. 

## Case: Databasesystem for Nettbasert Undervisning

Det skal lages et databasesystem for nettbasert undervisning. Brukere av systemet er studenter og lærere, som alle logger på med brukernavn og passord. Det skal være mulig å opprette virtuelle klasserom. Hvert klasserom har en kode, et navn og en lærer som er ansvarlig.

Brukere kan deles inn i grupper. En gruppe kan gis adgang ("nøkkel") til ett eller flere klasserom.

I et klasserom kan studentene lese beskjeder fra læreren. Hvert klasserom har også et diskusjonsforum, der både lærere og studenter kan skrive innlegg. Til et innlegg kan det komme flere svarinnlegg, som det igjen kan komme svar på (en hierarkisk trådstruktur). Både beskjeder og innlegg har en avsender, en dato, en overskrift og et innhold (tekst).

## Del 1: Konseptuell Datamodell

**Oppgave:** Beskriv en konseptuell datamodell (med tekst eller ER-diagram) for systemet. Modellen skal kun inneholde entiteter, som du har valgt, og forholdene mellom dem, med kardinalitet. Du trenger ikke spesifisere attributter i denne delen.

**Ditt svar:***
USER || -- o{ USER_GROUP : "is member of"
GROUP || -- o{ USER_GROUP  : "includes"
GROUP || -- o{ ACCESS_KEY : "has"
CLASSROOM || -- o{ ACCESS_KEY : "granted_to"
USER || -- o{ CLASSROOM : "manages(TEAHCER)"
USER || -- o{ ANNOUNCEMENT : "writes"
CLASSROOM || -- o{ ANNOUNCEMENT : "contains"
CLASSROOM ||-- o{ POST : "contains in forum"
USER || -- o{ POST : "writes in forum"
POST || -- o{ POST : "replies in forum"

## Del 2: Logisk Skjema (Tabellstruktur)

**Oppgave:** Oversett den konseptuelle modellen til en logisk tabellstruktur. Spesifiser tabellnavn, attributter (kolonner), datatyper, primærnøkler (PK) og fremmednøkler (FK). Tegn et utvidet ER-diagram med [mermaid.live](https://mermaid.live/) eller eventuelt på papir.


**Ditt svar:***
USER {
    int user_id PK
    string username
    string password
    string role
}
GROUP {
    varchar(10) group_id PK
    string groupname
}
USER_GROUP {
    int gruppe_id FK
    int user_id FK
}
CLASSROOM {
    int classroom_id PK
    string kode
    string name
    int ansvalig_larer_id FK
}
ACCESS_KEY {
    int user_id FK
    int classroom_id FK
}
ANNOUNCEMENT {
    int announcement_id PK
    int user_id FK
    int classroom_id FK
    varchar(50) title
    varchar(150) text
    timestamp dato
}
POST {
    int post_id PK
    int user_id FK
    int classroom_id FK
    int parent_post_id FK
    varchar(50) title
    varchar(100) text
    timestamp dato
}

## Del 3: Datadefinisjon (DDL) og Mock-Data

**Oppgave:** Skriv SQL-setninger for å opprette tabellstrukturen (DDL - Data Definition Language) og sett inn realistiske mock-data for å simulere bruk av systemet.


**Ditt svar:***
CREATE TABLE USERS (
    user_id VARCHAR(15) PRIMARY KEY,
    username VARCHAR(25) NOT NULL UNIQUE,
    pass VARCHAR(25) NOT NULL,
    name VARCHAR(100) NOT NULL
);
CREATE TABLE GROUPS (
    group_id VARCHAR(10) PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL
);
CREATE TABLE USER_GROUP (
    group_id VARCHAR(10) REFERENCES GROUPS(group_id),
    user_id VARCHAR(15) REFERENCES USERS(user_id)
);
CREATE TABLE CLASSROOM (
    classroom_id VARCHAR(10) PRIMARY KEY,
    code VARCHAR(10) NOT NULL,
    classroom_name VARCHAR(50) NOT NULL,
    ansvarlig_larer_id VARCHAR(15) REFERENCES USERS(user_id)
);
CREATE TABLE ACCESS_KEY (
    group_id VARCHAR(15) REFERENCES GROUPS(group_id),
    classroom_id VARCHAR(10) REFERENCES CLASSROOM(classroom_id)
);
CREATE TABLE ANNOUNCEMENT (
    announcement_id INTEGER PRIMARY KEY,
    user_id VARCHAR(15) REFERENCES USERS(user_id),
    classroom_id VARCHAR(10) REFERENCES CLASSROOM(classroom_id),
    title VARCHAR(50) NOT NULL,
    innlegg VARCHAR(150) NOT NULL,
    dato TIMESTAMP NOT NULL
);
CREATE TABLE POST (
    post_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(15) REFERENCES USERS(user_id),
    classroom_id VARCHAR(10) REFERENCES CLASSROOM(classroom_id),
    parent_post_id VARCHAR(20) REFERENCES POST(post_id),
    title VARCHAR(50) NOT NULL,
    innlegg VARCHAR(150) NOT NULL,
    dato TIMESTAMP NOT NULL
);

__Mock-Data__

INSERT INTO USERS (user_id, username, pass, name) VALUES 
('YEMOA22', 'nentisoff', 'secret123', 'Nils Nilsen'),
('WWWWW', 'lainesx', 'pass123', 'Eivind Hansen'),
('CCCCC', 'dd01xc', 'oasdp11', 'Yevhenii Konus'),
('DDDDD', 'afgwafg', 'qwerty', 'Johan Johannesen');

INSERT INTO GROUPS (group_id, group_name) VALUES
('ADATA-B', 'Anvendt datateknologi'),
('ADATA-C', 'Dataingjenører');

INSERT INTO USER_GROUP (group_id, user_id) VALUES
('ADATA-B', 'WWWWW'),
('ADATA-C', 'CCCCC');

INSERT INTO CLASSROOM(classroom_id, code, classroom_name, ansvarlig_larer_id) VALUES
('CLASS1', 'DATA1100', 'Webutvikling', 'DDDDD'),
('CLASS2', 'DAPE1400', 'Javauntikling', 'YEMOA22');

INSERT INTO ACCESS_KEY (group_id, classroom_id) VALUES
('ADATA-B', 'CLASS1'),
('ADATA-C', 'CLASS2');

INSERT INTO ANNOUNCEMENT (announcement_id, user_id, classroom_id, title, innlegg, dato) VALUES 
(3344, 'YEMOA22', 'CLASS2', 'EXAMPLETITLE', 'EXAMPLETEXT', CURRENT_TIMESTAMP),
(5566, 'DDDDD', 'CLASS1', 'EXAMPLETITLE2', 'EXAMPLETEXT2', CURRENT_TIMESTAMP);

INSERT INTO POST (post_id, user_id, classroom_id, parent_post_id, title, innlegg, dato) VALUES
('inn1', 'CCCCC', 'CLASS1', NULL, 'EXAMPLETITLEPOST', 'EXAMPLEINNLEGGPOST', CURRENT_TIMESTAMP),
('inn2', 'DDDDD', 'CLASS2', 'inn2', 'EXAMPLETITLEPOST2', 'EXAMPLEINNLEGGPOST2', CURRENT_TIMESTAMP); svar:***
CREATE TABLE USERS (
    user_id VARCHAR(15) PRIMARY KEY,
    username VARCHAR(25) NOT NULL UNIQUE,
    pass VARCHAR(25) NOT NULL,
    name VARCHAR(100) NOT NULL
);
CREATE TABLE GROUPS (
    group_id VARCHAR(10) PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL
);
CREATE TABLE USER_GROUP (
    group_id VARCHAR(10) REFERENCES GROUPS(group_id),
    user_id VARCHAR(15) REFERENCES USERS(user_id)
);
CREATE TABLE CLASSROOM (
    classroom_id VARCHAR(10) PRIMARY KEY,
    code VARCHAR(10) NOT NULL,
    classroom_name VARCHAR(50) NOT NULL,
    ansvarlig_larer_id VARCHAR(15) REFERENCES USERS(user_id)
);
CREATE TABLE ACCESS_KEY (
    group_id VARCHAR(15) REFERENCES GROUPS(group_id),
    classroom_id VARCHAR(10) REFERENCES CLASSROOM(classroom_id)
);
CREATE TABLE ANNOUNCEMENT (
    announcement_id INTEGER PRIMARY KEY,
    user_id VARCHAR(15) REFERENCES USERS(user_id),
    classroom_id VARCHAR(10) REFERENCES CLASSROOM(classroom_id),
    title VARCHAR(50) NOT NULL,
    innlegg VARCHAR(150) NOT NULL,
    dato TIMESTAMP NOT NULL
);
CREATE TABLE POST (
    post_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(15) REFERENCES USERS(user_id),
    classroom_id VARCHAR(10) REFERENCES CLASSROOM(classroom_id),
    parent_post_id VARCHAR(20) REFERENCES POST(post_id),
    title VARCHAR(50) NOT NULL,
    innlegg VARCHAR(150) NOT NULL,
    dato TIMESTAMP NOT NULL
);

__Mock-Data__

INSERT INTO USERS (user_id, username, pass, name) VALUES 
('YEMOA22', 'nentisoff', 'secret123', 'Nils Nilsen'),
('WWWWW', 'lainesx', 'pass123', 'Eivind Hansen'),
('CCCCC', 'dd01xc', 'oasdp11', 'Yevhenii Konus'),
('DDDDD', 'afgwafg', 'qwerty', 'Johan Johannesen');

INSERT INTO GROUPS (group_id, group_name) VALUES
('ADATA-B', 'Anvendt datateknologi'),
('ADATA-C', 'Dataingjenører');

INSERT INTO USER_GROUP (group_id, user_id) VALUES
('ADATA-B', 'WWWWW'),
('ADATA-C', 'CCCCC');

INSERT INTO CLASSROOM(classroom_id, code, classroom_name, ansvarlig_larer_id) VALUES
('CLASS1', 'DATA1100', 'Webutvikling', 'DDDDD'),
('CLASS2', "DAPE1400", 'Javauntikling', 'YEMOA22');

INSERT INTO ACCESS_KEY (group_id, classroom_id) VALUES
('ADATA-B', 'CLASS1'),
('ADATA-C', 'CLASS2');

INSERT INTO ANNOUNCEMENT (announcement_id, user_id, classroom_id, title, innlegg, dato) VALUES 
(3344, 'YEMOA22', 'CLASS2', 'EXAMPLETITLE', 'EXAMPLETEXT', CURRENT_TIMESTAMP),
(5566, 'DDDDD', 'CLASS1', 'EXAMPLETITLE2', 'EXAMPLETEXT2', CURRENT_TIMESTAMP);

INSERT INTO POST (post_id, user_id, classroom_id, parent_post_id, title, innlegg, dato) VALUES
('inn1', 'CCCCC', 'CLASS1', NULL, 'EXAMPLETITLEPOST', 'EXAMPLEINNLEGGPOST', CURRENT_TIMESTAMP),
('inn2', 'DDDDD', 'CLASS1', 'inn1', 'EXAMPLETITLEPOST2', 'EXAMPLEINNLEGGPOST2', CURRENT_TIMESTAMP);
## Del 4: Spørringer mot Databasen

**Oppgave:** Skriv SQL-spørringer for å hente ut informasjonen beskrevet under. For hver oppgave skal du levere svar med både relasjonsalgebra-notasjon og standard SQL.

### 1. Finn de 3 nyeste beskjeder fra læreren i et gitt klasserom (f.eks. klasserom_id = 1).

*   **Relasjonsalgebra:**
    >   PROJECT announcement_id, title, innlegg, dato ( SELECT an.classroom_id = 1 AND an.user_id = c.ansvarlig_larer_id ( announcement AS an JOIN_{an.classroom_id = c.classroom_id} classroom AS c ) )
    
*   **SQL:**
    ```sql
    SELECT an.announcement_id,
    an.title,
    an.innlegg,
    an.dato
    FROM announcement an
    JOIN classroom c ON an.classroom_id = c.classroom_id
    WHERE an.user_id = '1'
    AND an.user_id = c.ansvarlig_larer_id
    ORDER BY an.dato DESC
    LIMIT 3;
    ```

### 2. Vis en hel diskusjonstråd startet av en spesifikk student (f.eks. avsender_id = 2).

*   **Relasjonsalgebra**
    > Trenger ikke å skrive en relasjonsalgebra setning her, siden det blir for komplekst og uoversiktlig. 

*   **SQL (med `WITH RECURSIVE`):**

    Du kan vente med denne oppgaven til vi har gått gjennom avanserte SQL-spørringer (tips: må bruke en rekursiv konstruksjon `WITH RECURSIVE diskusjonstraad AS (..) SELECT FROM diskusjonstraad ...`)
    ```sql
    WITH RECURSIVE diskusjonstrad AS (
    SELECT
        p.post_id,
        p.innlegg,
        p.parent_post_id,
        p.user_id,
        p.post_id AS root_id,
        0 AS depth
    FROM
        post p
    WHERE
        p.user_id = 'CCCCC'
    AND
        p.parent_post_id IS NULL
    UNION ALL
    SELECT
        c.post_id,
        c.innlegg,
        c.parent_post_id,
        c.user_od,
        c.root_id,
        d.depth + 1
    FROM post c
    JOIN diskusjonstrad d
    ON c.parent_post_id = d.post_id
    )
    SELECT *
    FROM diskusjonstrad
    ORDER BY root_id, depth, post_id;
    ```

### 3. Finn alle studenter i en spesifikk gruppe (f.eks. gruppe_id = 1).

*   **Relasjonsalgebra:**
    > 

*   **SQL:**
    ```sql
    SELECT u.user_id, u.username, u.name
    FRIM user_group ug
    JOIN users u ON u.user_id = ug.user_id
    WHERE ug.group_id = 'ADATA-C';
    ```

### 4. Finn antall grupper.

*   **Relasjonsalgebra (med aggregering):**
    > 

*   **SQL:**
    ```sql
    SELECT COUNT(*) AS antall_grupper
    FROM groups;
    ```

## Del 5: Implementer i postgreSQL i din Docker container

**Oppgave:** Gjenbruk `docker-compose.yml` fra Oppgavesett 1.3 (er i denne repositorien allerede, så du trenger ikke å gjøre noen endringer) og prøv å legge inn din skript for opprettelse av databasen for nettbasert undervsining med noen testdata i filen `01-init-database.sql` i mappen `init-scripts`. Du trenger ikke å opprette roller. 

Lagre alle SQL-spørringene dine fra oppgave 4 i en fil `oppgave4_losning.sql` i mappen `test-scripts` for at man kan teste disse med kommando:

```bash
docker-compose exec postgres psql -U admin -d data1500_db -f test-scripts/oppgave4_losning.sql
```

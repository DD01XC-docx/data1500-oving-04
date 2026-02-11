-- ============================================================================
-- DATA1500 - Oppgavesett 1.5: Databasemodellering og implementasjon
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Gjør skriptet kjørbart flere ganger
DROP TABLE IF EXISTS ACCESS_KEY CASCADE;
DROP TABLE IF EXISTS USER_GROUP CASCADE;
DROP TABLE IF EXISTS ANNOUNCEMENT CASCADE;
DROP TABLE IF EXISTS POST CASCADE;
DROP TABLE IF EXISTS CLASSROOM CASCADE;
DROP TABLE IF EXISTS GROUPS CASCADE;
DROP TABLE IF EXISTS USERS CASCADE;

-- Opprett grunnleggende tabeller
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

-- Sett inn testdata
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

INSERT INTO CLASSROOM (classroom_id, code, classroom_name, ansvarlig_larer_id) VALUES
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
('inn2', 'DDDDD', 'CLASS1', 'inn1', 'EXAMPLETITLEPOST2', 'EXAMPLEINNLEGGPOST2', CURRENT_TIMESTAMP);

SELECT 'Database initialisert!' AS status;
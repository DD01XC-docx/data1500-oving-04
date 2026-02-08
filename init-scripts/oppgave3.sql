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
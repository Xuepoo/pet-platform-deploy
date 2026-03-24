BEGIN;

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL, 
    CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);

-- Running upgrade  -> 66234075237a

CREATE TABLE "user" (
    id SERIAL NOT NULL, 
    full_name VARCHAR, 
    email VARCHAR NOT NULL, 
    hashed_password VARCHAR NOT NULL, 
    is_active BOOLEAN, 
    is_superuser BOOLEAN, 
    PRIMARY KEY (id)
);

CREATE UNIQUE INDEX ix_user_email ON "user" (email);

CREATE INDEX ix_user_full_name ON "user" (full_name);

CREATE INDEX ix_user_id ON "user" (id);

CREATE TABLE pet (
    id SERIAL NOT NULL, 
    name VARCHAR, 
    species VARCHAR, 
    breed VARCHAR, 
    age INTEGER, 
    description VARCHAR, 
    status VARCHAR, 
    owner_id INTEGER, 
    PRIMARY KEY (id), 
    FOREIGN KEY(owner_id) REFERENCES "user" (id)
);

CREATE INDEX ix_pet_breed ON pet (breed);

CREATE INDEX ix_pet_id ON pet (id);

CREATE INDEX ix_pet_name ON pet (name);

CREATE INDEX ix_pet_species ON pet (species);

CREATE TABLE report (
    id SERIAL NOT NULL, 
    pet_name VARCHAR, 
    description VARCHAR, 
    location VARCHAR, 
    status VARCHAR, 
    contact_info VARCHAR, 
    user_id INTEGER, 
    PRIMARY KEY (id), 
    FOREIGN KEY(user_id) REFERENCES "user" (id)
);

CREATE INDEX ix_report_id ON report (id);

CREATE INDEX ix_report_pet_name ON report (pet_name);

CREATE TABLE application (
    id SERIAL NOT NULL, 
    pet_id INTEGER, 
    user_id INTEGER, 
    status VARCHAR, 
    created_at TIMESTAMP WITHOUT TIME ZONE, 
    PRIMARY KEY (id), 
    FOREIGN KEY(pet_id) REFERENCES pet (id), 
    FOREIGN KEY(user_id) REFERENCES "user" (id)
);

CREATE INDEX ix_application_id ON application (id);

INSERT INTO alembic_version (version_num) VALUES ('66234075237a') RETURNING alembic_version.version_num;

-- Running upgrade 66234075237a -> 2faba9cf9fe4

ALTER TABLE application ADD COLUMN message VARCHAR;

UPDATE alembic_version SET version_num='2faba9cf9fe4' WHERE alembic_version.version_num = '66234075237a';

-- Running upgrade 2faba9cf9fe4 -> baf78d7a6b6e

ALTER TABLE report ADD COLUMN report_type VARCHAR;

ALTER TABLE report ADD COLUMN image_url VARCHAR;

UPDATE alembic_version SET version_num='baf78d7a6b6e' WHERE alembic_version.version_num = '2faba9cf9fe4';

-- Running upgrade baf78d7a6b6e -> cc12c5e5713b

ALTER TABLE "user" ADD COLUMN age INTEGER;

ALTER TABLE "user" ADD COLUMN gender VARCHAR;

ALTER TABLE "user" ADD COLUMN avatar VARCHAR;

ALTER TABLE "user" ADD COLUMN bio VARCHAR;

UPDATE alembic_version SET version_num='cc12c5e5713b' WHERE alembic_version.version_num = 'baf78d7a6b6e';

-- Running upgrade cc12c5e5713b -> 9e193c1938e0

CREATE TABLE post (
    id SERIAL NOT NULL, 
    title VARCHAR(200), 
    content TEXT NOT NULL, 
    author_id INTEGER NOT NULL, 
    created_at TIMESTAMP WITHOUT TIME ZONE, 
    updated_at TIMESTAMP WITHOUT TIME ZONE, 
    PRIMARY KEY (id), 
    FOREIGN KEY(author_id) REFERENCES "user" (id)
);

CREATE INDEX ix_post_created_at ON post (created_at);

CREATE INDEX ix_post_id ON post (id);

CREATE TABLE comment (
    id SERIAL NOT NULL, 
    content TEXT NOT NULL, 
    post_id INTEGER NOT NULL, 
    author_id INTEGER NOT NULL, 
    parent_id INTEGER, 
    created_at TIMESTAMP WITHOUT TIME ZONE, 
    updated_at TIMESTAMP WITHOUT TIME ZONE, 
    PRIMARY KEY (id), 
    FOREIGN KEY(author_id) REFERENCES "user" (id), 
    FOREIGN KEY(parent_id) REFERENCES comment (id), 
    FOREIGN KEY(post_id) REFERENCES post (id)
);

CREATE INDEX ix_comment_created_at ON comment (created_at);

CREATE INDEX ix_comment_id ON comment (id);

CREATE TABLE post_like (
    id SERIAL NOT NULL, 
    post_id INTEGER NOT NULL, 
    user_id INTEGER NOT NULL, 
    created_at TIMESTAMP WITHOUT TIME ZONE, 
    PRIMARY KEY (id), 
    FOREIGN KEY(post_id) REFERENCES post (id), 
    FOREIGN KEY(user_id) REFERENCES "user" (id)
);

CREATE INDEX ix_post_like_id ON post_like (id);

CREATE TABLE post_media (
    id SERIAL NOT NULL, 
    post_id INTEGER NOT NULL, 
    url VARCHAR(500) NOT NULL, 
    media_type VARCHAR(50) NOT NULL, 
    created_at TIMESTAMP WITHOUT TIME ZONE, 
    PRIMARY KEY (id), 
    FOREIGN KEY(post_id) REFERENCES post (id)
);

CREATE INDEX ix_post_media_id ON post_media (id);

CREATE TABLE comment_like (
    id SERIAL NOT NULL, 
    comment_id INTEGER NOT NULL, 
    user_id INTEGER NOT NULL, 
    created_at TIMESTAMP WITHOUT TIME ZONE, 
    PRIMARY KEY (id), 
    FOREIGN KEY(comment_id) REFERENCES comment (id), 
    FOREIGN KEY(user_id) REFERENCES "user" (id)
);

CREATE INDEX ix_comment_like_id ON comment_like (id);

UPDATE alembic_version SET version_num='9e193c1938e0' WHERE alembic_version.version_num = 'cc12c5e5713b';

-- Running upgrade 9e193c1938e0 -> 25b72f8e7364

ALTER TABLE "user" ADD COLUMN birthdate VARCHAR;

UPDATE alembic_version SET version_num='25b72f8e7364' WHERE alembic_version.version_num = '9e193c1938e0';

-- Running upgrade 25b72f8e7364 -> cfa24d691477

ALTER TABLE pet ADD COLUMN gender VARCHAR;

ALTER TABLE pet ADD COLUMN size VARCHAR;

ALTER TABLE pet ADD COLUMN image_url VARCHAR;

UPDATE alembic_version SET version_num='cfa24d691477' WHERE alembic_version.version_num = '25b72f8e7364';

-- Running upgrade cfa24d691477 -> 51aaf28435f2

CREATE TABLE petfavorite (
    id SERIAL NOT NULL, 
    user_id INTEGER, 
    pet_id INTEGER, 
    PRIMARY KEY (id), 
    FOREIGN KEY(pet_id) REFERENCES pet (id), 
    FOREIGN KEY(user_id) REFERENCES "user" (id)
);

CREATE INDEX ix_petfavorite_id ON petfavorite (id);

UPDATE alembic_version SET version_num='51aaf28435f2' WHERE alembic_version.version_num = 'cfa24d691477';

-- Running upgrade 51aaf28435f2 -> 429392f1745b

ALTER TABLE report ADD COLUMN created_at TIMESTAMP WITHOUT TIME ZONE;

ALTER TABLE report ADD COLUMN updated_at TIMESTAMP WITHOUT TIME ZONE;

CREATE INDEX ix_report_created_at ON report (created_at);

UPDATE alembic_version SET version_num='429392f1745b' WHERE alembic_version.version_num = '51aaf28435f2';

COMMIT;


-- -----------------------------------------------------
-- Schema family_chronicle
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS public CASCADE;

-- -----------------------------------------------------
-- Schema family_chronicle
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS public;

-- -----------------------------------------------------
-- Table `family_chronicle`.`people`
-- -----------------------------------------------------
DROP TABLE IF EXISTS people CASCADE;

CREATE TABLE IF NOT EXISTS people (
  id         BIGINT                   NOT NULL,
  firstname  VARCHAR(45)              NULL,
  lastname   VARCHAR(45)              NULL,
  birthday   TIMESTAMP WITH TIME ZONE NULL,
  male       BOOLEAN                  NULL DEFAULT TRUE,
  father_id  BIGINT                   NULL,
  mother_id  BIGINT                   NULL,
  alive      BOOLEAN                  NULL DEFAULT TRUE,
  death_date TIMESTAMP WITH TIME ZONE NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_people_father
  FOREIGN KEY (father_id)
  REFERENCES people (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_people_mother
  FOREIGN KEY (mother_id)
  REFERENCES people (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_people_father_idx ON people (father_id ASC);
CREATE INDEX fk_people_mother_idx ON people (mother_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS account CASCADE;

CREATE TABLE IF NOT EXISTS account (
  id        BIGINT       NOT NULL,
  email     VARCHAR(254) NOT NULL,
  people_id BIGINT       NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT account_email_UNIQUE UNIQUE (email),
  CONSTRAINT fk_account_people
  FOREIGN KEY (people_id)
  REFERENCES people (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_account_people_idx ON account (people_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS role CASCADE;

CREATE TABLE IF NOT EXISTS role (
  id   BIGINT      NOT NULL,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT role_name_UNIQUE UNIQUE (name)
);


-- -----------------------------------------------------
-- Table `family_chronicle`.`role_has_account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS role_has_account CASCADE;

CREATE TABLE IF NOT EXISTS role_has_account (
  role_id    BIGINT NOT NULL,
  account_id BIGINT NOT NULL,
  PRIMARY KEY (role_id, account_id)
  ,
  CONSTRAINT role_account_UNIQUE UNIQUE (role_id, account_id),
  CONSTRAINT fk_role_has_account_role
  FOREIGN KEY (role_id)
  REFERENCES role (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_role_has_account_account
  FOREIGN KEY (account_id)
  REFERENCES account (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_role_has_account_account_idx ON role_has_account (account_id ASC);
CREATE INDEX fk_role_has_account_role_idx ON role_has_account (role_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`credential`
-- -----------------------------------------------------
DROP TABLE IF EXISTS credential CASCADE;

CREATE TABLE IF NOT EXISTS credential (
  id                            BIGINT                   NOT NULL,
  username                      VARCHAR(256)             NULL,
  password                      VARCHAR(256)             NOT NULL,
  create_date                   TIMESTAMP WITH TIME ZONE NOT NULL,
  last_password_change_date     TIMESTAMP WITH TIME ZONE NULL,
  failed_password_attempt_count INT                      NULL,
  locked_out                    BOOLEAN                  NOT NULL DEFAULT FALSE,
  account_id                    BIGINT                   NOT NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_credential_account
  FOREIGN KEY (account_id)
  REFERENCES account (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_credential_account_idx ON credential (account_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`name_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS name_type CASCADE;

CREATE TABLE IF NOT EXISTS name_type (
  id   BIGINT      NOT NULL,
  type VARCHAR(45) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT name_type_UNIQUE UNIQUE (type)
);


-- -----------------------------------------------------
-- Table `family_chronicle`.`people_name`
-- -----------------------------------------------------
DROP TABLE IF EXISTS people_name CASCADE;

CREATE TABLE IF NOT EXISTS people_name (
  id           BIGINT      NOT NULL,
  name         VARCHAR(45) NULL,
  name_type_id BIGINT      NOT NULL,
  people_id    BIGINT      NOT NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_people_name_name_type
  FOREIGN KEY (name_type_id)
  REFERENCES name_type (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_people_name_people
  FOREIGN KEY (people_id)
  REFERENCES people (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_people_name_name_type_idx ON people_name (name_type_id ASC);
CREATE INDEX fk_people_name_people_idx ON people_name (people_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`social_network`
-- -----------------------------------------------------
DROP TABLE IF EXISTS social_network CASCADE;

CREATE TABLE IF NOT EXISTS social_network (
  id          BIGINT        NOT NULL,
  name        VARCHAR(45)   NOT NULL,
  url         VARCHAR(1024) NULL,
  description VARCHAR(1024) NULL,
  PRIMARY KEY (id)
);


-- -----------------------------------------------------
-- Table `family_chronicle`.`relation_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS relation_type CASCADE;

CREATE TABLE IF NOT EXISTS relation_type (
  id   BIGINT      NOT NULL,
  type VARCHAR(45) NULL,
  PRIMARY KEY (id)
);


-- -----------------------------------------------------
-- Table `family_chronicle`.`people_relation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS people_relation CASCADE;

CREATE TABLE IF NOT EXISTS people_relation (
  id               BIGINT NOT NULL,
  relation_type_id BIGINT NOT NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_people_relation_relation_type
  FOREIGN KEY (relation_type_id)
  REFERENCES relation_type (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_people_relation_relation_type_idx ON people_relation (relation_type_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`people_has_people_relation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS people_has_people_relation CASCADE;

CREATE TABLE IF NOT EXISTS people_has_people_relation (
  people_id          BIGINT NOT NULL,
  people_relation_id BIGINT NOT NULL,
  PRIMARY KEY (people_id, people_relation_id)
  ,
  CONSTRAINT fk_people_has_people_relation_people
  FOREIGN KEY (people_id)
  REFERENCES people (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_people_has_people_relation_people_relation
  FOREIGN KEY (people_relation_id)
  REFERENCES people_relation (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_people_has_people_relation_people_relation_idx ON people_has_people_relation (people_relation_id ASC);
CREATE INDEX fk_people_has_people_relation_people_idx ON people_has_people_relation (people_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`chat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS chat CASCADE;

CREATE TABLE IF NOT EXISTS chat (
  id BIGINT NOT NULL,
  PRIMARY KEY (id)
);


-- -----------------------------------------------------
-- Table `family_chronicle`.`message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS message CASCADE;

CREATE TABLE IF NOT EXISTS message (
  id          BIGINT                   NOT NULL,
  text        VARCHAR(1024)            NOT NULL,
  create_date TIMESTAMP WITH TIME ZONE NOT NULL,
  chat_id     BIGINT                   NOT NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_message_chat
  FOREIGN KEY (chat_id)
  REFERENCES chat (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_message_chat_idx ON message (chat_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`people_has_chat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS people_has_chat CASCADE;

CREATE TABLE IF NOT EXISTS people_has_chat (
  people_id BIGINT NOT NULL,
  chat_id   BIGINT NOT NULL,
  PRIMARY KEY (people_id, chat_id)
  ,
  CONSTRAINT fk_people_has_chat_people
  FOREIGN KEY (people_id)
  REFERENCES people (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_people_has_chat_chat
  FOREIGN KEY (chat_id)
  REFERENCES chat (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_people_has_chat_chat_idx ON people_has_chat (chat_id ASC);
CREATE INDEX fk_people_has_chat_people_idx ON people_has_chat (people_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`social_network_has_people`
-- -----------------------------------------------------
DROP TABLE IF EXISTS social_network_has_people CASCADE;

CREATE TABLE IF NOT EXISTS social_network_has_people (
  social_network_id BIGINT NOT NULL,
  people_id         BIGINT NOT NULL,
  PRIMARY KEY (social_network_id, people_id)
  ,
  CONSTRAINT fk_social_network_has_people_social_network
  FOREIGN KEY (social_network_id)
  REFERENCES social_network (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_social_network_has_people_people
  FOREIGN KEY (people_id)
  REFERENCES people (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_social_network_has_people_people_idx ON social_network_has_people (people_id ASC);
CREATE INDEX fk_social_network_has_people_social_network_idx ON social_network_has_people (social_network_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`note`
-- -----------------------------------------------------
DROP TABLE IF EXISTS note CASCADE;

CREATE TABLE IF NOT EXISTS note (
  id          BIGINT                   NOT NULL,
  date_create TIMESTAMP WITH TIME ZONE NOT NULL,
  text        VARCHAR(1024)            NOT NULL,
  people_id   BIGINT                   NOT NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_note_people
  FOREIGN KEY (people_id)
  REFERENCES people (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_note_people_idx ON note (people_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`friend`
-- -----------------------------------------------------
DROP TABLE IF EXISTS friend CASCADE;

CREATE TABLE IF NOT EXISTS friend (
  account_id BIGINT NOT NULL,
  friend_id  BIGINT NOT NULL,
  PRIMARY KEY (account_id, friend_id)
  ,
  CONSTRAINT fk_account_has_account_account
  FOREIGN KEY (account_id)
  REFERENCES account (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_account_has_account_friend
  FOREIGN KEY (friend_id)
  REFERENCES account (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_account_has_account_account_idx ON friend (account_id ASC);
CREATE INDEX fk_account_has_account_friend_idx ON friend (friend_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`attribute`
-- -----------------------------------------------------
DROP TABLE IF EXISTS attribute CASCADE;

CREATE TABLE IF NOT EXISTS attribute (
  id                 BIGINT        NOT NULL,
  name               VARCHAR(45)   NOT NULL,
  description        VARCHAR(1024) NULL,
  attribute_type_id  BIGINT        NOT NULL,
  attribute_list_id  BIGINT        NOT NULL,
  attribute_group_id BIGINT        NOT NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_attribute_attribute_type
  FOREIGN KEY (attribute_type_id)
  REFERENCES attribute_type (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_attribute_attribute_list
  FOREIGN KEY (attribute_list_id)
  REFERENCES attribute_list (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_attribute_attribute_group
  FOREIGN KEY (attribute_group_id)
  REFERENCES attribute_group (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_attribute_attribute_type_idx ON attribute (attribute_type_id ASC);
CREATE INDEX fk_attribute_attribute_list_idx ON attribute (attribute_list_id ASC);
CREATE INDEX fk_attribute_attribute_group_idx ON attribute (attribute_group_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`field_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS field_type CASCADE;

CREATE TABLE IF NOT EXISTS field_type (
  id   BIGINT      NOT NULL,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT field_type_name_UNIQUE UNIQUE (name)
);


-- -----------------------------------------------------
-- Table `family_chronicle`.`attribute_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS attribute_type CASCADE;

CREATE TABLE IF NOT EXISTS attribute_type (
  id            BIGINT        NOT NULL,
  name          VARCHAR(45)   NOT NULL,
  regex         VARCHAR(1024) NULL,
  required      BOOLEAN       NOT NULL DEFAULT FALSE,
  hidden        BOOLEAN       NOT NULL DEFAULT FALSE,
  description   VARCHAR(1024) NULL,
  field_type_id BIGINT        NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT name_UNIQUE UNIQUE (name)
  ,
  CONSTRAINT fk_attribute_type_field_type
  FOREIGN KEY (field_type_id)
  REFERENCES field_type (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_attribute_type_field_type_idx ON attribute_type (field_type_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`attribute_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS attribute_list CASCADE;

CREATE TABLE IF NOT EXISTS attribute_list (
  id          BIGINT        NOT NULL,
  name        VARCHAR(45)   NOT NULL,
  description VARCHAR(1024) NULL,
  PRIMARY KEY (id)
);


-- -----------------------------------------------------
-- Table `family_chronicle`.`attribute_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS attribute_group CASCADE;

CREATE TABLE IF NOT EXISTS attribute_group (
  id          BIGINT        NOT NULL,
  name        VARCHAR(45)   NOT NULL,
  description VARCHAR(1024) NULL,
  PRIMARY KEY (id),
  CONSTRAINT name_UNIQUE UNIQUE (name)
);


-- -----------------------------------------------------
-- Table `family_chronicle`.`attribute`
-- -----------------------------------------------------
DROP TABLE IF EXISTS attribute CASCADE;

CREATE TABLE IF NOT EXISTS attribute (
  id                 BIGINT        NOT NULL,
  name               VARCHAR(45)   NOT NULL,
  description        VARCHAR(1024) NULL,
  attribute_type_id  BIGINT        NOT NULL,
  attribute_list_id  BIGINT        NOT NULL,
  attribute_group_id BIGINT        NOT NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_attribute_attribute_type
  FOREIGN KEY (attribute_type_id)
  REFERENCES attribute_type (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_attribute_attribute_list
  FOREIGN KEY (attribute_list_id)
  REFERENCES attribute_list (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_attribute_attribute_group
  FOREIGN KEY (attribute_group_id)
  REFERENCES attribute_group (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_attribute_attribute_type_idx ON attribute (attribute_type_id ASC);
CREATE INDEX fk_attribute_attribute_list_idx ON attribute (attribute_list_id ASC);
CREATE INDEX fk_attribute_attribute_group_idx ON attribute (attribute_group_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`attribute_list_value`
-- -----------------------------------------------------
DROP TABLE IF EXISTS attribute_list_value CASCADE;

CREATE TABLE IF NOT EXISTS attribute_list_value (
  id                BIGINT       NOT NULL,
  value             VARCHAR(256) NOT NULL,
  attribute_list_id BIGINT       NOT NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_attribute_list_value_attribute_list
  FOREIGN KEY (attribute_list_id)
  REFERENCES attribute_list (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_attribute_list_value_attribute_list_idx ON attribute_list_value (attribute_list_id ASC);


-- -----------------------------------------------------
-- Table `family_chronicle`.`attribute_value`
-- -----------------------------------------------------
DROP TABLE IF EXISTS attribute_value CASCADE;

CREATE TABLE IF NOT EXISTS attribute_value (
  id                      BIGINT                   NOT NULL,
  text_value              VARCHAR(1024)            NULL,
  date_value              TIMESTAMP WITH TIME ZONE NULL,
  blob_value              BYTEA                    NULL,
  attribute_list_value_id BIGINT                   NOT NULL,
  people_id               BIGINT                   NOT NULL,
  attribute_id            BIGINT                   NOT NULL,
  PRIMARY KEY (id)
  ,
  CONSTRAINT fk_attribute_value_people
  FOREIGN KEY (people_id)
  REFERENCES people (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_attribute_value_attribute
  FOREIGN KEY (attribute_id)
  REFERENCES attribute (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  CONSTRAINT fk_attribute_value_attribute_list_value
  FOREIGN KEY (attribute_list_value_id)
  REFERENCES attribute_list_value (id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
);

CREATE INDEX fk_attribute_value_people_idx ON attribute_value (people_id ASC);
CREATE INDEX fk_attribute_value_attribute_idx ON attribute_value (attribute_id ASC);
CREATE INDEX fk_attribute_value_attribute_list_value_idx ON attribute_value (attribute_list_value_id ASC);

-- Active: 1718478478258@@127.0.0.1@5432@gym_02

CREATE DATABASE GYM;

GRANT CONNECT ON DATABASE GYM TO gym_admin, gym_user;
GRANT CREATE ON DATABASE GYM TO gym_admin;

GRANT USAGE ON SCHEMA public TO gym_admin, gym_user;
GRANT CREATE ON SCHEMA public TO gym_admin;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO gym_admin

CREATE TABLE "Member" (
  "id" serial PRIMARY KEY,
  "name" varchar,
  "surname" varchar,
  "phone" varchar
);

CREATE TABLE "Trainer" (
  "id" serial PRIMARY KEY,
  "name" varchar,
  "surname" varchar,
  "phone" varchar
);

CREATE TABLE "Training" (
  "id" serial PRIMARY KEY,
  "membership_id" int,
  "trainer_id" int,
  "date" date,
  "time" time
);

CREATE TABLE "Membership" (
  "id" serial PRIMARY KEY,
  "member_id" int,
  "service_id" int,
  "start_date" date,
  "end_date" date
);

CREATE TABLE "Service" (
  "id" serial PRIMARY KEY,
  "name" varchar,
  "price" integer
);

ALTER TABLE "Training" ADD FOREIGN KEY ("membership_id") REFERENCES "Membership" ("id");

ALTER TABLE "Training" ADD FOREIGN KEY ("trainer_id") REFERENCES "Trainer" ("id");

ALTER TABLE "Membership" ADD FOREIGN KEY ("member_id") REFERENCES "Member" ("id");

ALTER TABLE "Membership" ADD FOREIGN KEY ("service_id") REFERENCES "Service" ("id");

CREATE SEQUENCE member_id_seq;
DROP SEQUENCE member_id_seq;
ALTER TABLE "Member" ALTER COLUMN id SET DEFAULT nextval('member_id_seq');

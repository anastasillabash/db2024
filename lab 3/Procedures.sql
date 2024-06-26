-- Active: 1718478478258@@127.0.0.1@5432@gym_new@public
CREATE OR REPLACE PROCEDURE add_member(
    p_name VARCHAR,
    p_surname VARCHAR,
    p_phone VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN 
INSERT INTO "Member" (name, surname, phone) 
VALUES (p_name, p_surname, p_phone);
END;
$$;


CREATE OR REPLACE PROCEDURE add_trainer(
    p_name VARCHAR,
    p_surname VARCHAR,
    p_phone VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN 
INSERT INTO "Trainer" (name, surname, phone) 
VALUES (p_name, p_surname, p_phone);
END;
$$;


CREATE OR REPLACE PROCEDURE add_service (
    p_name VARCHAR,
    p_price DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN 
INSERT INTO "Service" (name, price) 
VALUES (p_name, p_price);
END;
$$;



CREATE OR REPLACE PROCEDURE update_phonenumber_member(
    p_name VARCHAR,
    p_surname VARCHAR,
    p_phone VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN 
UPDATE "Member" SET phone = p_phone
WHERE name = p_name AND surname = p_surname;
END;
$$;


CREATE OR REPLACE PROCEDURE update_service_price(
    p_name VARCHAR,
    p_price DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN 
UPDATE "Service" SET price = p_price
WHERE name = p_name;
END;
$$;


CREATE OR REPLACE PROCEDURE delete_service(
    p_name VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN 
DELETE FROM "Service" WHERE name = p_name;
END;
$$;
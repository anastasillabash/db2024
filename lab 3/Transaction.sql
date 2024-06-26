-- транзакція для додавання нового клієнта та оформлення його абонементу
BEGIN;
INSERT INTO "Member" (name, surname, phone)
VALUES ('Liza', 'Kenedy', '000 000 0000');
INSERT INTO "Membership" (member_id, service_id, start_date, end_date) VALUES (454, 3, '25/12/2023', '15/12/2024');
COMMIT;

-- транзакція для оновлення номеру телефону клієнта за id
BEGIN;
UPDATE "Member"
SET phone = '987 654 3266'
WHERE id = 454;
COMMIT;

-- транзакція для видалення тренування за id
BEGIN;
DELETE FROM "Training" WHERE id = 98;
COMMIT;
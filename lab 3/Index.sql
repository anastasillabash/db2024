-- Active: 1718478478258@@127.0.0.1@5432@gym_new@public
-- index
CREATE INDEX idx_member_name_surname ON "Member" (name, surname);

SELECT id, name, surname, phone
FROM "Member"
WHERE name = 'John' AND surname = 'Doe';

CREATE INDEX idx_training_date ON "Training" (date);

SELECT id, date, time, trainer_id
FROM "Training"
WHERE date BETWEEN '2024-01-01' AND '2024-01-31';


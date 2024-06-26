-- Active: 1718478478258@@127.0.0.1@5432@gym_new@public
CREATE OR REPLACE FUNCTION avg_duration(member_id INTEGER)
RETURNS DECIMAL
LANGUAGE plpgsql
AS $$
DECLARE
    total_duration INTERVAL;
    avg_duration DECIMAL;
    training_count INTEGER;
BEGIN
    -- отримати загальну тривалість тренувань та кількість тренувань для даного клієнта
    SELECT SUM(t.duration), COUNT(*)
    INTO total_duration, training_count
    FROM "Training" t
    JOIN "Membership" m ON t.membership_id = m.id
    WHERE m.member_id = avg_duration.member_id;

    -- якщо тренувань немає, повернути 0
    IF training_count = 0 THEN
        RETURN 0;
    END IF;

    -- розрахувати
    avg_duration := EXTRACT(EPOCH FROM total_duration) / training_count;

    RETURN avg_duration;
END;
$$;


-- перевірка
SELECT avg_duration(193);

CREATE OR REPLACE FUNCTION ms_by_service(service_name VARCHAR)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    count INTEGER;
BEGIN
    SELECT COUNT(*) INTO count
    FROM "Membership" m
    JOIN "Service" s ON m.service_id = s.id
    WHERE s.name = ms_by_service.service_name;

    RETURN count;
END;
$$;

-- перевірка
SELECT ms_by_service('Platinum');
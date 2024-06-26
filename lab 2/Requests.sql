-- Active: 1718478478258@@127.0.0.1@5432@gym_new@public
--1. усі записи про тренерів
SELECT *
FROM "Trainer";

-- 2. повертає стовпець name таблиці Member
SELECT name
From "Member";

--3. повертає імя та призвіща 5 тренерів
SELECT name as "Ім'я", surname as "Призвіще"
FROM "Trainer"
LIMIT (5);

-- 4. повертає абонементи, ціна яких нижча за 720 доларів
SELECT name as "Абонемент", price as "Ціна за рік"
From "Service"
WHERE price < 750;

-- 5. повертає усю інформацію тих членів клубу, у кого вони починаються на літеру J
SELECT *
from "Member"
where surname like 'J%';

-- 6. повертає усю інформацію тих членів клубу, у кого вони починаються на літеру J
SELECT *
from "Member"
where surname like 'C%e';

-- 7. повертає інформацію про тих членів клубу, номер яких закінчується на 13
SELECT *
from "Member"
where phone like '%13'

-- 8. 20 перших зареєстрованих абонементів
SELECT ms.id, name, surname, start_date, end_date
FROM "Membership" ms
JOIN "Member" as m on m.id = member_id 
ORDER BY ms.id ASC
LIMIT (20);

-- 9. Список клієнтів і чи оформлені у них абонементи
SELECT m.id,name, surname, ms.id
FROM "Membership" ms
RIGHT JOIN "Member" as m on m.id = member_id;

-- 10. Клієнти, що тренувались з 1 лютого то 1 червня
SELECT member.name, member.surname, training.date, training.time, trainer.name, trainer.surname
From "Training" as training
join "Membership"as membership on membership.id = membership_id
JOIN "Member" as member on member.id = membership.member_id
join "Trainer" as trainer on trainer.id = training.trainer_id
Where date BETWEEN '2024-02-01' AND '2024-06-01';

-- 11. Клієнти, що тренувались з 1 лютого то 1 червня у тренера Noam
SELECT member.name, member.surname, training.date, training.time, trainer.name, trainer.surname
From "Training" as training
join "Membership"as membership on membership.id = membership_id
JOIN "Member" as member on member.id = membership.member_id
join "Trainer" as trainer on trainer.id = training.trainer_id
Where date BETWEEN '2024-02-01' AND '2024-06-01'
AND trainer.name like 'Noam';

-- 12. Клієнти, що тренувались з 1 лютого то 1 березня після 14:00
SELECT member.name, member.surname, training.date, training.time, trainer.name, trainer.surname
From "Training" as training
join "Membership"as membership on membership.id = membership_id
JOIN "Member" as member on member.id = membership.member_id
join "Trainer" as trainer on trainer.id = training.trainer_id
Where date BETWEEN '2024-02-01' AND '2024-03-01'
AND EXTRACT(HOUR From time) >= 14;

-- 13. Клієнти, що тренувались 1 лютого в порядку їх тренувань
SELECT member.name, member.surname, training.date, training.time
From "Training" as training
join "Membership"as membership on membership.id = membership_id
JOIN "Member" as member on member.id = membership.member_id
Where date = '2024-02-01'
ORDER BY time ASC;

--14. Клієнти, що тренувались за абонементами "Basic" 
SELECT DISTINCT membership_id, member.id, member.name, member.surname, service.name, COUNT(training.id) AS training_count
From "Training" as training
join "Membership"as membership on membership.id = membership_id
JOIN "Member" as member on member.id = membership.member_id
join "Trainer" as trainer on trainer.id = training.trainer_id
join "Service" as service on service.id = membership.service_id
where service.name like 'Basic'
GROUP BY membership_id, member.id, member.name, member.surname, service.name;

--15. Кількість тренувань, проведена за абонементом Basic
SELECT service.name AS service_name, COUNT(training.id) AS total_trainings
FROM "Training" as training
JOIN "Membership" as membership ON membership.id = training.membership_id
JOIN "Service" as service ON service.id = membership.service_id
WHERE service.name LIKE 'Basic'
GROUP BY service.name;

-- 16. Сума, що витратили клієнти на абонементи 
SELECT sum(service.price)
FROM "Membership" as membership
JOIN "Service" as service on service.id = membership.service_id;

-- 17. Суми,що витратили клієнти на абонементи розбиті по типам абонементів
SELECT service.name, sum(service.price)
FROM "Membership" as membership
JOIN "Service" as service on service.id = membership.service_id
GROUP BY service.name;

-- 18. Скільки людей займаються у тренерки Rozina
SELECT COUNT(DISTINCT m.id)
from "Training" t
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Member" m ON membership.member_id = m.id
JOIN "Trainer" tr ON t.trainer_id = tr.id
where tr.name =  'Rozina';

--19. Клієнти, що займаються у тренерки Karee
SELECT DISTINCT m.id, m.name, m.surname, tr.name
from "Training" t
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Member" m ON membership.member_id = m.id
JOIN "Trainer" tr ON t.trainer_id = tr.id
where tr.name =  'Karee';

-- 20. Тренування, що провела Karee у березні
SELECT m.name, m.surname, t.date, t.time, s.name 
FROM "Training" t
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Member" m ON membership.member_id = m.id
JOIN "Trainer" tr ON t.trainer_id = tr.id
JOIN "Service" s ON membership.service_id = s.id
WHERE tr.name = 'Karee'
AND t.date BETWEEN '2024-03-01' AND '2024-03-31';

-- 21.  Скільки тренувань провели кожен тренер у спадаючому порядку
SELECT tr.name, tr.surname, COUNT(*) as amount
FROM "Training" t
JOIN "Trainer" tr ON t.trainer_id = tr.id
GROUP BY tr.name, tr.surname
ORDER BY amount DESC;

-- 22. Хто з клієнтів найбільше тренувався
SELECT m.name AS member_name, COUNT(*) AS amount
FROM "Training" t
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Member" m ON membership.member_id = m.id
GROUP BY m.name
ORDER BY amount DESC
LIMIT 1;

-- 23. Хто займався більше 20 разів
SELECT m.name, COUNT(*) AS total
FROM"Training" t
JOIN"Membership" membership ON t.membership_id = membership.id
JOIN "Member" m ON membership.member_id = m.id
GROUP BY m.name
HAVING COUNT(*) > 20
ORDER BY total ASC;

-- 24. Кількість тренувань за вказаний період часу
SELECT COUNT(*) AS total_trainings
FROM "Training"
WHERE date BETWEEN '2024-04-01' AND '2024-04-30';

-- 25. Клієнти, які не мали жодного тренування
SELECT m.name, m.surname
FROM "Member" m
LEFT JOIN "Membership" membership ON m.id = membership.member_id
LEFT JOIN "Training" t ON membership.id = t.membership_id
WHERE t.id IS NULL;

-- 26. Яку кількість тренувань відвідали з яким абонементом
SELECT s.name, COUNT(*) AS total
FROM "Training" t
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Member" m ON membership.member_id = m.id
JOIN "Service"s on s.id = membership.service_id
GROUP BY s.name;

-- 27. На які цифри з якою частотою починаються номери клієнтів
SELECT LEFT(phone, 1) AS first_digit, COUNT(*) AS frequency
FROM "Member"
GROUP BY LEFT(phone, 1) 
ORDER BY frequency DESC

--28. На які три цифри з якою частотою закінчуються номера клієнтів
SELECT RIGHT(phone, 3) AS last_three_digits, COUNT(*) AS frequency
FROM "Member"
GROUP BY last_three_digits
ORDER BY frequency DESC;

-- 29. Хто з тренерів провів менше 250 тренувань
SELECT tr.name, COUNT(*) AS total
FROM "Training" t
JOIN "Trainer" tr ON t.trainer_id = tr.id
GROUP BY tr.name
HAVING COUNT(*) < 250
ORDER BY total ASC;

--30. Яку кількість тренувань відвідати з яким абонементом з 1 березня по 25 квітня
SELECT s.name, COUNT(*) AS total
FROM "Training" t
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Service"s on s.id = membership.service_id
WHERE t.date BETWEEN '2024-03-01' AND '2024-04-25'
GROUP BY s.name
ORDER BY total DESC;

-- 31. Хто коли тренувався
SELECT m.name, m.surname, date, time
FROM "Training" t
JOIN "Membership"ms on ms.id = t.membership_id
JOIN "Member" m on m.id = ms.member_id
ORDER BY date, time;

-- 32. Повертає ціни абонементів
SELECT name, price
FROM "Service"
ORDER BY price ASC;

-- 33. На яку букву найчастіше починається призвіща тренерів
SELECT LEFT(surname, 1) AS first_letter, COUNT(*) AS frequency
FROM "Trainer"
GROUP BY LEFT(surname, 1)
ORDER BY frequency DESC
LIMIT (2);

-- 34. Розбиті по місяцях кількість тренувань
SELECT
    TO_CHAR(t.date, 'YYYY-MM') AS month, COUNT(*) AS total
FROM "Training" t
GROUP BY TO_CHAR(t.date, 'YYYY-MM')
ORDER BY month;

-- 35. Місяць з найменшою кількістю тренувань
SELECT EXTRACT(MONTH FROM date) AS month_number,
       COUNT(*) AS training_count
FROM "Training"
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY training_count ASC
LIMIT 1;

-- 36. Кількість тренувань по роках
SELECT EXTRACT(YEAR FROM date) AS year_number, COUNT(*) AS training_count
FROM "Training"
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY year_number;

-- 37. Клієнти з найбільшою кількістю тренувань
SELECT m.id, m.name, m.surname, COUNT(t.id) AS training_count
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Training" t ON membership.id = t.membership_id
GROUP BY m.id
ORDER BY training_count DESC
LIMIT 10;

-- 38. Кількість тренувань за кожним місяцем для кожного тренера
SELECT tr.name AS trainer_name,
       EXTRACT(MONTH FROM t.date) AS month_number,
       COUNT(*) AS training_count
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
GROUP BY tr.id, month_number
ORDER BY trainer_name, month_number;

--39. Кількість тренувань за кожний день тижня
SELECT EXTRACT(DOW FROM date) AS day_of_week,
       COUNT(*) AS training_count
FROM "Training"
GROUP BY EXTRACT(DOW FROM date)
ORDER BY day_of_week;

-- 40. Кількість тренувань на клієнта за місяць
SELECT m.name, m.surname,
       EXTRACT(MONTH FROM t.date) AS month_number,
       COUNT(*) AS trainings_per_month
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Training" t ON membership.id = t.membership_id
GROUP BY m.id, month_number
ORDER BY m.surname, m.name, month_number;

-- 41. День з найбільшою кількістю тренувань
SELECT date,
       COUNT(*) AS training_count
FROM "Training"
GROUP BY date
ORDER BY training_count DESC
LIMIT 1;

-- 42.Порівняння кількості тренувань у будні та у вихідні дні
SELECT CASE WHEN EXTRACT(ISODOW FROM date) IN (6, 7) THEN 'Weekend'
            ELSE 'Weekday'
       END AS day_type,
       COUNT(*) AS training_count
FROM "Training"
GROUP BY day_type
ORDER BY day_type;

-- 43. Кількість тренувань за кожним годинним інтервалом
SELECT EXTRACT(HOUR FROM time) AS hour_of_day,
       COUNT(*) AS training_count
FROM "Training"
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 44. Тренери з найменшою кількістю тренувань
SELECT tr.name AS trainer_name,
       COUNT(*) AS training_count
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
GROUP BY tr.id
ORDER BY training_count ASC
LIMIT (3);

-- 45. Кількість тренувань за кожен місяць для кожного типу абонементу
SELECT s.name AS service_name,
       EXTRACT(MONTH FROM t.date) AS month_number,
       COUNT(*) AS training_count
FROM "Training" t
JOIN "Membership" m ON t.membership_id = m.id
JOIN "Service" s ON m.service_id = s.id
GROUP BY s.name, month_number
ORDER BY s.name, month_number;

-- 46. Клієнти з найбільшим і найменшим інтервалом між тренуваннями
WITH member_training_intervals AS (
    SELECT m.id,
           MIN(t.date) AS first_training_date,
           MAX(t.date) AS last_training_date,
           MAX(t.date) - MIN(t.date) AS interval_days
    FROM "Member" m
    JOIN "Membership" membership ON m.id = membership.member_id
    JOIN "Training" t ON membership.id = t.membership_id
    GROUP BY m.id
    HAVING COUNT(*) >= 2
)
SELECT m.name, m.surname,
       first_training_date,
       last_training_date,
       interval_days
FROM "Member" m
JOIN member_training_intervals mti ON m.id = mti.id
WHERE interval_days = (SELECT MAX(interval_days) FROM member_training_intervals)
   OR interval_days = (SELECT MIN(interval_days) FROM member_training_intervals);

-- 47. Кількість клієнтів за кожним тренером 
SELECT tr.name AS trainer_name,
       COUNT(DISTINCT m.id) AS client_count
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Member" m ON membership.member_id = m.id
GROUP BY trainer_name
ORDER BY client_count DESC;

-- 48. Перелік клієнтів, які не відвідували тренування протягом останнього місяця
SELECT m.name, m.surname
FROM "Member" m
WHERE m.id NOT IN (
    SELECT DISTINCT m.id
    FROM "Member" m
    JOIN "Membership" membership ON m.id = membership.member_id
    JOIN "Training" t ON membership.id = t.membership_id
    WHERE EXTRACT(MONTH FROM t.date) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month')
);

-- 49. Кількість тренувань у кожен день тижня
SELECT EXTRACT(ISODOW FROM t.date) AS day_of_week,
       COUNT(*) AS training_count
FROM "Training" t
GROUP BY day_of_week
ORDER BY day_of_week;

-- 50. Кількість тренувань за кожен тип абонементу
SELECT s.name AS service_name,
       COUNT(*) AS training_count
FROM "Training" t
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Service" s ON membership.service_id = s.id
GROUP BY service_name
ORDER BY training_count DESC;

-- 51. Середня тривалість тренування за кожним тренером 
SELECT tr.name AS trainer_name,
       AVG(t.duration) AS average_duration
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
GROUP BY trainer_name
ORDER BY average_duration DESC;

--52. Кількість тренувань за кожен місяць з врахуванням тривалості тренувань
SELECT EXTRACT(MONTH FROM date) AS month_number,
       COUNT(*) AS training_count,
       AVG(duration) AS average_duration
FROM "Training"
GROUP BY month_number
ORDER BY month_number;

--53. Тренери з найбільшою середньою тривалістю тренувань
SELECT tr.name AS trainer_name,
       AVG(t.duration) AS average_duration
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
GROUP BY trainer_name
ORDER BY average_duration DESC
LIMIT 5;

-- 54. Середня тривалість тренувань у різні дні тижня
SELECT EXTRACT(ISODOW FROM date) AS day_of_week,
       AVG(duration) AS average_duration
FROM "Training"
GROUP BY day_of_week
ORDER BY day_of_week;

-- 55. Кількість тренувань залежно від їх тривалості
SELECT CASE
           WHEN duration <= 0.5 THEN '0-30 min'
           WHEN duration <= 1 THEN '31-60 min'
           WHEN duration <= 1.5 THEN '61-90 min'
           ELSE 'Over 90 min'
       END AS duration_range,
       COUNT(*) AS training_count
FROM "Training"
GROUP BY duration_range
ORDER BY duration_range;

-- 56. Клієнти з найбільшою і найменшою середньою тривалістю тренувань
WITH avg_training_duration AS (
    SELECT m.id,
           AVG(t.duration) AS average_duration
    FROM "Member" m
    JOIN "Membership" membership ON m.id = membership.member_id
    JOIN "Training" t ON membership.id = t.membership_id
    GROUP BY m.id
)
SELECT m.name, m.surname, atd.average_duration
FROM "Member" m
JOIN avg_training_duration atd ON m.id = atd.id
WHERE atd.average_duration = (SELECT MAX(average_duration) FROM avg_training_duration)
   OR atd.average_duration = (SELECT MIN(average_duration) FROM avg_training_duration);

-- 57. Середня тривалість тренувань за кожним типом абонементу
SELECT s.name AS service_name,
       AVG(t.duration) AS average_duration
FROM "Service" s
JOIN "Membership" membership ON s.id = membership.service_id
JOIN "Training" t ON membership.id = t.membership_id
GROUP BY service_name
ORDER BY service_name;

-- 58. Кількість тренувань в залежності від дня місяця
SELECT EXTRACT(DAY FROM date) AS day_of_month,
       COUNT(*) AS training_count
FROM "Training"
GROUP BY day_of_month
ORDER BY day_of_month;

--59. Кількість тренувань за кожен тип абонементу в
SELECT s.name AS service_name,
       COUNT(*) AS training_count
FROM "Service" s
JOIN "Membership" membership ON s.id = membership.service_id
JOIN "Training" t ON membership.id = t.membership_id
WHERE EXTRACT(MONTH FROM t.date) = 6 
GROUP BY service_name
ORDER BY service_name;

-- 60. Кількість тренувань за кожен тренером за останній місяць
SELECT tr.name AS trainer_name,
       COUNT(*) AS training_count
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
WHERE DATE_TRUNC('month', t.date) = DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
GROUP BY trainer_name
ORDER BY training_count DESC;

-- 61. Кількість тренувань залежно від години початку тренування
SELECT CASE
           WHEN EXTRACT(HOUR FROM time) >= 5 AND EXTRACT(HOUR FROM time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM time) >= 12 AND EXTRACT(HOUR FROM time) < 17 THEN 'Afternoon'
           WHEN EXTRACT(HOUR FROM time) >= 17 AND EXTRACT(HOUR FROM time) < 21 THEN 'Evening'
           ELSE 'Night'
       END AS time_of_day,
       COUNT(*) AS training_count
FROM "Training"
GROUP BY time_of_day
ORDER BY time_of_day;

--62. Кількість тренувань за кожним місяцем для вибраного тренера
SELECT tr.name AS trainer_name,
       EXTRACT(MONTH FROM t.date) AS month_number,
       COUNT(*) AS training_count
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
WHERE tr.name = 'Karee'
GROUP BY trainer_name, month_number
ORDER BY month_number;

--63. Кількість тренувань за кожним тренером у вибраний день тижня
SELECT tr.name AS trainer_name,
       EXTRACT(ISODOW FROM t.date) AS day_of_week,
       COUNT(*) AS training_count
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
WHERE t.date BETWEEN '2024-01-01' AND '2024-06-01' and EXTRACT(ISODOW FROM t.date) = 1
GROUP BY trainer_name, day_of_week
ORDER BY trainer_name, day_of_week;

-- 64.  Перелік клієнтів, які мають тренування в вихідні
SELECT DISTINCT m.name, m.surname
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Training" t ON membership.id = t.membership_id
WHERE EXTRACT(ISODOW FROM t.date) IN (6, 7); 

--65. Кількість тренувань залежно від дня місяця для вибраного клієнта
SELECT m.name AS client_name,
       EXTRACT(DAY FROM t.date) AS day_of_month,
       COUNT(*) AS training_count
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Training" t ON membership.id = t.membership_id
WHERE m.name = 'Adriane'
GROUP BY client_name, day_of_month
ORDER BY day_of_month;

--66. Кількість тренувань залежно від тренера для вибраного клієнта
SELECT tr.name AS trainer_name,
       COUNT(t.id) AS training_count
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Member" m ON membership.member_id = m.id
WHERE m.name = 'Adriane'
GROUP BY trainer_name
ORDER BY training_count DESC;

-- 67. Cередня тривалість тренування для кожного клієнта
SELECT m.name AS name, m.surname AS surname, AVG(t.duration) AS average_duration, membership.id 
FROM "Member" m
LEFT JOIN "Membership" membership ON m.id = membership.member_id
LEFT JOIN "Training" t ON membership.id = t.membership_id
GROUP BY m.name, m.surname, membership.id 
ORDER BY average_duration DESC;

-- 68. Найдовші тренування за тривалістю
SELECT tr.name AS trainer_name, m.name AS client_name, m.surname AS client_surname,
       t.date, t.time, t.duration
FROM "Training" t
JOIN "Trainer" tr ON t.trainer_id = tr.id
JOIN "Membership" membership ON t.membership_id = membership.id
JOIN "Member" m ON membership.member_id = m.id
ORDER BY t.duration DESC
LIMIT 10;

-- 69. Кількість тренувань за кожним клієнтом у вихідні дні
SELECT m.name AS client_name, m.surname AS client_surname,
       COUNT(*) AS weekend_training_count
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Training" t ON membership.id = t.membership_id
WHERE EXTRACT(ISODOW FROM t.date) IN (6, 7)
GROUP BY client_name, client_surname
ORDER BY weekend_training_count DESC

-- 70. Тренування за кожним клієнтом, які проходили понад 2 години
SELECT m.name AS client_name, m.surname AS client_surname, t.date, t.time, t.duration
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Training" t ON membership.id = t.membership_id
WHERE t.duration > 2
ORDER BY client_name, client_surname, t.date;

-- 71. Найбільш зайняті дні для тренерів
SELECT tr.name AS trainer_name, t.date, COUNT(*) AS training_count
FROM "Trainer" tr
JOIN "Training" t ON tr.id = t.trainer_id
GROUP BY trainer_name, t.date
ORDER BY training_count DESC
LIMIT 10;

-- 72. Кількість тренувань кожного клієнта по дням тижня
SELECT m.name AS name, m.surname AS surname,
       SUM(CASE WHEN EXTRACT(ISODOW FROM t.date) = 1 THEN 1 ELSE 0 END) AS monday,
       SUM(CASE WHEN EXTRACT(ISODOW FROM t.date) = 2 THEN 1 ELSE 0 END) AS tuesday,
       SUM(CASE WHEN EXTRACT(ISODOW FROM t.date) = 3 THEN 1 ELSE 0 END) AS wednesday,
       SUM(CASE WHEN EXTRACT(ISODOW FROM t.date) = 4 THEN 1 ELSE 0 END) AS thursday,
       SUM(CASE WHEN EXTRACT(ISODOW FROM t.date) = 5 THEN 1 ELSE 0 END) AS friday,
       SUM(CASE WHEN EXTRACT(ISODOW FROM t.date) = 6 THEN 1 ELSE 0 END) AS saturday,
       SUM(CASE WHEN EXTRACT(ISODOW FROM t.date) = 7 THEN 1 ELSE 0 END) AS sunday
FROM "Member" m
LEFT JOIN "Membership" membership ON m.id = membership.member_id
LEFT JOIN "Training" t ON membership.id = t.membership_id
GROUP BY m.name, m.surname
ORDER BY name, surname;

-- 73. Клієнти, які тренувались більше 10 разів за останні 3 місяці
SELECT m.name AS client_name, m.surname AS client_surname,
       COUNT(t.id) AS training_count
FROM "Member" m
LEFT JOIN "Membership" membership ON m.id = membership.member_id
LEFT JOIN "Training" t ON membership.id = t.membership_id
WHERE t.date >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY m.name, m.surname
HAVING COUNT(t.id) > 10
ORDER BY training_count DESC;

--74. Тривалість тренувань за кожним тренером для кожного клієнта
SELECT m.name AS name, m.surname AS surname, tr.name AS trainer_name,
       SUM(t.duration) AS total
FROM "Member" m
LEFT JOIN "Membership" membership ON m.id = membership.member_id
LEFT JOIN "Training" t ON membership.id = t.membership_id
LEFT JOIN "Trainer" tr ON t.trainer_id = tr.id
GROUP BY m.name, m.surname, tr.name
ORDER BY name, surname, total DESC;

--75. Середня тривалість тренувань для кожного тренера
SELECT tr.name AS trainer_name,
       AVG(t.duration) AS average_duration
FROM "Trainer" tr
LEFT JOIN "Training" t ON tr.id = t.trainer_id
GROUP BY tr.name
ORDER BY average_duration DESC;

-- 76. Клієнти з найбільшою кількістю тренувань у будні дні
SELECT m.name AS name, m.surname AS surname,
       COUNT(t.id) AS total
FROM "Member" m
LEFT JOIN "Membership" membership ON m.id = membership.member_id
LEFT JOIN "Training" t ON membership.id = t.membership_id
WHERE EXTRACT(ISODOW FROM t.date) BETWEEN 1 AND 5
GROUP BY m.name, m.surname
ORDER BY total DESC;

-- 77. Середня тривалість тренувань у будні дні для кожного клієнта
SELECT m.name, m.surname,
       AVG(t.duration) AS average_duration
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Training" t ON membership.id = t.membership_id
WHERE EXTRACT(ISODOW FROM t.date) BETWEEN 1 AND 5
GROUP BY m.name, m.surname
ORDER BY average_duration DESC;

-- 78. Середня тривалість тренувань у вихідні дні для кожного клієнта
SELECT m.name, m.surname,
       AVG(t.duration) AS average_duration
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Training" t ON membership.id = t.membership_id
WHERE EXTRACT(ISODOW FROM t.date) IN (6, 7)
GROUP BY m.name, m.surname
ORDER BY average_duration DESC;

-- 80.
SELECT m.name, m.surname, s.name AS service
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Service" s ON s.id = membership.service_id;

-- 81.
SELECT m.name, m.surname, s.name AS service
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Service" s ON s.id = membership.service_id
ORDER BY m.name ASC;

-- 82.
SELECT m.name, m.surname, s.name AS service, s.price
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Service" s ON s.id = membership.service_id
ORDER BY s.price ASC;

-- 83.
SELECT m.name, m.surname, s.name AS service, s.price
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Service" s ON s.id = membership.service_id
ORDER BY s.price ASC;

-- 84. 
SELECT m.name, m.surname, s.name AS service, s.price
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Service" s ON s.id = membership.service_id
ORDER BY s.price DESC;

-- 85.
SELECT m.name, m.surname, s.name AS service, s.price
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Service" s ON s.id = membership.service_id
ORDER BY s.price DESC
LIMIT 5;

-- 86. 
SELECT m.name, m.surname, s.name AS service, s.price,  tr.name AS trainer_name
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Service" s ON s.id = membership.service_id
JOIN "Training" t ON membership.id = t.membership_id
JOIN "Trainer" tr ON t.trainer_id = tr.id
ORDER BY s.price DESC;

-- 87.
SELECT m.name, m.surname, s.name AS service, s.price, tr.name AS trainer_name
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Service" s ON s.id = membership.service_id
JOIN "Training" t ON membership.id = t.membership_id
JOIN "Trainer" tr ON t.trainer_id = tr.id
WHERE tr.name LIKE 'N%'
ORDER BY s.price DESC;

-- 88.
SELECT m.name, m.surname, s.name AS service, s.price, tr.name AS trainer_name
FROM "Member" m
JOIN "Membership" membership ON m.id = membership.member_id
JOIN "Service" s ON s.id = membership.service_id
JOIN "Training" t ON membership.id = t.membership_id
JOIN "Trainer" tr ON t.trainer_id = tr.id
WHERE m.name LIKE 'K%'
ORDER BY s.price DESC;

SELECT * FROM "Training"
WHERE membership_id IN (SELECT id FROM "Membership" WHERE member_id = 1);

-- 90. Знайти всі абонементи, що закінчуються в певний період
SELECT * FROM "Membership"
WHERE end_date BETWEEN '2024-12-20' AND '2024-12-31';

--91. Знайти всіх членів клубу, що мають активні абонементи 
SELECT * FROM "Member" m
JOIN "Membership" ms ON m.id = ms.member_id
WHERE ms.end_date > CURRENT_DATE;

--92. Знайти середню тривалість всіх тренувань
SELECT AVG(duration) AS avg_duration
FROM "Training";

--93. Знайти всіх членів клубу, що мають більше одного абонементу
SELECT m.id, m.name, m.surname, COUNT(ms.id) AS membership_count
FROM "Member" m
JOIN "Membership" ms ON m.id = ms.member_id
GROUP BY m.id, m.name, m.surname
HAVING COUNT(ms.id) > 1;

-- 94. Знайти всіх членів клубу, що мають прізвище на певну літеру
SELECT * FROM "Member"
WHERE surname LIKE 'A%'; -- Замість 'A%' підставте потрібну літеру

-- 95. Знайти всіх тренерів, які проводили тренування у певний день
SELECT DISTINCT t.trainer_id, tr.name
FROM "Training" t
JOIN "Trainer" tr on t.trainer_id = tr.id
WHERE t.date = '2024-06-15';

-- 96. Знайти загальну тривалість тренувань для кожного члена клубу
SELECT m.id, m.name, m.surname, SUM(t.duration) AS total_duration
FROM "Member" m
JOIN "Membership" ms ON m.id = ms.member_id
JOIN "Training" t ON ms.id = t.membership_id
GROUP BY m.id, m.name, m.surname;

-- 97. Знайти всі тренування, що починаються в певний час доби
SELECT * FROM "Training"
WHERE EXTRACT(HOUR FROM time) = 9;

--98.  Знайти всіх членів клубу, що зареєструвалися в певний день тижня
SELECT * 
FROM "Membership" mr
JOIN "Member" m ON mr.member_id = m.id
WHERE EXTRACT(DOW FROM mr.start_date) = 5;

--99. Знайти всіх членів, які відвідують тренування на вихідних
SELECT DISTINCT m.* 
FROM "Member" m
JOIN "Membership" mr ON m.id = mr.member_id
JOIN "Training" t ON mr.id = t.membership_id
WHERE EXTRACT(DOW FROM t.date) IN (7, 6);

-- 100. Знайти всіх членів, які не мають жодного активного абонементу
SELECT * FROM "Member" m
WHERE NOT EXISTS (
    SELECT 1 FROM "Membership" mr
    WHERE mr.member_id = m.id
);

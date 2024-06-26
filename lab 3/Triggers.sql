-- Active: 1718478478258@@127.0.0.1@5432@gym_new@public
-- тригер на видалення абонементу після видалення члена клубу
CREATE OR REPLACE FUNCTION delete_related_member()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM "Membership"
    WHERE member_id = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_delete_related_member
AFTER DELETE ON "Member"
FOR EACH ROW
EXECUTE FUNCTION delete_related_member();

CALL add_member ('Asino', 'Casper', '678 000 3498');
INSERT INTO "Membership" (member_id, service_id, start_date, end_date) VALUES (453, 4, '1/12/2023', '22/12/2024');

DELETE FROM "Member" WHERE id = 453;
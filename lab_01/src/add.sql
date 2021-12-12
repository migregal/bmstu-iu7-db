\dbcourse

CREATE OR REPLACE FUNCTION change_user_carma()
RETURNS TRIGGER
AS $$
BEGIN
    UPDATE users
    SET carma = (carma) + (NEW.shop_rating - 5) / 10
    WHERE id = NEW.reviewer_id;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
CREATE TRIGGER review_suggestion AFTER INSERT ON reviews
FOR ROW EXECUTE PROCEDURE change_user_carma();

INSERT INTO reviews (shop_id, good_id, employee_id, reviewer_id, good_rating, shop_rating, employee_rating)
VALUES (
    '001c4a08-ec9a-42a4-9069-c6b6e262e301'
    , '000fc1e1-6e46-4187-a675-a5a5ba0e22b8'
    , '006d44ff-aa53-46e9-9bc6-eb3761d9a51c'
    , 'ffb83863-2d46-404a-b398-a07e3d36eaa7'
    , 10
    , 3
    , 10
);

CREATE EXTENSION IF NOT EXISTS plpython3u;

CREATE OR REPLACE FUNCTION insert_listing()
RETURNS TRIGGER
AS $$
    result = plpy.execute(
      f"SELECT g.manufacturer, COUNT(*) FROM goods g WHERE g.manufacturer = '{TD['new']['manufacturer']}' GROUP BY g.manufacturer;")
    if result.nrows() == 0:
      plpy.notice(f"Created new manufacturer {TD['new']['manufacturer']}")
      return "MODIFY"

    if result[0]['count'] >= 3:
      plpy.notice(f"{TD['new']['manufacturer']} already have more than 3 goods in system. Aborting.")
      return "SKIP"

    plpy.notice(f"{2 - result[0]['count']} goods left for {TD['new']['manufacturer']}")
    return "MODIFY"
$$ LANGUAGE PLPYTHON3U;

DROP TRIGGER IF EXISTS goods_insertion ON goods;
CREATE TRIGGER goods_insertion BEFORE INSERT ON goods
FOR EACH ROW EXECUTE PROCEDURE insert_listing();
INSERT INTO goods (
  id
  , name
  , description
  , year
  , manufacturer
  , manufacturer_website
)
VALUES (
    '00a80a37-2f31-455d-baaa-7a79810583ef'
  	, 'some wrong thing'
    , 'my test row for table'
    , 2019
    , 'Wilson and Sons2'
    , 'gibson.com'
);
DELETE FROM goods WHERE id = '00a80a37-2f31-455d-baaa-7a79810583ef';

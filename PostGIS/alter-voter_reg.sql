ALTER TABLE registered_voters ADD COLUMN rating integer;
ALTER TABLE registered_voters ADD COLUMN norm_address text;
ALTER TABLE registered_voters ADD COLUMN pt geometry;
ALTER TABLE registered_voters ADD COLUMN lat double precision;
ALTER TABLE registered_voters ADD COLUMN lon double precision;
ALTER TABLE registered_voters ADD COLUMN addid serial NOT NULL PRIMARY KEY;

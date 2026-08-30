CREATE TABLE stocking (
    event_id INTEGER PRIMARY KEY,
    waterbody_id INTEGER REFERENCES waterbody(waterbody_id),
    species_id INTEGER REFERENCES species(species_id),
    stock_date DATE,
    quantity INTEGER,
    average_length REAL
);

CREATE TABLE raw_stocking (
    watername TEXT,
    county TEXT,
    species TEXT,
    quantity INTEGER,
    average_length REAL,
    date_stocked DATE,
    year INTEGER
);

-- NOTE: COPY runs on the PostgreSQL server and requires an absolute path the
-- server process can read. Since paths differ per machine, use psql's \copy
-- meta-command instead — it runs on the client and accepts a path relative
-- to wherever you launch psql from (e.g. the repo root):
--
--   \copy raw_stocking (watername, county, species, quantity, average_length, date_stocked, year) FROM 'data/raw/utah_fish_stocking_2020_2026.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',')
--
-- The equivalent server-side COPY is left below for reference; update the
-- path to match your own environment if you use it instead of \copy.
COPY raw_stocking (
    watername,
    county,
    species,
    quantity,
    average_length,
    date_stocked,
    year
)
FROM 'data/raw/utah_fish_stocking_2020_2026.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

SELECT COUNT(*)
FROM raw_stocking;

SELECT *
FROM raw_stocking
LIMIT 10;

INSERT INTO waterbody (waterbody_id, name, county)
SELECT
    ROW_NUMBER() OVER (ORDER BY watername, county),
    watername,
    county
FROM (
    SELECT DISTINCT watername, county
    FROM raw_stocking
) AS unique_waters;

SELECT COUNT(*)
FROM waterbody;


INSERT INTO species (species_id, common_name)
SELECT
    ROW_NUMBER() OVER (ORDER BY species),
    species
FROM (
    SELECT DISTINCT species
    FROM raw_stocking
) AS unique_species;

SELECT *
FROM species
ORDER BY species_id;


INSERT INTO stocking (
    event_id,
    waterbody_id,
    species_id,
    stock_date,
    quantity,
    average_length
)
SELECT
    ROW_NUMBER() OVER (ORDER BY r.date_stocked, r.watername, r.species),
    w.waterbody_id,
    s.species_id,
    r.date_stocked,
    r.quantity,
    r.average_length
FROM raw_stocking r
JOIN waterbody w
    ON r.watername = w.name
    AND r.county = w.county
JOIN species s
    ON r.species = s.common_name;

SELECT COUNT(*)
FROM stocking;


SELECT
    w.name AS waterbody,
    w.county,
    s.common_name AS species,
    f.stock_date,
    f.quantity,
    f.average_length
FROM stocking f
JOIN waterbody w
    ON f.waterbody_id = w.waterbody_id
JOIN species s
    ON f.species_id = s.species_id
LIMIT 10;


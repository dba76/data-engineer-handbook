DROP TABLE IF EXISTS actors;
DROP TYPE IF EXISTS quality_class CASCADE;
DROP TYPE IF EXISTS films CASCADE;
CREATE TYPE films as (
    film TEXT,
    votes INTEGER,
    rating REAL,
    filmid TEXT
);
CREATE TYPE quality_class as ENUM('star', 'good', 'average', 'bad');
CREATE TABLE actors(
    actorid TEXT,
    actor TEXT,
    films films [],
    quality_class quality_class,
    is_active BOOLEAN,
    year INTEGER,
    PRIMARY KEY (actorid, year)
)
-- CREATE TYPE quality_class as ENUM('star', 'good', 'average', 'bad');

DROP TABLE actors_history_scd;

CREATE TABLE actors_history_scd (
    actorid TEXT,
    actor TEXT,
    is_active BOOLEAN,
    quality_class quality_class,
    start_date INTEGER,
    end_date INTEGER
)
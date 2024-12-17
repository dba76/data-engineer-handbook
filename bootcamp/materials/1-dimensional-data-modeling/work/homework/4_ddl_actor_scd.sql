-- CREATE TYPE quality_class as ENUM('star', 'good', 'average', 'bad');

CREATE TABLE if not EXISTS actors_history_scd (
    actorid TEXT,
    actor TEXT,
    is_active BOOLEAN,
    quality_class quality_class,
    start_date INTEGER,
    end_date INTEGER,
    current_year INTEGER
)
INSERT INTO actors_temp
with last_year_movies AS (
    select *
    from actors_temp
    where year = 1970
),
current_year_movies AS(
    SELECT actorid,
        actor,
        ARRAY_AGG(ROW(film, votes, rating, filmid)::films) OVER (w) as films,
        AVG (rating) OVER (w) as rating_avg,
        ROW_NUMBER() OVER (w),
        year as current_year
    from actor_films
    WHERE year = 1971 WINDOW w as (PARTITION BY year, actorid)
),
deduped_current_year_movies AS (
    select *
    from current_year_movies
    where row_number = 1
),
cummulative_data AS (
    select COALESCE(ly.actorid, ty.actorid) as actorid,
        COALESCE(ly.actor, ty.actor) as actor,
        COALESCE(ly.films, ARRAY []::films []) || COALESCE(ty.films, ARRAY []::films []) as films,
        CASE
            WHEN ty.rating_avg is NOT NULL THEN CASE
                WHEN ty.rating_avg > 8 THEN 'star'::quality_class
                WHEN ty.rating_avg > 7 THEN 'good'::quality_class
                WHEN ty.rating_avg > 6 THEN 'average'::quality_class
                ELSE 'bad'::quality_class
            END
            ELSE ly.quality_class
        END as quality_class,
        ty.current_year IS NOT NULL as is_active,
        1971 as year
    from deduped_current_year_movies ty
        full outer join last_year_movies ly on ty.actorid = ly.actorid
)
select * from  cummulative_data --where actorid = 'nm0000366'
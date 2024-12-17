with last_year AS (
    select *
    from actors_history_scd
    where start_date = 2020
        and end_date = 2020
),
historical AS (
    SELECT *
    from actors_history_scd
    where start_date < 2021
        and end_date = 2020
),
this_year AS (
    select *
    from actors
    where year = 2021
),
unchanged_from_last_year AS (
    SELECT ty.actorid,
        ty.actor,
        ty.is_active,
        ty.quality_class,
        ly.start_date,
        ty.year as end_date
    from this_year ty
        join last_year ly on ty.actorid = ly.actorid
    WHERE ty.quality_class = ly.quality_class
        and ty.is_active = ly.is_active
),
changed_from_last_year AS (
    SELECT ty.actorid,
        ty.actor,
        UNNEST(
            ARRAY [
            ROW (
                ly.is_active,
                ly.quality_class,
                ly.start_date,
                ly.end_date
            )::actor_scd_type,
            ROW (
                ty.is_active,
                ty.quality_class,
                ty.year,
                ty.year
            )::actor_scd_type
        ]
        ) as records
    from this_year ty
        join last_year ly on ty.actorid = ly.actorid
    WHERE (
            ty.quality_class <> ly.quality_class
            or ty.is_active <> ly.is_active
        )
),
unnested_changed_from_last_year AS (
    select actorid,
        actor,
        (records::actor_scd_type).is_active,
        (records::actor_scd_type).quality_class,
        (records::actor_scd_type).start_date,
        (records::actor_scd_type).end_date
    from changed_from_last_year
),
new_records AS (
    select ty.actorid,
        h.actor
    from this_year ty
        left join historical h on ty.actorid = h.actorid
    where h.actor is not null
)
select *
from new_records
-- where actorid = 'nm8900741'
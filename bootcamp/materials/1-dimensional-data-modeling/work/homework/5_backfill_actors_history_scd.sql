-- INSERT INTO actors_history_scd 
with history as (
    select actorid,
        actor,
        quality_class,
        is_active,
        LAG(quality_class, 1) OVER (w) as previous_qc,
        LAG(is_active, 1) OVER (w) as previous_is_active,
        year as current_year
    from actors
    where year < 2022 WINDOW w as (
            PARTITION BY actorid
            ORDER BY year
        )
),
indicator AS (
    select *,
        CASE
            WHEN quality_class <> previous_qc
            or is_active <> previous_is_active THEN 1
            ELSE 0
        END as change_indicator
    from history
),
with_streaks as (
    select *,
        SUM(change_indicator) OVER(
            PARTITION BY actorid
            ORDER BY current_year
        ) as streak_identifier
    from indicator
)
select actorid,
    MAX(actor) as actor,
    is_active,
    quality_class,
    MIN(current_year) as start_date,
    MAX(current_year) as end_date
from with_streaks
where actorid = 'nm0000366'
GROUP by actorid,
    is_active,
    quality_class,
    streak_identifier
order by actorid,
    streak_identifier
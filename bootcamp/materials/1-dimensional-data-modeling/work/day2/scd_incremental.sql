with last_season_scd as (
    select *
    from player_scd_1
    where current_season = 2021
        and end_season = 2021
),
historical_scd as (
    select player_name,
        scoring_class,
        is_active,
        start_season,
        end_season
    from player_scd_1
    where current_season = 2021
        and end_season < 2021
),
this_season_data as (
    SELECT *
    from players
    where current_season = 2022
),
unchanged_records as (
    select ts.player_name,
        ts.scoring_class,
        ts.is_active,
        ls.start_season,
        ts.current_season as end_season
    from this_season_data ts
        join last_season_scd ls on ts.player_name = ls.player_name
    where ts.scoring_class = ls.scoring_class
        and ts.is_active = ls.is_active
),
changed_records as (
    select ts.player_name,
        UNNEST(
            ARRAY [
            ROW(
                ls.scoring_class, 
                ls.is_active,
                ls.start_season,
                ls.end_season
            )::scd_type,
            ROW(
                ts.scoring_class, 
                ts.is_active,
                ts.current_season,
                ts.current_season
            )::scd_type
        ]
        ) as records
    from this_season_data ts
        left join last_season_scd ls on ts.player_name = ls.player_name
    where (
            ts.scoring_class <> ls.scoring_class
            or ts.is_active <> ls.is_active
        )
),
unnested_changed_records AS (
    select player_name,
        (records::scd_type).scoring_class,
        (records::scd_type).is_active,
        (records::scd_type).start_season,
        (records::scd_type).end_season
    from changed_records
),
new_records AS (
    select ts.player_name,
        ts.scoring_class,
        ts.is_active,
        ts.current_season as start_season,
        ts.current_season as end_season
    from this_season_data ts
        left join last_season_scd ls on ts.player_name = ls.player_name
    where ls.player_name is NULL
)
select *
from (
        select *
        from historical_scd
        UNION ALL 
        select *
        from unchanged_records
        UNION ALL
        select *
        from unnested_changed_records
        UNION ALL 
        select * from new_records
    ) A
where A.player_name = 'Aaron Brooks'




-- IS_DISTICT_FROM
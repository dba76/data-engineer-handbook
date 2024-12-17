INSERT into player_scd_1
with previous AS (
    select player_name,
        scoring_class,
        is_active,
        LAG(scoring_class, 1) OVER(
            PARTITION BY player_name
            ORDER BY current_season
        ) as previous_scoring_class,
        LAG(is_active, 1) OVER(
            PARTITION BY player_name
            ORDER BY current_season
        ) as previous_is_active,
        current_season
    from players
    where current_season < 2022
),
indicator AS (
    select *,
        CASE
            WHEN scoring_class <> previous_scoring_class THEN 1
            WHEN is_active <> previous_is_active THEN 1
            ELSE 0
        END as change_indicator
    from previous
),
with_streaks as (
    select *,
        SUM(change_indicator) OVER(
            PARTITION BY player_name
            ORDER BY current_season
        ) as streak_identifier
    from indicator
)
select player_name,    
    scoring_class,
    is_active,
    MIN (current_season) as start_season, 
    MAX (current_season) as end_season,
    2021 as current_season
from with_streaks
GROUP BY player_name, streak_identifier, is_active, scoring_class, current_season
ORDER BY player_name, streak_identifier
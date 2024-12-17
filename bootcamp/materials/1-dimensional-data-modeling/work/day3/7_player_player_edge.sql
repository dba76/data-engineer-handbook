INSERT INTO edges
with dedupe_game_details AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY player_id, game_id) AS rownumber
    from game_details
),
filtered AS (
    SELECT *
    FROM dedupe_game_details
    where rownumber = 1
),
aggregated AS (
    select f1.player_id as left_player_id,
        MAX(f1.player_name) as left_player_name,
        f2.player_id as right_player_id,
        MAX(f2.player_name) as right_player_name,
        case
            WHEN f1.team_abbreviation = f2.team_abbreviation THEN 'plays_with'::edge_type
            ELSE 'plays_against'::edge_type
        END as edge_type,
        count(1) as number_of_games,
        SUM(f1.pts) as left_points,
        SUM(f2.pts) as right_points
    from filtered f1
        join filtered f2 ON f1.game_id = f2.game_id
        AND f1.player_id <> f2.player_id
    WHERE f1.player_id > f2.player_id
    GROUP BY f1.player_id,
        f2.player_id,
        f1.team_abbreviation,
        f2.team_abbreviation
)
SELECT left_player_id as subject_identifier,
    'player'::vertex_type as subject_type,
    right_player_id as object_identifer,
    'player'::vertex_type as object_type,
    edge_type,
    json_build_object(
        'number_of_games', number_of_games,
        'subject_points', left_points,
        'object_points', right_points
    ) as properties
from aggregated
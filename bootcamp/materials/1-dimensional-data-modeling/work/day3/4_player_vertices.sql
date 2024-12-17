INSERT INTO vertices
with player_agg as (
    SELECT PLAYER_ID,
        MAX(PLAYER_NAME) AS PLAYER_NAME,
        COUNT(1) AS NUMBER_OF_GAME,
        SUM(pts) as total_points,
        array_agg(DISTINCT team_id) as teams
    FROM GAME_DETAILS
    GROUP BY PLAYER_ID
)
select player_id as identifer,
    'player'::vertex_type as vertex_type,
    json_build_object(
        'player_name', player_name,
        'number_of_games', number_of_game,
        'total_point', total_points,
        'teams', teams
    ) as properties
from player_agg
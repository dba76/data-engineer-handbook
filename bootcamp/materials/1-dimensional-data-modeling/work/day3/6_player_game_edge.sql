INSERT INTO edges
with deduped_gamedetails AS (
    select ROW_NUMBER() OVER(PARTITION BY player_id, game_id) as rownumber,
        *
    from game_details
)
SELECT player_id as subject_identifier,
    'player'::vertex_type as subject_type,
    game_id as object_identifier,
    'game'::vertex_type as object_type,
    'plays_in'::edge_type as edge_type,
    json_build_object(
        'start_position',
        start_position,
        'pts',
        pts,
        'team_id',
        team_id,
        'team_abbreviation',
        team_abbreviation
    ) as properties
from deduped_gamedetails
where rownumber = 1;
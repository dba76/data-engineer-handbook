INSERT INTO vertices
with teams_deduped AS (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY team_id) as rownumber
    from teams
)
select team_id as identifer,
    'team'::vertex_type as vertex_type,
    json_build_object(
        'abbreviation', abbreviation,
        'nickname', nickname,
        'city', city,
        'arena', arena,
        'yearfounded', yearfounded
    ) as properties
from teams_deduped
where rownumber = 1
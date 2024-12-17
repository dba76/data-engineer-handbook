INSERT INTO vertices
select 
    game_id,
    'game'::vertex_type as vertex_type,
    json_build_object(
        'pts_home', pts_home,
        'pts_away', pts_away,
        'winning_team', CASE WHEN home_team_wins = 1 THEN home_team_id ELSE visitor_team_id END
    ) as properties
    -- ROW_NUMBER() over(PARTITION BY game_id ORDER BY game_date_est) as rownumber
    from games 
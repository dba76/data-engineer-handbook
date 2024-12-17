-- CREATE TABLE player_scd_1(
--     player_name TEXT, 
--     scoring_class scoring_class,
--     is_active BOOLEAN, 
--     start_season INTEGER, 
--     end_season INTEGER,
--     current_season INTEGER,
--     PRIMARY KEY (player_name, start_season, end_season)
-- )

CREATE TABLE player_scd_2(
    player_name TEXT, 
    scoring_class scoring_class,
    is_active BOOLEAN, 
    start_season INTEGER, 
    end_season INTEGER,
    current_season INTEGER,
    PRIMARY KEY (player_name, start_season, end_season)
)


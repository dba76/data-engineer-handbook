-- CREATE TYPE vertex_type 
--     AS ENUM('player', 'team', 'game')

CREATE TABLE vertices(
    identifier TEXT,
    type vertex_type,
    properties JSON,
    PRIMARY KEY (identifier, type)
)
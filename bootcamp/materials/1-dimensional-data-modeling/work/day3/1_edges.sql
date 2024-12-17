-- CREATE TYPE edge_type 
--     AS ENUM ('plays_against', 'plays_with', 'plays_in', 'plays_on')

CREATE TABLE edges(
    subject_identifier TEXT,
    subject_type vertex_type,
    object_identifer TEXT,
    object_type vertex_type,
    edge_type edge_type,
    properties JSON,
    PRIMARY KEY (subject_identifier, 
        subject_type, 
        object_identifer, 
        object_type, 
        edge_type)
)
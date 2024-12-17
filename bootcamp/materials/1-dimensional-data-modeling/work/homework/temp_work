-- drop table YourTable;
-- create table YourTable
-- (
--   Id int,
--   FeeModeId int,
--   Name varchar(20),
--   Amount int
-- );

-- insert into YourTable values
--    (1   ,  NULL        , NULL         ,   20    ),
--    (2   ,  1           , 'Quarter-1'  ,   5000  ),
--    (3   ,  NULL        , NULL         ,   2000  ),    
--    (4   ,  2           , 'Quarter-2'  ,   8000  ),
--    (5   ,  NULL        , NULL         ,   5000  ),
--    (6   ,  NULL        , NULL         ,   2000  ),
--    (7   ,  3           , 'Quarter-3'  ,   6000  ),
--    (8   ,  NULL        , NULL         ,   4000  )
-- ;

select Id,
            FeeModeId,
            Name,
            Amount,
            sum(case when FeeModeId is null then 0 else 1 end) over(order by Id) as NF,
            sum(case when Name is null then 0 else 1 end) over(order by Id) as NS
     from YourTable;

select T.Id,
       first_value(T.FeeModeId) over(partition by T.NF order by T.Id rows between unbounded preceding and current row) as FeeModeId,
       first_value(T.Name)      over(partition by T.NS order by T.Id rows between unbounded preceding and current row) as Name,
       T.Amount
from (
     select Id,
            FeeModeId,
            Name,
            Amount,
            sum(case when FeeModeId is null then 0 else 1 end) over(order by Id) as NF,
            sum(case when Name is null then 0 else 1 end) over(order by Id) as NS
     from YourTable
     ) as T


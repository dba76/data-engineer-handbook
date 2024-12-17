select actorid, actor, quality_class, 
    is_active, 
    LAG(quality_class, 1) OVER (w) as previous_qc,
    LAG(is_active, 1) OVER (w) as previous_is_active,
    year as current_year 
from actors
-- where actorid = 'nm0000366'
WINDOW w as (PARTITION BY actorid ORDER BY year)
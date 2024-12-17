-- INSERT INTO actors 
with years AS (
    select *
    from generate_series(1970, 2022) as year
),
actors_list as (
    select actorid,
        min(year) as min_year,
        max(actor) as actor
    from actor_films
    GROUP BY actorid
),
year_actor_list AS (
    select *
    from years y
        left join actors_list a on y.year >= a.min_year
),
aggreated_by_actor AS (
    select la.actorid,
        la.actor,
        af is not null as is_active,
        af.filmid,
        rating,
        case
            when af is not null then ROW(film, votes, rating, filmid)::films
        END as afilm,
        array_remove(
            array_agg(
                case
                    when af is not null then ROW(film, votes, rating, filmid)::films
                END
            ) over (w),
            null
        ) as films,
        ROW_NUMBER() OVER (w) as row_number_per_year,
        la.year
    from year_actor_list la
        left join actor_films af on la.year = af.year
        and la.actorid = af.actorid WINDOW w AS (
            PARTITION BY la.actorid
            order by la.year,
                af.filmid
        )
),
aggreated_by_year as (
    select actorid,
        actor,
        is_active,
        max(row_number_per_year) over (w) = row_number_per_year as is_year_films,
        films,
        AVG(rating) over (w) as avg_rating_per_year,
        year
    from aggreated_by_actor WINDOW w as (PARTITION BY year, actorid)
),
deduped_aggregated AS (
    select *
    from aggreated_by_year
    where is_year_films = true
),
avg_rating_sub AS (
    select *,
        sum(
            case
                when avg_rating_per_year is null then 0
                else 1
            end
        ) over(
            PARTITION BY actorid
            order by year
        ) as NF
    from deduped_aggregated
),
avg_rating_aggregated AS (
    select *,
        first_value(avg_rating_per_year) over(
            partition by actorid,
            NF
            order by year rows between unbounded preceding and current row
        ) as avg_rating_per_year_1
    from avg_rating_sub
)
select 
    actorid,
    actor,
    films,
    CASE
        WHEN avg_rating_per_year_1 > 8 THEN 'star'::quality_class
        WHEN avg_rating_per_year_1 > 7 THEN 'good'::quality_class
        WHEN avg_rating_per_year_1 > 6 THEN 'average'::quality_class
        ELSE 'bad'::quality_class
    END as quality_class,
    is_active,
    year
from avg_rating_aggregated
where actorid = 'nm0000366'
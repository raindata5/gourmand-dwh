with event_cats as (
    SELECT
    *
    FROM {{source("public2", "eventcategory")}}
)
select * from event_cats
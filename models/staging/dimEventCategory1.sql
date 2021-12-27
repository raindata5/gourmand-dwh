with event_cats as (
    SELECT
    *
    FROM {{source("dbo", "EventCategory")}}
)
select * from event_cats
with events as (
    select 
        *
    from {{ source("dbo", "Event") }}
)

select * from events
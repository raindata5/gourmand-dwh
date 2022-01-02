with events as (
    select 
        *
    from {{ source("public2", "event") }}
)

select * from events
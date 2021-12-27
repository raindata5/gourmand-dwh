with counties as (
    SELECT * from {{ source("dbo","Country")}}
)

select * from counties
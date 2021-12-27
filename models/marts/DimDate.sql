with finaldates as (
    select 
    * 
    FROM {{ref("dimdate")}}
)
select * FROM finaldates
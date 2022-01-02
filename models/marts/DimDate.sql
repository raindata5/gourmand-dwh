with finaldates as (
    select 
    * 
    FROM {{ref("dimdates")}}
)
select * FROM finaldates
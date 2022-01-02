with bus as (
    select 
        db1.*
    FROM {{ ref("dimbusiness1")}} db1
)

select * from bus


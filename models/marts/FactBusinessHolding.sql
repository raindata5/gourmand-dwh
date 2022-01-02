-- maybe come back and add lasteditedwhen to witness the 
-- updates that can take place for through the incremental model
-- seems closedate is sufficient

-- Transaction management is used to ensure this is executed as a single unit of work.

-- look to change left join back to inner join

-- if business were to change then set the new business instance for the next day
{{ config(
    materialized='incremental',
    unique_key='IncrementalCompKey')
}}

with bh1 as (
    select
        bh.BusinessHoldingID,
        db.BusinessKey,
        bh.BusinessID BusinessSourceKey,
        bh.BusinessRating,
        bh.ReviewCount,
        bh.CloseDate,
        bh.IncrementalCompKey
FROM {{ source("public2", "businessholding") }} bh
INNER JOIN {{ ref("DimBusiness") }} db on bh.BusinessID=db.BusinessSourceKey
-- WHERE bh.CloseDate BETWEEN cast(db.ValidFrom as DATE) and cast(db.ValidTo as DATE)
WHERE bh.CloseDate >= cast(db.ValidFrom as DATE) and bh.CloseDate < cast(db.ValidTo as DATE)
)

-- dbt run --full-refresh --select my_incremental_model+
select 
*
from bh1
{% if is_incremental() %}

where CloseDate >= (select max(CloseDate) from {{ this }})
{% endif %}
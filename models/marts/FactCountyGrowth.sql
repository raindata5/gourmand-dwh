
{{ 
    config( 
    materialized='incremental',
    unique_key='IncrementalCompKey' 
    )
}}

with
    cg
    as
    (
        select
            c.CountyID CountySourceKey,
            c.EstimationYear,
            c.EstimatedPopulation,
            c.LastEditedWhen,
            c.IncrementalCompKey
        from {{ source("dbo", "CountyGrowth") }} c

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where c.LastEditedWhen > (select max(LastEditedWhen) from {{ this }})

{% endif %}
)

select * from cg

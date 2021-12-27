with dim_county as (
    SELECT
        d.CountySourceKey,
        d.CountyName,
        d.StateName
    FROM {{ ref("dimcounty1")}} d
)

select * from dim_county
with businesses as (
    select 
        ROW_NUMBER() OVER(ORDER BY b.LastEditedWhen ASC) BusinessKey,
        b.BusinessID BusinessSourceKey,
        b.BusinessName,
        b.ChainName,
        b.CityID CitySourceKey,
        pl.PaymentLevelSymbol,
        pl.PaymentLevelName,
        b.Longitude,
        b.Latitude,
        b.AddressLine1,
        b.AddressLine2,
        b.AddressLine3,
        b.ZipCode,
        b.BusinessPhone,
        b.BusinessURL,
        b.is_closed,
        b.DistanceToCounty,
        LastEditedWhen ValidFrom,
        -- dbt_valid_from ValidFrom,
        -- CASE 
        -- WHEN dbt_valid_to is NULL THEN CAST('9999-12-31' as TIMESTAMP)
        -- ELSE dbt_valid_to
        -- END AS ValidTo,
        CASE 
        WHEN ValidTo is NULL THEN CAST('9999-12-31' as TIMESTAMP)
        ELSE ValidTo
        END AS ValidTo,
        CASE 
        WHEN dbt_valid_to is NULL THEN 1
        ELSE 0
        END AS is_current
    from {{ref("snap_business")}} b
    LEFT JOIN {{source("public2","paymentlevel")}} pl on b.PaymentLevelID=pl.PaymentLevelID
)

select * from businesses
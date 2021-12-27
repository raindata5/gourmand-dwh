

-- with events as (
--     select 
--         ROW_NUMBER() OVER(ORDER BY de1.EventID ASC) EventKey,
--         de1.EventID EventSourceKey,
--         db1.BusinessSourceKey
--         EventName,
--         Attending,
--         CostOfAttending,
--         is_free,
--         EventDescription,
--         Interested,
--         de1.CityID CitySourceKey,
--         de1.latitude,
--         de1.longitude,
--         de1.ZipCode,
--         de1.StartTime,
--         de1.EndTime,
--         de1.TicketsUrl,
--         de1.EventSiteUrl,
--         de1.CancelDate,
--         de1.OfficialDate,
--         de1.CreatedAt,
--         de1.dbt_valid_from ValidFrom,
--         CASE 
--         WHEN dbt_valid_to is NULL THEN CAST('9999-12-31' as DATETIME)
--         ELSE dbt_valid_to
--         END AS ValidTo,
--         CASE 
--         WHEN dbt_valid_to is NULL THEN 1
--         ELSE 0
--         END AS is_current
--     FROM {{ref("dimevent1")}} de1
--     LEFT JOIN {{ ref("DimBusiness")}} db1 on de1.BusinessID=db1.BusinessSourceKey 
-- )

{{ 
    config(
            materialized='incremental',
            unique_key='EventSourceKey'
)}}

with de as 
(
    select 
        de1.EventID EventSourceKey,
        de1.BusinessID BusinessSourceKey,
        de1.EventName,
        de1.Attending,
        de1.CostOfAttending,
        de1.is_free,
        de1.EventDescription,
        de1.Interested,
        de1.CityID CitySourceKey,
        de1.latitude,
        de1.longitude,
        de1.ZipCode,
        de1.StartTime,
        de1.EndTime,
        de1.TicketsUrl,
        de1.EventSiteUrl,
        de1.CancelDate,
        de1.OfficialDate,
        de1.CreatedAt,
        de1.LastEditedWhen

    FROM {{ ref("dimevent1")}} de1
-- in the event one wants to join this dim to the business dim
    -- LEFT JOIN {{ ref("DimBusiness")}} db1 on de1.BusinessID=db1.BusinessSourceKey
-- using both createdat and lasteditedwhen allows an event to connect
-- with original business instance and in the event it changes to a new instance
-- the event can connect to the new one two
    -- WHERE (de1.CreatedAt BETWEEN db1.ValidFrom and db1.ValidTo) 
    -- OR 
    -- (de1.LastEditedWhen BETWEEN db1.ValidFrom and db1.ValidTo)
)
select 
    * 
from de
{% if is_incremental() %}

where LastEditedWhen >= (select coalesce(max(LastEditedWhen),cast('1998-11-12' as date)) from {{ this }})
{% endif %}
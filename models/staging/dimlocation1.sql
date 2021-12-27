
with joined_locations as (
    SELECT
        sc.cityid,
        sc.cityname,
        scon.CountyName,
        ss.statename,    
        src.CountryName,
        sc.countyid
    FROM {{ source("dbo", "City") }} sc
    LEFT JOIN {{source("dbo", "State")}} ss on sc.stateid=ss.stateid
    left JOIN {{source("dbo", "County")}} scon on sc.countyid=scon.countyid
    left JOIN {{ source("dbo", "Country")}} src on ss.CountryID=src.CountryID
)

select * from joined_locations


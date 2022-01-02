
with joined_locations as (
    SELECT
        sc.cityid,
        sc.cityname,
        scon.CountyName,
        ss.statename,    
        src.CountryName,
        sc.countyid
    FROM {{ source("public2", "city") }} sc
    LEFT JOIN {{source("public2", "state")}} ss on sc.stateid=ss.stateid
    left JOIN {{source("public2", "county")}} scon on sc.countyid=scon.countyid
    left JOIN {{ source("public2", "country")}} src on ss.CountryID=src.CountryID
)

select * from joined_locations


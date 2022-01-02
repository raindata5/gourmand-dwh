with loc as (
    Select 
        d1.cityid CitySourceKey,
        d1.cityname CityName,
        d1.CountyName,
        d1.statename StateName,    
        d1.CountryName,
        dc.CountySourceKey

    FROM {{ ref("dimlocation1") }} d1
    LEFT JOIN {{ ref("DimCounty") }} dc on d1.countyid= dc.CountySourceKey and d1.CountyName=dc.CountyName and d1.statename=dc.StateName
)

select * from loc 
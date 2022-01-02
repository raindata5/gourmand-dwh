with county as (
    SELECT
        c.CountyID CountySourceKey,
        c.CountyName,
        s.StateName
        
    from {{ source('public2', 'county') }} c
    INNER JOIN {{ source('public2', 'state') }} s on c.StateID=s.stateid
)
SELECT
* from county
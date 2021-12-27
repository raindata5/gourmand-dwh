with county as (
    SELECT
        c.CountyID CountySourceKey,
        c.CountyName,
        s.StateName
        
    from {{ source('dbo', 'County') }} c
    INNER JOIN {{ source('dbo', 'State') }} s on c.StateID=s.stateid
)
SELECT
* from county
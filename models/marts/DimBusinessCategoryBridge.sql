
with bdg1 as (
    SELECT
        db1.BusinessKey,
        dbc1.BusinessCategoryKey,
        sbdg.BusinessID,
        sbdg.CategoryID,
        dbt_valid_from ValidFrom,
        CASE 
        WHEN dbt_valid_to is NULL THEN CAST('9999-12-31' as DATETIME)
        ELSE dbt_valid_to
        END AS ValidTo,
        CASE 
        WHEN dbt_valid_to = CAST('9999-12-31' as DATETIME) THEN 1
        ELSE 0
        END AS is_current

    FROM {{ ref("dimbcb") }} sbdg
    INNER JOIN {{ref("DimBusiness")}} db1 on sbdg.BusinessID=db1.BusinessSourceKey
    INNER JOIN {{ref("DimBusinessCategory")}} dbc1 on sbdg.CategoryID=dbc1.CategorySourceKey
    -- to first make sure the business was valid during the time
  WHERE 
    (sbdg.dbt_valid_from < db1.ValidTo and sbdg.dbt_valid_to > db1.ValidFrom)
    AND
    (sbdg.dbt_valid_from < dbc1.ValidTo and sbdg.dbt_valid_to > dbc1.ValidFrom)




    -- making sure a connection itself was modified during effective dates of business
        -- (sbdg.dbt_valid_from BETWEEN db1.ValidFrom and db1.ValidTo 
        -- OR sbdg.dbt_valid_to BETWEEN db1.ValidFrom and db1.ValidTo)

    -- seeing if a connecton was modified during effective dates of a category
    -- so if the connection remained a unchanged and a category was changed...
    -- then only the most recent instance of the category will show
        -- AND (sbdg.dbt_valid_from BETWEEN dbc1.ValidFrom and dbc1.ValidTo
        -- OR sbdg.dbt_valid_to BETWEEN dbc1.ValidFrom and dbc1.ValidTo)
        
    -- making sure the category was active while business was active
    -- also skipping a business instance  that existed while there were no changes with the
    -- category and rather being assigned to the next business instance
    -- also accounting for approx. 2 mins delay in values being inserted
        -- and (DATEADD(Hour, DATEDIFF(Hour, 0, dbc1.ValidFrom), 0) 
        -- BETWEEN DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidFrom), 0) and DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidTo), 0)
        -- OR 
        -- DATEADD(Hour, DATEDIFF(Hour, 0, dbc1.ValidTo), 0) 
        -- BETWEEN DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidFrom), 0) and DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidTo), 0))
    -- making sure the business was active while category was active
    -- also skipping a category instance  that existed while there were no changes with the
    -- category and rather being assigned to the next category instance
    -- also accounting for approx. 2 mins delay in values being inserted
        -- and (DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidFrom), 0) 
        -- BETWEEN DATEADD(Hour, DATEDIFF(Hour, 0, dbc1.ValidFrom), 0) and DATEADD(Hour, DATEDIFF(Hour, 0, dbc1.ValidTo), 0)
        -- OR
        -- DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidTo), 0)
        -- BETWEEN DATEADD(Hour, DATEDIFF(Hour, 0, dbc1.ValidFrom), 0) and DATEADD(Hour, DATEDIFF(Hour, 0, dbc1.ValidTo), 0))

-- in oltp look to set the edit times manually instead to be able to default on this setup
        -- AND (dbc1.ValidFrom BETWEEN db1.ValidFrom and db1.ValidTo
        -- OR dbc1.Validto BETWEEN db1.ValidFrom and db1.ValidTo)

        -- AND (db1.ValidFrom BETWEEN dbc1.ValidFrom and dbc1.ValidTo
        -- OR db1.ValidTo BETWEEN dbc1.ValidFrom and dbc1.ValidTo)
)

select * from bdg1



-- Notes to self:
    -- change previous models to not have to ue function in search argument
    -- where the bdg start date is in between the bus end and start date
    -- or the bdg end date 

    -- starting to think it's still better to use source keys
    -- go back to using source keys in this case 
    -- there is no perceived benefit to already having the DWH
    -- surrogate keys in place in the bridge since the most signi
    -- ficant change a business could undergo is in it's
    -- payment level
    -- so for all intents and purposes the previous categories of the
    -- business would still apply

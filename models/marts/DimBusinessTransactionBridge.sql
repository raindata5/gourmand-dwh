with bdg1 as (
    SELECT
        db1.BusinessKey,
        dtt1.TransactionKey,
        sbdg.BusinessID,
        sbdg.TransactionID,
        sbdg.LastEditedWhen ValidFrom,
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

    FROM {{ ref("snap_businesstransactionbridge") }} sbdg
    INNER JOIN {{ref("DimBusiness")}} db1 on sbdg.BusinessID=db1.BusinessSourceKey
    INNER JOIN {{ref("DimTransactionType")}} dtt1 on sbdg.TransactionID=dtt1.TransactionSourceKey
    WHERE 
        (sbdg.dbt_valid_from < db1.ValidTo and coalesce(sbdg.dbt_valid_to, CAST('9999-12-31' as TIMESTAMP)) > db1.ValidFrom)
        AND
        (sbdg.dbt_valid_from < dtt1.ValidTo and coalesce(sbdg.dbt_valid_to, CAST('9999-12-31' as TIMESTAMP)) > dtt1.ValidFrom)




    -- making sure a connection itself was modified during effective dates of business
    -- WHERE (sbdg.dbt_valid_from BETWEEN db1.ValidFrom and db1.ValidTo 
    -- OR sbdg.dbt_valid_to BETWEEN db1.ValidFrom and db1.ValidTo)

    -- seeing if a connecton was modified during effective dates of a transaction
    -- so if the connection remained unchanged and a transaction was changed...
    -- then only the most recent instance of the transaction will show
    -- AND (sbdg.dbt_valid_from BETWEEN dtt1.ValidFrom and dtt1.ValidTo
    --     OR sbdg.dbt_valid_to BETWEEN dtt1.ValidFrom and dtt1.ValidTo)
      
    -- making sure the transaction was active while business was active
    -- also skipping a business instance  that existed while there were no changes with the
    -- transaction and rather being assigned to the next business instance
    -- also accounting for approx. 2 mins delay in values being inserted
        -- and (DATEADD(Hour, DATEDIFF(Hour, 0, dtt1.ValidFrom), 0) 
        -- BETWEEN DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidFrom), 0) and DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidTo), 0)
        -- OR 
        -- DATEADD(Hour, DATEDIFF(Hour, 0, dtt1.ValidTo), 0) 
        -- BETWEEN DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidFrom), 0) and DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidTo), 0))
    -- making sure the business was active while the transaction was active
    -- also skipping a transaction instance  that existed while there were no changes with the
    -- transaction and rather being assigned to the next transaction instance
    -- also accounting for approx. 2 mins delay in values being inserted
        -- and (DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidFrom), 0) 
        -- BETWEEN DATEADD(Hour, DATEDIFF(Hour, 0, dtt1.ValidFrom), 0) and DATEADD(Hour, DATEDIFF(Hour, 0, dtt1.ValidTo), 0)
        -- OR
        -- DATEADD(Hour, DATEDIFF(Hour, 0, db1.ValidTo), 0)
        -- BETWEEN DATEADD(Hour, DATEDIFF(Hour, 0, dtt1.ValidFrom), 0) and DATEADD(Hour, DATEDIFF(Hour, 0, dtt1.ValidTo), 0))

)

select * from bdg1
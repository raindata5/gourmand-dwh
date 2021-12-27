with DTT as (
    SELECT
        ROW_NUMBER() OVER(ORDER BY LastEditedWhen ASC) TransactionKey,
        TransactionID TransactionSourceKey,
        TransactionName,
        dbt_valid_from ValidFrom,
        CASE 
        WHEN dbt_valid_to is NULL THEN CAST('9999-12-31' as DATETIME)
        ELSE dbt_valid_to
        END AS ValidTo,
        CASE 
        WHEN dbt_valid_to is NULL THEN 1
        ELSE 0
        END AS is_current
        
    FROM {{ref("snap_DTT")}}
)

select * from DTT
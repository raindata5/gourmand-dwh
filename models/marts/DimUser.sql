with bus_cat as (
    SELECT
        ROW_NUMBER() OVER(ORDER BY LastEditedWhen ASC) UserKey,
        UserID UserSourceKey,
        UserProfileURL BusinessCategoryName,
        UserImageURL,
        FirstName,
        LastNameInitial,
        dbt_valid_from ValidFrom,
        CASE 
        WHEN dbt_valid_to is NULL THEN CAST('9999-12-31' as DATETIME)
        ELSE dbt_valid_to
        END AS ValidTo,
        CASE 
        WHEN dbt_valid_to is NULL THEN 1
        ELSE 0
        END AS is_current
        
    FROM {{ ref("snap_User") }}
)

select * from bus_cat
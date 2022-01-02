-- this will continue to be joined on the business source key
-- for 2 reasons
-- one to get all the current reviews for a business I can just 
-- join it's source key to dimreview where the validfrom (review) is greater than 
-- getdate()
-- two to get the reviews made during a particular "instance" of
-- a business I can just make sure the business validfrom date
-- is greater than the review validfrom date

-- to do SCD 1 with this dimension I could do an incremental
-- model and just set date to minimum
--revise the above

with reviews as (
    select
        ROW_NUMBER() OVER(ORDER BY InsertedAt ASC) ReviewKey,
        dr1.ReviewID ReviewSourceKey,
        dr1.ReviewURL,
        dr1.ReviewExtract,
        dr1.ReviewRating,
        dr1.CreatedAt,
        dr1.InsertedAt,
        du1.UserKey,
        db1.BusinessKey,
        dbt_valid_from ValidFrom,
        CASE 
        WHEN dbt_valid_to is NULL THEN CAST('9999-12-31' as TIMESTAMP)
        ELSE dbt_valid_to
        END AS ValidTo,
        CASE 
        WHEN dbt_valid_to is NULL THEN 1
        ELSE 0
        END AS is_current
    FROM {{ ref("dimreview1")}} dr1
    -- i believe these left joins get converted into inner joins
    LEFT JOIN {{ ref("DimBusiness")}} db1 on dr1.BusinessID=db1.BusinessSourceKey 
    LEFT JOIN {{ ref("DimUser")}} du1 on dr1.UserID=du1.UserSourceKey
    WHERE (dr1.insertedat >= db1.ValidFrom and dr1.insertedat < db1.ValidTo) and
    (dr1.insertedat >= du1.ValidFrom and dr1.insertedat < du1.ValidTo)
    -- this permits using WH surrogate key
    -- i could do a union after if desired to keep all of the reviews
    -- in the small chance that it doesn't correspond to a business 
    -- or a user
)

select * from reviews
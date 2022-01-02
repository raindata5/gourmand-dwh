

with review1 as (
    SELECT
        *
    FROM {{ ref("snap_review")}}
)
select * from review1
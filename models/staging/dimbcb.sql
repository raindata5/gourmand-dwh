-- look to dimBTB for info
with b_cat_bridge as (
    SELECT
        sbdg.BusinessID,
        sbdg.CategoryID,
        sbdg.LastEditedWhen,
        sbdg.SnapshotCompKey,
        sbdg.dbt_scd_id,
        sbdg.dbt_updated_at,
        sbdg.dbt_valid_from,
        COALESCE(sbdg.dbt_valid_to, CAST('9999-12-31' as TIMESTAMP)) as dbt_valid_to
    FROM {{ ref("snap_businesscategorybridge") }} sbdg
)
select *
FROM b_cat_bridge
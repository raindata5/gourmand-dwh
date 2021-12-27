{% snapshot snap_businesscategorybridge %}
{{
    config(
        target_database='GourmandDWH',
        target_schema='Snapshots',
        unique_key='SnapshotCompKey',

        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=True
    )
}}
SELECT * from {{ source('dbo', 'BusinessCategoryBridge') }}

{% endsnapshot %}
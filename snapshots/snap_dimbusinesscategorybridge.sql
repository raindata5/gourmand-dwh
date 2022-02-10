{% snapshot snap_businesscategorybridge %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots2',
        unique_key='SnapshotCompKey',

        strategy='timestamp',
        updated_at='LastEditedWhen'
        -- invalidate_hard_deletes=True
    )
}}
SELECT * from {{ source('public2', 'businesscategorybridge') }}

{% endsnapshot %}
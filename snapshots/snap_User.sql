{% snapshot snap_User %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots',
        unique_key='UserID',

        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=True
    )
}}
SELECT * from {{ source('public2', 'user') }}

{% endsnapshot %}
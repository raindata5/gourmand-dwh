{% snapshot snap_User %}
{{
    config(
        target_database='GourmandDWH',
        target_schema='Snapshots',
        unique_key='UserID',

        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=True
    )
}}
SELECT top(10000000000) * from {{ source('dbo', 'User') }}

{% endsnapshot %}
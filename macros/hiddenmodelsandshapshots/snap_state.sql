{% snapshot snap_state %}
{{
    config(
        target_database='GourmandDWH',
        target_schema='Snapshots',
        unique_key='StateID',

        strategy='timestamp',
        updated_at='LastEditedWhen'
    )
}}
SELECT * from {{ source('dbo', 'State') }}
{% endsnapshot %}
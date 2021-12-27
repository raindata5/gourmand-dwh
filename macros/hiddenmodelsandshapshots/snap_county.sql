{% snapshot snap_county %}
{{
    config(
        target_database='GourmandDWH',
        target_schema='Snapshots',
        unique_key='CountyID',

        strategy='timestamp',
        updated_at='LastEditedWhen'
    )
}}
SELECT * from {{ source('dbo', 'County') }}
{% endsnapshot %}
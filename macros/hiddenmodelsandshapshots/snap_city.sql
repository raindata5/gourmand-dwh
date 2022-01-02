{% snapshot snap_city %}
{{
    config(
        target_database='GourmandDWH',
        target_schema='Snapshots',
        unique_key='CityID',

        strategy='timestamp',
        updated_at='LastEditedWhen'
    )
}}
SELECT * from {{ source('dbo', 'City') }}
{% endsnapshot %}
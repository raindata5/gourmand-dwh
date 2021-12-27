{% snapshot snap_dimbusinesscategory %}
{{
    config(
        target_database='GourmandDWH',
        target_schema='Snapshots',
        unique_key='CategoryID',

        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=True
    )
}}
SELECT * 
from {{ source('dbo', 'BusinessCategory') }}
{% endsnapshot %}
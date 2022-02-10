{% snapshot snap_dimbusinesscategory %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots',
        unique_key='CategoryID',

        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=False
    )
}}
SELECT * 
from {{ source('public2', 'businesscategory') }}
{% endsnapshot %}
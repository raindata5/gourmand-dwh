{% snapshot snap_review %}
{{
    config(
        target_database='GourmandDWH',
        target_schema='Snapshots',
        unique_key='ReviewID',

        strategy='timestamp',
        updated_at='InsertedAt',
        invalidate_hard_deletes=True
    )
}}
SELECT * 
from {{ source('dbo', 'Review') }}

{% endsnapshot %}
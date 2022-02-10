{% snapshot snap_review %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots',
        unique_key='ReviewID',

        strategy='timestamp',
        updated_at='InsertedAt',
        invalidate_hard_deletes=False
    )
}}
SELECT * 
from {{ source('public2', 'review') }}

{% endsnapshot %}
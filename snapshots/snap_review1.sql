{% snapshot snap_review %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots2',
        unique_key='ReviewID',

        strategy='timestamp',
        updated_at='InsertedAt'
        -- invalidate_hard_deletes=True
    )
}}
SELECT * 
from {{ source('public2', 'review') }}

{% endsnapshot %}
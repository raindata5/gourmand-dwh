{% snapshot snap_business %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots2',
        unique_key='BusinessID',

        strategy='timestamp',
        updated_at='LastEditedWhen'
        -- invalidate_hard_deletes=True
    )
}}
SELECT *
from {{ source('public2', 'business') }} 

{% endsnapshot %}
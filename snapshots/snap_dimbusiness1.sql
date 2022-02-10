{% snapshot snap_business %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots',
        unique_key='BusinessID',

        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=False
    )
}}
SELECT *
from {{ source('public2', 'business') }} 

{% endsnapshot %}
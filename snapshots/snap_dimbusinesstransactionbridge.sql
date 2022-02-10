{% snapshot snap_businesstransactionbridge %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots2',
        unique_key='SnapshotCompKey',

        strategy='timestamp',
        updated_at='LastEditedWhen'
        -- invalidate_hard_deletes=True
    )
}}
SELECT 
    * 
from {{ source('public2', 'businesstransactionbridge') }}

{% endsnapshot %}
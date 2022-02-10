{% snapshot snap_businesstransactionbridge %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots',
        unique_key='SnapshotCompKey',

        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=False
    )
}}
SELECT 
    * 
from {{ source('public2', 'businesstransactionbridge') }}

{% endsnapshot %}
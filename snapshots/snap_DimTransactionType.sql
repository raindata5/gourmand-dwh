{% snapshot snap_DTT %}
{{
    config(
        target_database='GourmandDWH',
        target_schema='Snapshots',
        unique_key='TransactionID',

        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=True
    )
}}
SELECT * from {{ source('dbo', 'TransactionType') }}

{% endsnapshot %}
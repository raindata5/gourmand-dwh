{% snapshot snap_DTT %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots',
        unique_key='TransactionID',

        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=False
    )
}}
SELECT * from {{ source('public2', 'transactiontype') }}

{% endsnapshot %}
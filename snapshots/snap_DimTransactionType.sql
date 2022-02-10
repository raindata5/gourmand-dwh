{% snapshot snap_DTT %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots2',
        unique_key='TransactionID',

        strategy='timestamp',
        updated_at='LastEditedWhen'
        -- invalidate_hard_deletes=True
    )
}}
SELECT * from {{ source('public2', 'transactiontype') }}

{% endsnapshot %}
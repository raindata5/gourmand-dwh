{% snapshot snap_event %}
{{
    config(
        target_database='gourmanddwh',
        target_schema='Snapshots',
        unique_key='EventID',
        strategy='timestamp',
        updated_at='LastEditedWhen',
        invalidate_hard_deletes=True
    )
}}
SELECT * from {{ source('public2', 'event') }}

{% endsnapshot %}
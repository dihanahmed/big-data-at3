{% snapshot host_snapshot %}
{{
  config(
    target_schema='silver_snapshots',
    unique_key='host_id',
    strategy='timestamp',
    updated_at='scraped_date'
  )
}}
select
  h.host_id,
  h.host_name,
  h.host_since,
  h.host_is_superhost,
  h.host_neighbourhood,
  l.scraped_date
from {{ ref('dim_host') }} h
join {{ ref('dim_listing') }} l on l.host_id = h.host_id
{% endsnapshot %}

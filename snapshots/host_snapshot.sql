{% snapshot host_snapshot %}
{{
  config(
    target_schema='silver_snapshots',
    unique_key='host_id',
    strategy='timestamp',
    updated_at='scraped_date'
  )
}}

-- Host-level slowly changing dimension (SCD Type 2)
select
    h.host_id,
    h.host_name,
    h.host_since,
    h.host_is_superhost,
    h.host_neighbourhood,
    -- take latest scraped_date from any listing of this host
    max(l.scraped_date) as scraped_date
from {{ ref('dim_host') }} h
left join {{ ref('dim_listing') }} l
    on l.host_id = h.host_id
group by 1,2,3,4,5

{% endsnapshot %}

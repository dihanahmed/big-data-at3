-- One row per suburb with its LGA code/name
with code as (select * from {{ ref('stg_nsw_lga_code') }}),
suburb as (select * from {{ ref('stg_nsw_lga_suburb') }})
select
  c.lga_code,
  c.lga_name,
  s.suburb_name
from code c
left join suburb s on lower(c.lga_name) = lower(s.lga_name)

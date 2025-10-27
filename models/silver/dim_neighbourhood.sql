with nb as (select * from {{ ref('stg_nsw_lga_suburb') }}),
lg as (select * from {{ ref('stg_nsw_lga_code') }})
select
  nb.suburb_name,
  nb.lga_name,
  lg.lga_code
from nb
left join lg on lower(nb.lga_name) = lower(lg.lga_name)
where nb.suburb_name is not null

with src as (select * from {{ ref('stg_airbnb_2020_05') }})
select distinct
  host_id,
  host_name,
  host_since,
  host_is_superhost,
  host_neighbourhood
from src
where host_id is not null

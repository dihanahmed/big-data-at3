-- Basic LGA dimension from G01/G02 census staging
with g01 as (select * from {{ ref('stg_census_g01') }}),
g02 as (select * from {{ ref('stg_census_g02') }})
select
  g01.lga_code_2016 as lga_code,
  /* choose a representative name if needed (join to code table if preferred) */
  g01.tot_p_p,
  g02.median_age_persons,
  g02.median_rent_weekly,
  g02.average_household_size
from g01
left join g02 on g02.lga_code_2016 = g01.lga_code_2016

select
  lga_code,
  lga_name
from {{ ref('stg_nsw_lga_code') }}

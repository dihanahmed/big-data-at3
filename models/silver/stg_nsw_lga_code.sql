select
  trim("LGA_CODE")::text as lga_code,
  nullif(trim("LGA_NAME"),'') as lga_name
from {{ source('bronze', 'nsw_lga_code_raw') }}

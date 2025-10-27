select
  nullif(trim("LGA_NAME"),'')    as lga_name,
  nullif(trim("SUBURB_NAME"),'') as suburb_name
from {{ source('bronze', 'nsw_lga_suburb_raw') }}
where nullif(trim("SUBURB_NAME"),'') is not null

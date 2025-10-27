select
  trim("LGA_CODE_2016")::text as lga_code_2016,
  nullif(trim("Tot_P_M"),'')::int as tot_p_m,
  nullif(trim("Tot_P_F"),'')::int as tot_p_f,
  nullif(trim("Tot_P_P"),'')::int as tot_p_p,
  *
from {{ source('bronze', 'census_g01_raw') }}

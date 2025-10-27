with src as (
  select * from {{ source('bronze', 'airbnb_2020_05_raw') }}
)
select
  trim("LISTING_ID")::text                     as listing_id,
  trim("SCRAPE_ID")::text                      as scrape_id,

  case
    when trim("SCRAPED_DATE") ~ '^\d{4}-\d{2}-\d{2}$'
      then trim("SCRAPED_DATE")::date
    when trim("SCRAPED_DATE") ~ '^\d{1,2}/\d{1,2}/\d{4}$'
      then to_date(trim("SCRAPED_DATE"), 'DD/MM/YYYY')
    else null
  end as scraped_date,

  trim("HOST_ID")::text                        as host_id,
  nullif(trim("HOST_NAME"),'')                 as host_name,

  case
    when trim("HOST_SINCE") ~ '^\d{4}-\d{2}-\d{2}$'
      then trim("HOST_SINCE")::date
    when trim("HOST_SINCE") ~ '^\d{1,2}/\d{1,2}/\d{4}$'
      then to_date(trim("HOST_SINCE"), 'DD/MM/YYYY')
    else null
  end as host_since,

  case lower(trim("HOST_IS_SUPERHOST"))
    when 't' then true when 'true' then true
    when 'y' then true when 'yes' then true
    else false end                            as host_is_superhost,
  nullif(trim("HOST_NEIGHBOURHOOD"),'')        as host_neighbourhood,
  nullif(trim("LISTING_NEIGHBOURHOOD"),'')     as listing_neighbourhood,
  nullif(trim("PROPERTY_TYPE"),'')             as property_type,
  nullif(trim("ROOM_TYPE"),'')                 as room_type,
  nullif(trim("ACCOMMODATES"),'')::int         as accommodates,
  nullif(regexp_replace(trim("PRICE"),'[^0-9\.]','','g'),'')::numeric(12,2) as price,
  case lower(trim("HAS_AVAILABILITY"))
    when 't' then true when 'true' then true
    when 'y' then true when 'yes' then true
    else false end                            as has_availability,
  nullif(trim("AVAILABILITY_30"),'')::int      as availability_30,
  nullif(trim("NUMBER_OF_REVIEWS"),'')::int    as number_of_reviews,
  nullif(trim("REVIEW_SCORES_RATING"),'')::int as review_scores_rating,
  nullif(trim("REVIEW_SCORES_ACCURACY"),'')::int as review_scores_accuracy,
  nullif(trim("REVIEW_SCORES_CLEANLINESS"),'')::int as review_scores_cleanliness,
  nullif(trim("REVIEW_SCORES_CHECKIN"),'')::int as review_scores_checkin,
  nullif(trim("REVIEW_SCORES_COMMUNICATION"),'')::int as review_scores_communication,
  nullif(trim("REVIEW_SCORES_VALUE"),'')::int as review_scores_value
from src

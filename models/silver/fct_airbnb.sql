-- Cumulative fact across all months; no date filtering
with
s as (select * from {{ ref('stg_airbnb') }}),
dn as (select * from {{ ref('dim_neighbourhood') }})
select
  s.listing_id,
  s.host_id,
  s.scraped_date,
  s.scrape_id,
  s.property_type,
  s.room_type,
  s.accommodates,
  s.price,
  s.has_availability,
  s.availability_30,
  s.number_of_reviews,
  s.review_scores_rating,
  s.review_scores_accuracy,
  s.review_scores_cleanliness,
  s.review_scores_checkin,
  s.review_scores_communication,
  s.review_scores_value,
  s.listing_neighbourhood,
  dn.lga_code as lga_code_from_suburb
from s
left join dn
  on lower(s.listing_neighbourhood) = lower(dn.suburb_name)

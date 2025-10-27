with src as (select * from {{ ref('stg_airbnb_2020_05') }})
select
  listing_id,
  host_id,
  property_type,
  room_type,
  accommodates,
  price,
  listing_neighbourhood,
  has_availability,
  availability_30,
  number_of_reviews,
  review_scores_rating,
  review_scores_accuracy,
  review_scores_cleanliness,
  review_scores_checkin,
  review_scores_communication,
  review_scores_value,
  scraped_date,
  scrape_id
from src
where listing_id is not null

{% snapshot listing_snapshot %}
{{
  config(
    target_schema='silver_snapshots',
    unique_key='listing_id',
    strategy='timestamp',
    updated_at='scraped_date'
  )
}}

-- Listing-level slowly changing dimension (SCD 2)
select
    l.listing_id,
    l.host_id,
    l.property_type,
    l.room_type,
    l.accommodates,
    l.price,
    l.listing_neighbourhood,
    l.has_availability,
    l.availability_30,
    l.number_of_reviews,
    l.review_scores_rating,
    l.review_scores_accuracy,
    l.review_scores_cleanliness,
    l.review_scores_checkin,
    l.review_scores_communication,
    l.review_scores_value,
    l.scraped_date
from {{ ref('dim_listing') }} l

{% endsnapshot %}

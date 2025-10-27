-- models/gold/dm_host_neighbourhood.sql
-- Gold view: monthly metrics by host_neighbourhood LGA
-- Uses SCD2 snapshot (listing_snapshot) so each row reflects the values valid at that time.

with listing_scd as (
    -- Snapshot of listings with SCD2 columns (dbt_valid_from / dbt_valid_to)
    select *
    from {{ ref('listing_snapshot') }}
),

asof_listings as (
    -- Keep the version that is valid at the snapshot's scraped_date
    select *
    from listing_scd l
    where l.scraped_date >= l.dbt_valid_from
      and (l.scraped_date < l.dbt_valid_to or l.dbt_valid_to is null)
),

map_neighbourhood_to_lga as (
    -- Map listing_neighbourhood (a suburb) to its LGA
    select
        l.listing_id,
        l.host_id,
        l.scraped_date,
        l.property_type,
        l.room_type,
        l.accommodates,
        l.price,
        l.has_availability,
        l.availability_30,
        l.number_of_reviews,
        l.review_scores_rating,
        l.listing_neighbourhood,
        dn.lga_code as host_neighbourhood_lga
    from asof_listings l
    left join {{ ref('dim_neighbourhood') }} dn
      on lower(l.listing_neighbourhood) = lower(dn.suburb_name)
),

metrics as (
    select
        host_neighbourhood_lga,
        date_trunc('month', scraped_date)::date as month_year,

        -- 1) number of distinct hosts
        count(distinct host_id)                                          as distinct_hosts,

        -- definition helpers
        -- active listing = has_availability = true
        -- stays for active listing = 30 - availability_30
        -- estimated revenue per active listing = stays * price
        avg(
            case when has_availability is true
                 then (30 - coalesce(availability_30, 0)) * coalesce(price, 0)
            end
        )                                                                as avg_estimated_revenue_per_active_listing,

        -- total estimated revenue per active listings / distinct hosts
        sum(
            case when has_availability is true
                 then (30 - coalesce(availability_30, 0)) * coalesce(price, 0)
            end
        ) / nullif(count(distinct host_id), 0)                           as estimated_revenue_per_host

    from map_neighbourhood_to_lga
    group by 1, 2
)

select *
from metrics
order by host_neighbourhood_lga, month_year

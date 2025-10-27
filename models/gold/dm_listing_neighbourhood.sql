-- models/gold/dm_listing_neighbourhood.sql
-- Gold view: monthly metrics by listing_neighbourhood
-- Uses SCD2 snapshot + host attributes

with listing_scd as (
    -- full SCD2 history of every listing
    select *
    from {{ ref('listing_snapshot') }}
),

asof_listings as (
    -- Keep the version valid at the scraped_date
    select *
    from listing_scd l
    where l.scraped_date >= l.dbt_valid_from
      and (l.scraped_date < l.dbt_valid_to or l.dbt_valid_to is null)
),

with_hosts as (
    -- bring host-level fields
    select
        l.*,
        h.host_is_superhost
    from asof_listings l
    left join {{ ref('dim_host') }} h
      on l.host_id = h.host_id
),

metrics as (
    select
        listing_neighbourhood,
        date_trunc('month', scraped_date)::date as month_year,

        /* ---------- METRICS REQUIRED ---------- */

        -- 1) Active listings rate =
        100.0 *
        sum(case when has_availability is true then 1 else 0 end)
        / nullif(count(*),0)                                                as active_listing_rate,

        -- 2) Prices (active only)
        min(case when has_availability is true then price end)              as min_active_price,
        max(case when has_availability is true then price end)              as max_active_price,
        percentile_cont(0.5)
            within group (order by case when has_availability is true then price end)
                                                                            as median_active_price,
        avg(case when has_availability is true then price end)              as avg_active_price,

        -- 3) Number of distinct hosts
        count(distinct host_id)                                             as distinct_hosts,

        -- 4) Superhost rate
        100.0 *
        count(distinct case when host_is_superhost then host_id end)
        / nullif(count(distinct host_id), 0)                                as superhost_rate,

        -- 5) Avg review score (active only)
        avg(case when has_availability is true then review_scores_rating end)
                                                                            as avg_review_rating,

        -- 8) Total stays (active only)
        sum(case when has_availability is true then (30 - availability_30) end)
                                                                            as total_stays,

        -- 9) Avg estimated revenue per active listing
        avg(case when has_availability is true
                 then (30 - availability_30) * coalesce(price,0)
            end)                                                            as avg_estimated_revenue

    from with_hosts
    group by 1,2
)

select *
from metrics
order by listing_neighbourhood, month_year

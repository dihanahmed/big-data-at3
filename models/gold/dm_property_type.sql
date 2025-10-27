-- models/gold/dm_property_type.sql
-- Gold view: monthly metrics by PROPERTY_TYPE

with listing_scd as (
    select * from {{ ref('listing_snapshot') }}
),

asof_listings as (
    select *
    from listing_scd l
    where l.scraped_date >= l.dbt_valid_from
      and (l.scraped_date < l.dbt_valid_to or l.dbt_valid_to is null)
),

with_hosts as (
    -- join to get host_is_superhost
    select
        l.*,
        h.host_is_superhost
    from asof_listings l
    left join {{ ref('dim_host') }} h
        on l.host_id = h.host_id
),

metrics as (
    select
        property_type,
        date_trunc('month', scraped_date)::date as month_year,

        -- 1) active listing rate
        100.0 *
        sum(case when has_availability then 1 else 0 end)
        / nullif(count(*),0)                                     as active_listing_rate,

        -- 2) Prices (active only)
        min(case when has_availability then price end)           as min_active_price,
        max(case when has_availability then price end)           as max_active_price,
        percentile_cont(0.5)
            within group (order by case when has_availability then price end)
                                                                 as median_active_price,
        avg(case when has_availability then price end)           as avg_active_price,

        -- 3) distinct hosts
        count(distinct host_id)                                  as distinct_hosts,

        -- 4) superhost rate
        100.0 *
        count(distinct case when host_is_superhost then host_id end)
        / nullif(count(distinct host_id),0)                      as superhost_rate,

        -- 5) average review (active only)
        avg(case when has_availability then review_scores_rating end)
                                                                 as avg_review_rating,

        -- 8) total stays
        sum(case when has_availability then (30 - availability_30) end)
                                                                 as total_stays,

        -- 9) estimated revenue
        avg(case when has_availability
                 then (30 - availability_30) * coalesce(price,0) end)
                                                                 as avg_estimated_revenue

    from with_hosts
    group by 1,2
)

select *
from metrics
order by property_type, month_year

with adapter as (

    select *
    from {{ ref('pinterest_ads__ad_adapter') }}

), grouped as (

    select 
        campaign_date,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        sum(spend) as spend,
        sum(clicks) as clicks, 
        sum(impressions) as impressions
    from adapter
    {{ dbt_utils.group_by(5) }}

)

select *
from grouped
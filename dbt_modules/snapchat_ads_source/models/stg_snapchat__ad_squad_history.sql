
with base as (

    select * 
    from {{ ref('stg_snapchat__ad_squad_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_snapchat__ad_squad_history_tmp')),
                staging_columns=get_ad_squad_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as ad_squad_id,
        campaign_id,
        name as ad_squad_name,
        _fivetran_synced
    from fields
),

most_recent as (

    select 
        *,
        row_number() over (partition by ad_squad_id order by _fivetran_synced desc) = 1 as is_most_recent_record
    from final

)

select * from most_recent

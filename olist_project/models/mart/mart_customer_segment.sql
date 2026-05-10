with order_history as (
    select
        customer_id, -- calculate the total orders, first and last purchase in customer level
        count(distinct order_id) total_orders,
        min(order_purchase_timestamp) first_purchase,
        max(order_purchase_timestamp) latest_purchase
    from {{ ref('int_orders_enriched') }}
    group by 1
),

-- find the latest date in the entire dataset to use as a reference
reference_date as (
    select max(latest_purchase) max_db_date from order_history
)

select
    h.*,
    case 
        when h.total_orders = 1 then 'New'
        -- use the max date from the DB instead of current_date
        when h.total_orders > 1 and h.latest_purchase >= (r.max_db_date - interval '6 months') then 'Returning'
        else 'Churned' -- mapping for customer segment 
    end as customer_segment
from order_history h
cross join reference_date r
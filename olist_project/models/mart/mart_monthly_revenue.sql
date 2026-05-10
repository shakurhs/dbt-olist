with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

--calculate revenue per month
monthly_aggregation as (
    select
        date_trunc('month', order_purchase_timestamp) revenue_month,
        sum(total_item_price) monthly_revenue,
        count(distinct order_id) total_orders
    from orders
    group by 1
),
-- add the previous month revenue column
final as (
    select
        *,
        lag(monthly_revenue) over (order by revenue_month) prev_month_revenue
    from monthly_aggregation
)
 
-- find the growth calculation
select
    *,
    round((monthly_revenue - prev_month_revenue) / nullif(prev_month_revenue, 0) * 100, 2)  mom_growth_rate
from final
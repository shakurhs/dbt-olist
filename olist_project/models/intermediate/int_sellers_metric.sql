with order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders_enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

/* join the order items staging with order enriched intermediate to find the total revenue, total orders,
average review score, and late deliivery rate*/
seller_aggregation as (
    select
        oi.seller_id,
        sum(oi.item_price) total_revenue,
        count(distinct oi.order_id) total_orders,
        avg(oe.avg_review_score) avg_seller_review_score,
        count(case when oe.is_late_delivery then 1 end)::float / count(distinct oi.order_id) late_delivery_rate
    from order_items oi
    left join orders_enriched oe on oi.order_id = oe.order_id
    group by 1
)

select * from seller_aggregation
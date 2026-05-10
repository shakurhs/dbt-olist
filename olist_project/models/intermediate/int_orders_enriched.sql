with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),
-- convert order_items table into order grain level
order_items as (
    select 
        order_id, 
        sum(item_price) total_item_price,
        sum(freight_value) total_freight_value
    from {{ ref('stg_order_items') }}
    group by 1
),

-- convert order_items table into order grain level
order_reviews as (
    select 
        order_id, 
        avg(review_score) avg_review_score
    from {{ ref('stg_order_reviews') }}
    group by 1
),

-- join the table of orders, order items, customer, and order reviews staging
enriched as (
    select
        o.*,
        c.customer_city,
        c.customer_state,
        oi.total_item_price,
        oi.total_freight_value,
        r.avg_review_score,
        (o.order_delivered_customer_date - o.order_estimated_delivery_date)  delivery_delay_days, --subtraction to find the delay days
        case 
            when o.order_delivered_customer_date > o.order_estimated_delivery_date then true 
            else false 
        end as is_late_delivery --mapping the late delivery in boolean value
    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join order_items oi on o.order_id = oi.order_id
    left join order_reviews r on o.order_id = r.order_id
)

select * from enriched
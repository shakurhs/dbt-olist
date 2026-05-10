with order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }} -- already joined with english names in staging
),

order_reviews as (
    select * from {{ ref('stg_order_reviews') }}
),
--join the product and order reviews table into order items table
product_joined as (
    select
        oi.product_id,
        p.category_name,
        oi.item_price,
        oi.order_id,
        r.review_score
    from order_items oi
    left join products p on oi.product_id = p.product_id
    left join order_reviews r on oi.order_id = r.order_id
),

--aggregate the total revenue, units sold, and review score for each product
product_metrics as (
    select
        product_id,
        category_name,
        sum(item_price) total_revenue,
        count(order_item_id) units_sold,
        avg(review_score) avg_review_score
    from product_joined
    group by 1, 2
)
--rank the prodduct based on overall and category name
select
    *,
    rank() over (partition by category_name order by total_revenue desc) category_revenue_rank,
    rank() over (order by total_revenue desc) overall_revenue_rank
from product_metrics
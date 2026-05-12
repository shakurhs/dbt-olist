with source as (
    select * from {{ source('olist', 'order_items') }}
),
--adjust the data type and handle null value in staging tier
renamed as (
    select
        order_id,
        customer_id,
        coalesce(order_status, 'unknown')  order_status,
        cast(order_purchase_timestamp as timestamp) purchased_at,
        cast(order_approved_at as timestamp) as approved_at,
        cast(order_delivered_carrier_date  as timestamp) delivered_to_carrier_at,
        cast(order_delivered_customer_date as timestamp) delivered_to_customer_at,
        cast(order_estimated_delivery_date as timestamp) estimated_delivery_at,
        cast(order_purchase_timestamp as date) as purchase_date,
        date_trunc('month', cast(order_purchase_timestamp as timestamp)) purchase_month,
        date_trunc('month', cast(order_purchase_timestamp as timestamp)) cohort_month
    from source
)

select * from renamed
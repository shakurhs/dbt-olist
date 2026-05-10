with source as (
    select * from {{ source('olist', 'orders') }}
),

--adjust the data type in staging tier
renamed as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        cast(price as numeric(12,2))  item_price,
        cast(freight_value as numeric(12,2)) freight_value,
        cast(price + freight_value as numeric(12,2)) item_gross_value,
        cast(shipping_limit_date as timestamp) shipping_limit_at
    from source
)

select * from renamed
with products as (
    select * from {{ source('olist', 'products') }}
),
--translate the product name into english version
translation as (
    select * from {{ source('olist', 'product_category_name_translation') }}
),
--adjust the data type and handle null value in staging tier
renamed as (
    select
        p.product_id,
        coalesce(t.product_category_name_english, p.product_category_name,'uncategorized') product_category,
        p.product_category_name product_category_pt,
        coalesce(p.product_name_lenght, 0) product_name_length,
        coalesce(p.product_description_lenght, 0) product_description_length,
        coalesce(p.product_photos_qty, 0) product_photos_qty,
        cast(coalesce(p.product_weight_g, 0) as numeric(10,2)) product_weight_g,
        cast(coalesce(p.product_length_cm, 0) as numeric(10,2)) product_length_cm,
        cast(coalesce(p.product_height_cm, 0) as numeric(10,2)) product_height_cm,
        cast(coalesce(p.product_width_cm, 0) as numeric(10,2)) product_width_cm
    from products p
    left join translation t
        on p.product_category_name = t.product_category_name
)

select * from renamed
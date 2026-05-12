with source as (
    select * from {{ source('olist', 'customers') }}
),

--adjust the data type and handle null value in staging tier
renamed as (
    select
        customer_id,
        customer_unique_id,
        coalesce(cast(customer_zip_code_prefix as varchar), 'unknown') zip_code_prefix,
        coalesce(customer_city,  'unknown') customer_city,
        coalesce(customer_state, 'XX') customer_state
    from source
)

select * from renamed
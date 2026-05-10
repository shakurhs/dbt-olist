with source as (
    select * from {{ source('olist', 'order_reviews') }}
),

--adjust the data type and handle null value in staging tier
renamed as (
    select
        review_id,
        order_id,
        cast(review_score as integer) review_score,
        coalesce(review_comment_title, '') review_title,
        coalesce(review_comment_message, '') review_message,
        cast(review_creation_date as timestamp) review_created_at,
        cast(review_answer_timestamp as timestamp) review_answered_at,
        case
            when cast(review_score as integer) <= 2 then true
            else false
        end as is_low_score --adding conditional to map the low score review on an order
    from source
)

select * from renamed
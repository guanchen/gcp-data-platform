-- Create table with only dinstinct rows
{{ 
    config(
        materialized='table',
        partitions_by={
            "field": "review_date",
            "date_type": "date",
            "granularity": "day"
            },
        ) 
    }}

SELECT * FROM {{ ref('deduplicated_raw_data') }}

-- Create table with only dinstinct rows
{{ config(materialized='table') }}

select distinct *
from {{ source('bq_dataset', 'raw_table') }}

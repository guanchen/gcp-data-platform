-- Test number of rows
-- Fails if number of rows is different than expected
select count(*) as nb_rows 
from {{ ref('deduplicated_raw_data') }}
having (nb_rows != {{ var('nb_rows') }})



with thedates as (
    select * 
    from {{ source("public2", "dimdate")}}
)
SELECT 
* 
from thedates


with thedates as (
    select * 
    from {{ source("dbo", "dates")}}
)
SELECT 
* 
from thedates
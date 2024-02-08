select 
    case
        when purchase between 0 and 24999.99 then 'Low'
        when purchase between 25000 and 49999.99 then 'Medium'
        when purchase between 50000 and 74999.99 then 'High'
        when purchase between 75000 and 100000.99 then 'Very High'
        else NULL
    end as purchase_group,
    case
        when cap < 1000000 then 'Small'
        when cap between 1000000 and 1000000000-1 then 'Medium'
        when cap between 1000000000 and 99999999999 then 'Large'
        when 1000000000 >= cap < 100000000000 then 'Large'
        else 'Huge'
    end as market_cap
from(
    select replace(purchase_price,'$')::double as purchase,
        case contains(market_cap,'M')
            when 1 then regexp_replace(market_cap,'[^\\d\\.]','')::double * 1000000
            else regexp_replace(market_cap,'[^\\d\\.]','')::double * 1000000000
        end as cap
        ,*
    from pd2023_wk08_01
    where market_cap != 'n/a'
) wk08_01

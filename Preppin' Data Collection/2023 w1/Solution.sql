with output1 as (
    select bank, sum(value) as value
    from(
        SELECT split_part(transaction_code,'-',0) as bank,value
        from pd2023_wk01
    ) bank_value
    group by bank
),
output2 as (
    select bank, online_or_in_person, day, sum(value) as value
    from (
        SELECT split_part(transaction_code,'-',0) as bank,
        dayname(to_date(split_part(transaction_date,' ',0),'dd/MM/yyyy')) as day,
        value,
        CASE online_or_in_person when '1' then 'Online' else 'In-person' end as Online_or_in_person
        from pd2023_wk01
    )bdo_value
    group by bank, online_or_in_person, day
    order by bank, day
),
output3 as (
    select bank, customer_code, sum(VALUE) as value
    from(
        select split_part(transaction_code,'-',0) as bank, customer_code, value
        from pd2023_wk01
    ) bc_value
    group by bank, customer_code
)

select *
from output1

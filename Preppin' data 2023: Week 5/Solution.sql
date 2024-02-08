with bank_ranked as (
    select rank() over(partition by transaction_date order by value desc) as bank_rank_per_month,*
    from (
        select bank_code,
            transaction_date,
            sum(value) as value
        from(
            select monthname(to_date(split_part(transaction_date,' ',1),'dd/MM/yyyy')) as transaction_date,
            split_part(transaction_code,'-',1) as Bank_code,
            transaction_code,
            value,
            customer_code,
            online_or_in_person
        from pd2023_wk01
        ) pd2023_wk01
        group by bank_code, transaction_date
        order by transaction_date
    ) pd2023_wk01
    order by transaction_date, bank_rank_per_month asc
),
rank_per_bank as (
    select bank_code,
        avg(BANK_RANK_PER_MONTH) as avg_rank_per_bank
    from bank_ranked
    group by bank_code
),
value_per_rank as (
    select bank_rank_per_month,
        avg(value) as Avg_Transaction_Value_per_Rank
    from bank_ranked
    group by bank_rank_per_month
)

select t1.transaction_date, 
    t1.bank_code as bank,
    t1.value,
    t1.bank_rank_per_month,
    Avg_Transaction_Value_per_Rank,
    avg_rank_per_bank
from bank_ranked t1
inner join rank_per_bank t2
on t1.bank_code = t2.bank_code
inner join value_per_rank t3
on t1.bank_rank_per_month = t3.bank_rank_per_month

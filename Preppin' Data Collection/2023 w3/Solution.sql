select transaction.Quarter, 
    transaction.Online_or_in_person, 
    value,
    target, 
    value-target as Variance_to_target
from (
    select quarter, online_or_in_person, sum(value) as value
    from(
        select transaction_code, 
            value,
            customer_code,
            case online_or_in_person when 1 then 'Online' else 'In-Person' end as ONLINE_OR_IN_PERSON,
            quarter(to_date(split_part(transaction_date,' ',1),'dd/MM/yyyy')) as quarter
        from pd2023_wk01
        where transaction_code like 'DSB%'
    ) transactions
    group by quarter, online_or_in_person
) transaction
inner join (
    select replace(quarter,'Q') as quarter, online_or_in_person, target
    from pd2023_wk03_targets
    unpivot(target for quarter in (Q1,q2,q3,q4))
) targets
on transaction.quarter = targets.quarter
and transaction.ONLINE_OR_IN_PERSON = targets.ONLINE_OR_IN_PERSON
order by quarter asc

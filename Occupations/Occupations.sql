with main as (
    select name, occupation,
        row_number() over(partition by occupation order by occupation asc, name asc) as col
    from (
        select name,
            case occupation
                when 'Doctor' then 1
                when 'Professor' then 2
                when 'Singer' then 3
                else 4
            end as occupation
        from OCCUPATIONS
    ) t1
)

select m1.name, m2.name, m3.name, m4.name
from (
    select * from main where occupation = 1
) m1
full join (
    select * from main where occupation = 2
) m2
on m1.col = m2.col
full join (
    select * from main where occupation = 3
) m3
on m1.col = m3.col or m2.col = m3.col
full join (
    select * from main where occupation = 4
) m4
on m1.col = m4.col or m2.col = m4.col or m3.col = m4.col
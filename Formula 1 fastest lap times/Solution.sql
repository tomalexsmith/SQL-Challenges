select FORENAME||' '||SURNAME as Driver, t.time_2021 as fastest_lap_2021, t.time_total as fastest_lap_all_time, zeroifnull(num_won.num_won) as times_won
from (
    select time_2021.*, time_total.time_total
    from (
    select driverid, max(l.FASTESTLAPSPEED) as time_2021
    from results l
    inner join races r
    on l.raceid = r.raceid
    where year = 2021
    and name like 'Monaco Grand Prix'
    group by driverid
    ) time_2021
    inner join (
        select driverid, max(l.FASTESTLAPSPEED) as time_total
        from results l
        inner join races r
        on l.raceid = r.raceid
        and name like 'Monaco Grand Prix'
        group by driverid
    ) time_total
    on time_2021.driverid = time_total.driverid
) t
left join drivers d
on t.driverid = d.driverid
left join (
    select driverid, count(driverid) as num_won
    from races
    join results
    on races.raceid = results.raceid
    where name = 'Monaco Grand Prix'
    and position = 1
    group by driverid
) num_won
on t.driverid = num_won.driverid
order by time_total desc



-- with submissions_per_date as (
--     select
--         h.hacker_id,
--         max(name) as name,
--         submission_date,
--         count(submission_id) as submissions
--     from hackers as h
--     join submissions s on h.hacker_id = s.hacker_id
--     where submission_date >= '2016-03-01' and submission_date <= '2016-03-15'
--     group by submission_date, h.hacker_id
-- ),
-- count_per_day as (
--     select submission_date, count(distinct h.hacker_id) as count
--     from hackers as h
--     join submissions s on h.hacker_id = s.hacker_id
--     where submission_date >= '2016-03-01' and submission_date <= '2016-03-15'
--     group by submission_date
-- )

-- select 
--     final_out.submission_date, 
--     cpd.count,
--     final_out.hacker_id,
--     name
-- from (
--     select submission_date, max(submissions) as submissions, min(hacker_id) as hacker_id
--     from (
--         select s_max.*, s_date.hacker_id, name
--         from (
--             select 
--                 submission_date,
--                 max(submissions) as submissions
--             from submissions_per_date
--             group by submission_date
--         ) s_max
--         join submissions_per_date as s_date
--             on s_max.submissions = s_date.submissions and s_max.submission_date = s_date.submission_date
--     ) out_id
--     group by submission_date
-- ) final_out
-- join (
--     select name, hacker_id
--     from submissions_per_date 
--     group by hacker_id, name
-- ) as s_date on final_out.hacker_id = s_date.hacker_id
-- join count_per_day as cpd on final_out.submission_date = cpd.submission_date
-- order by submission_date asc

select * 
from (
    select row_number() over(partition by hacker_id order by submission_date) as i, *
    from (
        select curr.hacker_id, curr.submission_date, 
            case 
               when prev.submission_date = dateadd(day,-1,curr.submission_date) or curr.submission_date = '2016-03-01' then 'continued'
            end cont
        from (
            select h.hacker_id, submission_date, row_number() over(partition by h.hacker_id order by submission_date) as i
            from hackers as h
            join submissions s on h.hacker_id = s.hacker_id
            where submission_date >= '2016-03-01' and submission_date <= '2016-03-15'
            group by submission_date, h.hacker_id
        ) curr
        left join (
            select h.hacker_id, submission_date, row_number() over(partition by h.hacker_id order by submission_date) as i
            from hackers as h
            join submissions s on h.hacker_id = s.hacker_id
            where submission_date >= '2016-03-01' and submission_date <= '2016-03-15'
            group by submission_date, h.hacker_id
        ) prev on curr.i = prev.i + 1 and curr.hacker_id = prev.hacker_id
    ) t_cont
    where cont is not null
) t_index
where (i = 1 and submission_date = '2016-03-01') or i != 1

with results as (
    select *
    FROM (
        SELECT Student_id,
            subject,
            t.range
        FROM(
            SELECT Student_id, subject, grades, ntile(4) over(partition by subject order by grades asc) as number
            FROM (
                SELECT *
                FROM PD2023_WK23_RESULTS
                UNPIVOT(Grades for subject in (ENGLISH,ECONOMICS,PSYCHOLOGY))
            ) as Results_tiled
        ) as r,
        lateral (select * from PD2023_WK24_TILES where r.number = PD2023_WK24_TILES.number) as t
    ) as results
    pivot(min(range) for subject in ('ENGLISH','ECONOMICS','PSYCHOLOGY'))
)

select full_name, trim(class) AS CLASS,"'ENGLISH'" as english, "'ECONOMICS'" AS ECONOMICS, "'PSYCHOLOGY'" AS PSYCHOLOGY
from PD2023_WK23_STUDENT_INFO as i
left join results
on i.x_student_id = results.Student_id
where class = '9A' OR class = '9B'
























'

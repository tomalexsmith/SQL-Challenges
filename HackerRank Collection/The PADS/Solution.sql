select output from (
    -- Get person name with first letter of occupation
    select name + '(' + left(occupation,1) + ')' as output,
        -- Create fields to sort final table by
        1 as sort1,
        row_number() over(order by name) as sort2
    from occupations
    group by name, occupation

    UNION ALL
  
    -- Get a count of people per occupation, and construct the required sentence
    select 'There are a total of ' + cast(count(*) as varchar) + ' ' + lower(occupation) + 's.'  as output,
        -- Create fields to sort final table by
        2 as sort1,
        row_number() over(order by count(*), occupation) as sort2
    from occupations
    group by occupation
) t_out
order by sort1, sort2

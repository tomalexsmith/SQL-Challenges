select c.company_code,                          -- companycode
    founder,                                    -- founder name
    count(distinct e.lead_manager_code),        -- total number of lead managers
    count(distinct e.senior_manager_code),      -- total number of senior managers
    count(distinct e.manager_code),             -- total number of managers
    count(distinct e.employee_code)             -- total number of employees
from company as c
join Employee as e
on c.company_code = e.company_code
group by c.company_code, founder
order by c.company_code

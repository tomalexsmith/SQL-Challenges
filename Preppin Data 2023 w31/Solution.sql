with EMPLOYEE_LOOKUP as (
    SELECT *
    FROM(
        SELECT DISTINCT CONCAT(EMPLOYEE_ID,GUID) as combinedID, employee_id, guid
        FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK31_MONTHLY
        UNION
        SELECT DISTINCT CONCAT(EMPLOYEE_ID,GUID) as combinedID, employee_id, guid
        FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK31_EMPLOYEE
    ) as TEMP_EMPLOYEE_LOOKUP
    where combinedID is not null
),
Employees as (
    select distinct *
    from(
        select
        CASE 
            WHEN main.employee_id IS NULL THEN employee_lookup.employee_id
            ELSE main.employee_id 
        END as employee_id, main.GUID, main.FIRST_NAME, main.LAST_NAME, main.DATE_OF_BIRTH, main.NATIONALITY, main.GENDER, main.EMAIL, main.HIRE_DATE, main.LEAVE_DATE
        from(
            select main.EMPLOYEE_ID, 
            CASE 
                WHEN main.GUID IS NULL THEN employee_lookup.GUID
                ELSE main.GUID 
            END as GUID,
            main.FIRST_NAME, main.LAST_NAME, main.DATE_OF_BIRTH, main.NATIONALITY, main.GENDER, main.EMAIL, main.HIRE_DATE, main.LEAVE_DATE
            from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK31_EMPLOYEE as MAIN
            LEFT JOIN EMPLOYEE_LOOKUP
            ON MAIN.employee_id = EMPLOYEE_LOOKUP.employee_id
                WHERE FIRST_NAME IS NOT NULL
        ) as main
        left join EMPLOYEE_LOOKUP
        on main.GUID = EMPLOYEE_LOOKUP.GUID
        where main.first_name is not null
    ) as employees
    order by employee_id asc
),
Monthly as (
    select distinct *
    from(
        select main.DC_NBR, main.MONTH_END_DATE, 
            CASE 
                WHEN main.EMPLOYEE_ID IS NULL THEN employee_lookup.EMPLOYEE_ID
                ELSE main.EMPLOYEE_ID 
            END as EMPLOYEE_ID, main.guid,
        main.HIRE_DATE, main.LEAVE_DATE
        from(
            select main.DC_NBR, main.MONTH_END_DATE, main.EMPLOYEE_ID, 
            CASE 
                WHEN main.GUID IS NULL THEN employee_lookup.GUID
                ELSE main.GUID 
            END as GUID,
            main.HIRE_DATE, main.LEAVE_DATE
            from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK31_MONTHLY as MAIN
            LEFT JOIN EMPLOYEE_LOOKUP
            ON MAIN.employee_id = EMPLOYEE_LOOKUP.employee_id
                WHERE HIRE_DATE IS NOT NULL
        ) as main
        left join EMPLOYEE_LOOKUP
        on main.GUID = EMPLOYEE_LOOKUP.GUID
        where main.HIRE_DATE is not null
    ) as employees
    order by employee_id asc
)

select * from employees

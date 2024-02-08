with main_output as (
    select to_date(split_part(flight_details,'//',1),'yyyy-mm-dd') as "Date",
        split_part(flight_details,'//',2) as "Flight Number",
        split_part(split_part(flight_details,'//',3),'-',1) as "From",
        split_part(split_part(flight_details,'//',3),'-',2) as "To",
        split_part(flight_details,'//',4) as "Class",
        round(split_part(flight_details,'//',5),2) as "Price",
        case flow_card 
            when 1 then 'Yes'
            else 'No'
        end as "Flow Card?",
        bags_checked as "Bags Checked",
        meal_type as "Meal Type"
    from pd2024_wk01
),
output_1 as (
    select *
    from main_output
    where "Flow Card?" = 'Yes'
),
output_2 as (
    select *
    from main_output
    where "Flow Card?" = 'No'
)

select *
from output_1

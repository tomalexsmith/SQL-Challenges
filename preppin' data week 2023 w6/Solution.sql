with METRIC_SCORE as (
    SELECT Customer_id, metric, split_part(rating,' ',1) as mobile_app_rating, split_part(rating,' ',2) as Online_interface_rating
    FROM (
        SELECT customer_id, mobile_app___ease_of_access||' '||online_interface___ease_of_access as ease_of_access,
            mobile_app___ease_of_use||' '||online_interface___ease_of_use as ease_of_use,
            mobile_app___likelihood_to_recommend||' '||online_interface___likelihood_to_recommend as likelihood_to_recommend,
            mobile_app___navigation||' '||online_interface___navigation as navigation,
            mobile_app___overall_rating||' '||online_interface___overall_rating as overall_rating
        FROM PD2023_WK06_DSB_CUSTOMER_SURVEY
    ) survey
    UNPIVOT(rating for Metric in (ease_of_access,ease_of_use,likelihood_to_recommend,navigation,overall_rating))
    WHERE Metric != 'OVERALL_RATING'
),
Customer_category as (
    SELECT AVG_DIFF,
    CASE 
        WHEN -1 < AVG_DIFF AND AVG_DIFF < 1 THEN 'Neutral'
        WHEN AVG_DIFF <= -2 THEN 'Online Interface Superfan'
        WHEN AVG_DIFF >= 2 THEN 'Mobile App Superfan'
        WHEN AVG_DIFF <= -1 THEN 'Mobile App Fan'
        WHEN AVG_DIFF >= 1 THEN 'Online Interface Fan'
        ELSE NULL
    END as Category
    from (
        select customer_id,
            avg(mobile_app_rating) as avg_mobile_app_rating,
            avg(online_interface_rating) as avg_online_interface_rating,
            avg(mobile_app_rating) - avg(online_interface_rating) as avg_diff
        from metric_score
        group by customer_id
    )
)

select category as "Category", round(count/total * 100,1)::string||'%' as "% of Total"
from (
    select category, count(avg_diff) as count
    from customer_category
    group by category
) as category_count
inner join(
    select count(avg_diff) as total
    from customer_category
) as total_count

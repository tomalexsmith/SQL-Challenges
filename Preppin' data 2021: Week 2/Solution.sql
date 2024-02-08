with Sales_brand_type as (
    select Brand, Bike_type, sum(quantity) as Quantity_sold,
        sum(total) as Order_Value,
        round(avg(value_per_bike),1) as Average_Value_Sold_per_Brand_Type
    from(
        select regexp_replace(model,'[0-9/]','') as Brand,
            value_per_bike*quantity as total,
            *
        from pd2021_wk02_bike_sales
    ) sales
    group by Brand, Bike_type
),
shipping_brand_store as(
    select brand, store,
        sum(QUANTITY) as Total_Quantity_Sold,
        sum(total) as Total_Order_Value,
        round(avg(days_to_ship),1) as average_days_to_ship
    from (
        select datediff('day',
            to_date(order_date,'dd/MM/yyyy'),
            to_date(SHIPPING_DATE,'dd/MM/yyyy')) as days_to_ship,
            regexp_replace(model,'[0-9/]','') as Brand,
            value_per_bike*quantity as total,
            *
        from pd2021_wk02_bike_sales
    ) shipping
    group by brand, store
)

select *
from Sales_brand_type

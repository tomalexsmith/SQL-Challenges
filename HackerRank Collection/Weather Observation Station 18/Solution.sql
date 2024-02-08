/*
Manhattan Distance formula:
|x1 - x2| + |y1 - y2|
*/

select round(abs(x1-x2) + abs(y1-y2),4)
from(
    select min(LAT_N) as x1,
        min(LONG_W) as y1,
        max(LAT_N) as x2,
        max(LONG_W) as y2
    from station
) s

/*
Build out every path in the binary tree
*/

with tree as (
    select bst.n as tr1, 
        bst.p as tr2, 
        bst_2.p as tr3, 
        bst_3.p as tr4
    from bst
    left join bst as bst_2 on bst.p = bst_2.n
    left join bst as bst_3 on bst_2.p = bst_3.n
    left join bst as bst_4 on bst_3.p = bst_4.n
    where bst_4.p is null
        and bst_3.p is not null
        and bst_2.p is not null
)

/*
Leaf = Left Join tree.tr1 on bst.n
Inner = Left Join tree.tr2 and tree.tr3 on bst.n
Parent = Left Join tree.tr4 on bst.n
*/

select n, min(type)
from (
    select bst.n,
        case 
            when leaf.tr1 is not null then 'Leaf' 
            when innerT.tr2 is not null then 'Inner'
            else 'Root'
        end as type
    from bst
    left join tree as leaf on bst.n = leaf.tr1
    left join tree as innerT on bst.n in (innerT.tr2,innerT.tr3)
) as node_types
group by n
order by n asc

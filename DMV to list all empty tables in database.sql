with empty_tables as (
select OBJECT_NAME(object_id) tbl_name , 
sum(row_count) record_count
from sys.dm_db_partition_stats
where index_id in (0 , 1) 
group by object_id )

select tbl_name , record_count 
from empty_tables 
where record_count = 0

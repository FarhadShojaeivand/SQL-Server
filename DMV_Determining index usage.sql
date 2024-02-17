select OBJECT_NAME(ddius.[object_id] , ddius.database_id) as [object_name] ,
ddius.index_id , 
ddius.user_seeks , 
ddius.user_scans , 
ddius.user_lookups , 
ddius.user_seeks + ddius.user_scans + ddius.user_lookups  as user_reads , 
ddius.user_updates as user_writes , 
ddius.last_user_scan , 
ddius.last_user_update 
from sys.dm_db_index_usage_stats ddius
where ddius.database_id > 4 
and OBJECTPROPERTY(ddius.object_id , 'IsUserTable') = 1 
and ddius.index_id > 0 
order by ddius.user_scans desc

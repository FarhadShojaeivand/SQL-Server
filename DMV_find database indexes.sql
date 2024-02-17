select DB_NAME(ddius.[database_id]) as [database_name] , 
OBJECT_NAME(ddius.[object_id] , DB_ID('test')) as table_name , 
asi.[name] as index_name , 
ddius.user_seeks + ddius.user_scans + ddius.user_lookups as user_reads
from sys.dm_db_index_usage_stats ddius
inner join test.sys.indexes asi
on ddius.[object_id] = asi.[object_id]
and ddius.index_id = asi.index_id

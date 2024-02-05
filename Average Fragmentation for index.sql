select avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats (db_id(N'<db_name>') , object_id(N'<tbl_name>') , 1 , null , 'LIMITED')

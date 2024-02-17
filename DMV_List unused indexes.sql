select OBJECT_NAME(i.[object_id]) as [Table_name] , 
i.name 
from sys.indexes as i 
inner join sys.objects as o 
on i.[object_id] = o.[object_id]
where i.index_id not in (select ddius.index_id
from sys.dm_db_index_usage_stats as ddius 
where ddius.[object_id] = i.[object_id] 
and i.index_id = ddius.index_id 
and database_id = DB_ID() )
and o.[type] = 'U' 
order by OBJECT_NAME(i.[object_id]) asc 

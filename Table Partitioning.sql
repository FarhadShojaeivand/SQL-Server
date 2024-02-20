create table [dbo].[tbl_part] (
id int primary key identity(1,1) , 
name nvarchar(50) , 
create_date date )

-- insert random values in table with RedGate.SQLDataGenerator

select year([create_date]) , COUNT(*) as total_rows
from [dbo].[tbl_part]
group by year([create_date])

-- 2024	88236
-- 2023	630847
-- 2022	631386
-- 2021	629385

-- create 4 separate folders
-- F:\drive a
-- F:\drive b
-- F:\drive c
-- F:\drive d

-- create 4 filegroups for each year
use master 
go 

alter database [partition_test]
add filegroup [drive a] 
go 

alter database [partition_test]
add filegroup [drive b] 
go 

alter database [partition_test]
add filegroup [drive c] 
go 

alter database [partition_test]
add filegroup [drive d] 
go 

-- there is no partition yet
use [partition_test]
go 
select o.name objectname , i.name indexname , partition_id , partition_number , [rows] 
from sys.partitions p 
inner join sys.objects o on o.object_id = p.object_id 
inner join sys.indexes i on i.object_id = p.object_id and p.index_id = i.index_id
where o.name like '%tbl_part%'
-- tbl_part	PK__tbl_part__3213E83FC8D08DE2	72057594043170816	1	1979854

-- whithin those four folders ( drive a , drive b , drive c , drive d), create 4 separate data files (.ndf) for each year in table





















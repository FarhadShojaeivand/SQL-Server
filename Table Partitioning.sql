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
use master
go 
alter database [partition_test]
add file (name = N'Y2021' ,
filename = N'F:\drive a\Y2021.ndf' ,
size = 4096KB , 
filegrowth = 1024KB )
to filegroup [drive a]
go 

alter database [partition_test]
add file (name = N'Y2022' ,
filename = N'F:\drive b\Y2022.ndf' ,
size = 4096KB , 
filegrowth = 1024KB )
to filegroup [drive b]
go 

alter database [partition_test]
add file (name = N'Y2023' ,
filename = N'F:\drive c\Y2023.ndf' ,
size = 4096KB , 
filegrowth = 1024KB )
to filegroup [drive c]
go 

alter database [partition_test]
add file (name = N'Y2024' ,
filename = N'F:\drive d\Y2024.ndf' ,
size = 4096KB , 
filegrowth = 1024KB )
to filegroup [drive d]
go 

-- at this point we have created the containers and files for the table to be partitioned

-- create partition function and scheme
use [partition_test]
go
Begin transaction 
create partition function [function_tbl_part](date)
as range left 
for values (N'2021-12-31' , N'2022-12-31' , N'2023-12-31')

create partition scheme [scheme_tbl_part] 
as partition [function_tbl_part]
to([drive a] , [drive b] , [drive c] , [drive d])

alter table [dbo].[tbl_part] drop constraint [PK__tbl_part__3213E83FC8D08DE2]

alter table [dbo].[tbl_part] add constraint [PK__tbl_part__3213E83FC8D08DE2] primary key nonclustered(id asc)
with (pad_index = off , statistics_norecompute = off , sort_in_tempdb = off , ignore_dup_key = off , online = off , allow_row_locks = on 
, allow_page_locks = on)

create clustered index [ClusteredIndex_on_scheme_tbl_part] on [dbo].[tbl_part]([create_date])
with (sort_in_tempdb = off , drop_existing = off , online = off) on [scheme_tbl_part]([create_date])

drop index [ClusteredIndex_on_scheme_tbl_part] on [dbo].[tbl_part]

commit transaction

-- verify partition creation
use [partition_test]
go 
select o.name objectname , i.name indexname , partition_id , partition_number , [rows] 
from sys.partitions p 
inner join sys.objects o on o.object_id = p.object_id 
inner join sys.indexes i on i.object_id = p.object_id and p.index_id = i.index_id
where o.name like '%tbl_part%'
-- tbl_part	NULL	72057594043826176	1	629385
-- tbl_part	NULL	72057594043891712	2	631386
-- tbl_part	NULL	72057594043957248	3	630847
-- tbl_part	NULL	72057594044022784	4	88236
-- tbl_part	PK__tbl_part__3213E83FC8D08DE2	72057594044088320	1	1979854

-- insert data to verify direction of data to partition
use [partition_test]
go 
  
insert into [dbo].[tbl_part](name , create_date) 
values('farhad' , '2024-02-20')
go

-- 
use [partition_test]
go 
select o.name objectname , i.name indexname , partition_id , partition_number , [rows] 
from sys.partitions p 
inner join sys.objects o on o.object_id = p.object_id 
inner join sys.indexes i on i.object_id = p.object_id and p.index_id = i.index_id
where o.name like '%tbl_part%'
-- tbl_part	NULL	72057594043826176	1	629385
-- tbl_part	NULL	72057594043891712	2	631386
-- tbl_part	NULL	72057594043957248	3	630847
-- tbl_part	NULL	72057594044022784	4	88237
-- tbl_part	PK__tbl_part__3213E83FC8D08DE2	72057594044088320	1	1979854

select * from [dbo].[tbl_part]
where $partition.[function_tbl_part]([create_date]) = 4




















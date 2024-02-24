-- source instance
use master 
go
--configure a contained database via sp_configure : sp_configure

--set option on
sp_configure 'contained database authentication' , 1 
go 
reconfigure 
go

sp_configure

-- create a contained database. same as creating a reqular database
create database contained_db
	containment = partial
	on primary
  ( name = N'contained_db' , 
  filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\contained_db.mdf' ,
  size = 4096KB,
  filegrowth = 1024KB)
  log on 
 (name = N'contained_db_log' ,
  filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\contained_db_log.ldf' ,
  size = 1024KB , 
  filegrowth = 10%)
go

-- create a aql user to access the contained database. 
use [contained_db]
go
create user farhad with password = N'farhad'
go

alter authorization on schema::db_owner to farhad
go


use [contained_db]
go
select name , type_desc , authentication_type_desc
from sys.database_principals 
-- farhad	SQL_USER	DATABASE

-- backup contained_db
use master 
go
backup database [contained_db]
to disk = N'F:\contained_db.bak'
with copy_only , 
noformat ,
noinit,
name = N'contained_db-full database backup' ,
skip ,
norewind , 
nounload,
stats = 10 
go

  
-- target instance

--configure a contained database via sp_configure : sp_configure

--set option on
sp_configure 'contained database authentication' , 1 
go 
reconfigure 
go

-- restore database 
use master 
go 
restore database [contained_db]
from disk = N'F:\contained_db.bak'
with file = 1 ,
move N'contained_db'
to N'F:\sql server instance02\MSSQL15.MSSQLSERVER02\MSSQL\DATA\contained_db.mdf',
move N'contained_db_log'
to N'F:\sql server instance02\MSSQL15.MSSQLSERVER02\MSSQL\DATA\contained_db_log.ldf',
nounload 
go

-- find sql login orphans
use contained_db
exec sp_change_users_login 'Report';

-- now we can connect to sql server with contained user 'farhad' 
-- notice this user has no login


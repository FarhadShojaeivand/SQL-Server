use master 
go

alter database <db_name>
set single_user with rollback immediate
go

-----

use master 
go 

exec master.dbo.sp_detach_db @dbname = N'<db_name>' , @skipchecks = 'false'

-----

use master
go 

create database test on 
(filename = N'<location>\<data_file_name.mdf>'),
(filename = N'<location>\<log_file_name.ldf>')
for attach
go

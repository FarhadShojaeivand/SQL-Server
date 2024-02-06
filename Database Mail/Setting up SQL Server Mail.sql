sp_configure  -- show the options for server properties 
go 

sp_configure 'Show Advanced' , 1  -- set the options on for server properties
go
reconfigure
go

sp_configure
go

sp_configure 'Database Mail XPs' , 1  -- configure the database mail
go
reconfigure
go

sp_configure
go 

sp_configure 'Show Advanced' , 0  -- set the options off for server properties
go
reconfigure
go

sp_configure
go 

-- Database Mail keeps copies of outgoing e-mail messages and other information about mail
-- and displays them in msdb database using the following scripts:


use msdb 
go
select * from sysmail_server
select * from sysmail_allitems
select * from sysmail_sentitems
select * from sysmail_unsentitems
select * from sysmail_faileditems
select * from sysmail_mailitems
select * from sysmail_log

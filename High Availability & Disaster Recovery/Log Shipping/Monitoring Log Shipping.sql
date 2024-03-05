--1. SQL Server Reports (GUI)
-- To view reports via the SSMS, right click the server > reports > standard reports > Log shipping Status

--2. Stored procedures
--EXECUTE ON PRIMARY
Use master
Go
sp_help_log_shipping_monitor

Use master
Go
sp_help_log_shipping_monitor_primary
@primary_server =  'SERVER1', 
@primary_database = 'source_db'    

SELECT * 
FROM msdb.dbo.sysjobs 
WHERE category_id = 6

SELECT * 
FROM [msdb].[dbo].[sysjobhistory]
WHERE [message] like '%Operating system error%'

SELECT * 
FROM [msdb].[dbo].[log_shipping_monitor_error_detail]
WHERE [message] like '%Operating system error%'

EXEC xp_readerrorlog 0,1,"Backup", Null

--3. Stored procedures
--run on secondary server
Use master
Go
sp_help_log_shipping_monitor

Use master
Go
sp_help_log_shipping_monitor_secondary
@secondary_server =  'SERVER2',
@secondary_database =  'source_db'

SELECT * 
FROM msdb.dbo.sysjobs 
WHERE category_id = 6

SELECT * 
FROM [msdb].[dbo].[sysjobhistory]
WHERE [message] like '%Operating system error%'

SELECT * 
FROM [msdb].[dbo].[log_shipping_monitor_error_detail]
WHERE [message] like '%Operating system error%'

EXEC xp_readerrorlog 0,1,"Restore",Null

--4. Tables in MSDB database
SELECT * 
FROM msdb.dbo.sysjobs 
WHERE category_id = 6

SELECT * 
FROM [msdb].[dbo].[sysjobhistory]
WHERE [message] like '%Operating system error%'

SELECT * 
FROM [msdb].[dbo].[log_shipping_monitor_error_detail]
WHERE [message] like '%Operating system error%'

--5. SQL Server Error Log
Select * from sys.sysmessages 
Where description like '%shipping%' 
--Can execute on both servers
EXEC xp_readerrorlog 0,1,"Error",Null
  
EXEC xp_readerrorlog 0,1,"Shipping",Null

-- execute on Primary server
EXEC xp_readerrorlog 0,1,"Backup",Null

-- execute on secondary servers
EXEC xp_readerrorlog 0,1,"Restore",Null






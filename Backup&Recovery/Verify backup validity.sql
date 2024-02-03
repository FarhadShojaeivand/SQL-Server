-- verify that the database bachup is valid 

declare @backupSetId as int 
select @backupSetId = position 
from msdb..backupset 
where database_name = N'test'
and backup_set_id = (select MAX(backup_set_id) 
from msdb..backupset where database_name = N'test')
if @backupSetId is null 
begin 
raiserror(N'Verify failed. Backup information for database ''BackupDatabase'' not found.' , 16 , 1)
end 
restore verifyonly
from 
disk = N'<location>\<backup_file_name>'
with file = @backupSetId
go

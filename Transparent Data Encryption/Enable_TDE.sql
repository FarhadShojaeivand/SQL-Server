
-- Enable TDE on the source SQL Server
use master
go
create master key encryption 
by password = 'password';


create certificate TDE_cert with subject = 'TDE_Certificate'

select name , pvt_key_encryption_type_desc from sys.certificates
where  name = 'TDE_Cert'

backup certificate TDE_cert to file = '...\dbtest_TDE_CERT.certbak'
with private key (
file = '...\dbtest_TDE_CERT.pkbak' , 
encryption by password = 'password')

use Your_DB;
go 
create database encryption key 
 with algorithm = AES_128
encryption by server certificate TDE_cert

alter database Your_DB set encryption on

use master 
go 
select name , is_encrypted from sys.databases

-- Enable TDE on the target SQL Server 
use master
go
create master key encryption 
by password = 'password';

create certificate TDE_cert
from file = '...\Backup\dbtest_TDE_CERT.certbak'
with private key ( file = '...\dbtest_TDE_CERT.pkbak' ,  
decryption by password = 'password');
go

-- Now we can restore the source SQL Server backups at the target SQL Server


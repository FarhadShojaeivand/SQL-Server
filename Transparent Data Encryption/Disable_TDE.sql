alter database db_test set encryption off

use db_test
go 
drop database encryption key 

use master
go 
drop certificate TDE_cert ;

drop master key;

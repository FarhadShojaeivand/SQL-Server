DECLARE @tbl_name NVARCHAR(200)

DECLARE db_cursor CURSOR FOR 
SELECT [name] FROM sys.tables
WHERE name LIKE '##ETL_%'

OPEN db_cursor 
FETCH NEXT FROM db_cursor INTO @tbl_name

WHILE @@FETCH_STATUS = 0 
BEGIN 
    DECLARE @sql NVARCHAR(MAX)
    SET @sql = 'DROP TABLE ' + QUOTENAME(@tbl_name)
    EXEC sp_executesql @sql

    FETCH NEXT FROM db_cursor INTO @tbl_name
END

CLOSE db_cursor 
DEALLOCATE db_cursor

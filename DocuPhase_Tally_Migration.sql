-- backup databases on TALISYNSQL
BACKUP DATABASE [espeed]
TO DISK = 'G:\TALISYNSQL\DONOTDELETE\espeed_FINAL.bak' WITH STATUS = 5, INIT, FORMAT;
BACKUP DATABASE [espeedArchive]
TO DISK = 'G:\TALISYNSQL\DONOTDELETE\espeedArchive_FINAL.bak' WITH STATUS = 5, INIT, FORMAT;
BACKUP DATABASE [iSynergyProd]
TO DISK = 'G:\TALISYNSQL\DONOTDELETE\iSynergyProd_FINAL.bak' WITH STATUS = 10, INIT, FORMAT;
BACKUP DATABASE [Progression]
TO DISK = 'G:\TALISYNSQL\DONOTDELETE\Progression_FINAL.bak' WITH STATUS = 10, INIT, FORMAT;

-- backup database on TALISYNSQL02
BACKUP DATABASE [ABLE_iSynergyResource]
TO DISK = 'J:\Backups\TALISYNSQL02\DONOTDELETE\ABLE_iSynergyResource_FINAL.bak' WITH STATUS = 10, INIT, FORMAT;

-- copy backup files from local servers to JAXSQLFS01

-- restore databases
-- INTSQLCN01\Savings
RESTORE DATABASE [espeed]
FROM DISK = '\\JAXSQLFS01\ProdSQLBackups\DONOTDELETE\espeed_FINAL.bak'

-- create the Forms database
-- INTSQLCN01\Savings
-- script provided by Gustavo
CREATE DATABASE [Forms];
-- execute script


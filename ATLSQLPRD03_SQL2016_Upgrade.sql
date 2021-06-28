/***************************
	Prior to maintenance
****************************/
-- (A) Copy install files to each server in the cluster prior to starting!!!
-- (B) Verify WSFC owner and move to primary replica for AG

/*****************************
	Maintenance window
******************************/
-- (1) Send email to LOB stating maintenance is about to begin
-- Use "VeritecMaintenance" distribution list

-- (2) Modify AG failovers to "manual" (all instances)
-- FLCC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP [FloridaCC_AG]
MODIFY REPLICA ON N'ATLSQLDBCN08\FLCC' WITH (FAILOVER_MODE = MANUAL);
GO
ALTER AVAILABILITY GROUP [FloridaCC_AG]
MODIFY REPLICA ON N'ATLSQLDBCN07\FLCC' WITH (FAILOVER_MODE = MANUAL);
SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas;
GO

-- SC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP [SouthCarolina_AG]
MODIFY REPLICA ON N'ATLSQLDBCN08\SC' WITH (FAILOVER_MODE = MANUAL);
GO
ALTER AVAILABILITY GROUP [SouthCarolina_AG]
MODIFY REPLICA ON N'ATLSQLDBCN07\SC' WITH (FAILOVER_MODE = MANUAL);
SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas;
GO

-- SSN
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP [SSN_AG]
MODIFY REPLICA ON N'ATLSQLDBCN08\SSN' WITH (FAILOVER_MODE = MANUAL);
GO
ALTER AVAILABILITY GROUP [SSN_AG]
MODIFY REPLICA ON N'ATLSQLDBCN07\SSN' WITH (FAILOVER_MODE = MANUAL);
SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas;
GO

-- VA
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP [Virginia_AG]
MODIFY REPLICA ON N'ATLSQLDBCN08\VA' WITH (FAILOVER_MODE = MANUAL);
GO
ALTER AVAILABILITY GROUP [Virginia_AG]
MODIFY REPLICA ON N'ATLSQLDBCN07\VA' WITH (FAILOVER_MODE = MANUAL);
SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas;
GO



-- (3) Verify AG health (all instances)
-- FLCC
:CONNECT SQLPRD-VTC-FLCC.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- SC
:CONNECT SQLPRD-VTC-SC.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- SSN
:CONNECT SQLPRD-VTC-SSN.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- VA
:CONNECT SQLPRD-VTC-VA.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO



-- (4) Disable all jobs on ALL replicas (all instances)
-- Exclude the rebuild encryption, so failover can occur successfully
/**************************

***************************/
/*
USE [msdb];
SELECT 'EXEC dbo.sp_update_job @job_name = '''+name+''', @enabled = 0;'
FROM dbo.sysjobs
WHERE enabled = 1
ORDER BY 1
*/
-- FLCC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - FLCC - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - FLCC', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - FLCC', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - FLCC - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - FLCC', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - FLCC', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - FLCC - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - FLCC', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - FLCC', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
-- SC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - DEPDL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - DEPDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DEPDL Create Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - DEPDL', @enabled = 0;
--EXEC dbo.sp_update_job @job_name = 'Rebuild Encryption', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - DEPDL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - DEPDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DEPDL Create Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - DEPDL', @enabled = 0;
--EXEC dbo.sp_update_job @job_name = 'Rebuild Encryption', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - DEPDL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - DEPDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DEPDL Create Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - DEPDL', @enabled = 0;
--EXEC dbo.sp_update_job @job_name = 'Rebuild Encryption', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
-- SSN
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - INDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - INDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - INDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'INDPP Lender Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - INDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - INDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - INDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'INDPP Lender Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - INDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - INDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - INDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'INDPP Lender Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
-- VA
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - KYDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - KYDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - KYDPP', @enabled = 0;
--EXEC dbo.sp_update_job @job_name = 'KYDPP Auto Close', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'KYDPP Create Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'KYDPP Remit Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - KYDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - KYDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - KYDPP', @enabled = 0;
--EXEC dbo.sp_update_job @job_name = 'KYDPP Auto Close', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'KYDPP Create Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'KYDPP Remit Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - KYDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - KYDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - KYDPP', @enabled = 0;
--EXEC dbo.sp_update_job @job_name = 'KYDPP Auto Close', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'KYDPP Create Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'KYDPP Remit Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
GO



-- (5) Perform manual backup of all databases prior to making changes
-- FLCC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1108
USE [master]
GO
BACKUP DATABASE [FLCC] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\FLCC_2016_FULL.bak' WITH INIT, COPY_ONLY, STATS=10;
GO
-- DE
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1104
USE [master]
GO
BACKUP DATABASE [DEPDL] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\DEPDL_2016_FULL.bak' WITH INIT, COPY_ONLY, STATS=10;
GO
-- IND
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1105
USE [master]
GO
BACKUP DATABASE [INDPP] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\INDPP_2016_FULL.bak' WITH INIT, COPY_ONLY, STATS=10;
GO
-- KY
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1107
USE [master]
GO
BACKUP DATABASE [KYDPP] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\KYDPP_2016_FULL.bak' WITH INIT, COPY_ONLY, STATS=10;
GO
-- MI
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1106
USE [master]
GO
BACKUP DATABASE [MIDPP] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\MIDPP_2016_FULL.bak' WITH INIT, COPY_ONLY, STATS=10;
GO

-- (6) Reboot server to disconnect all sessions - ATLSQLDBCN08

-- (7) Perform SQL 2016 in-place upgrade - ATLSQLDBCN08

-- (8) Reboot server once upgrade is finished - ATLSQLDBCN08

-- (9) Verify server / instance health (all instances)
	-- SQL error log
	-- SQL Agent log
	-- Windows Event log (Application and System)
-- FLCC
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1108
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- DE
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1104
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- IND
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1105
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- KY
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1107
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- MI
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1106
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO


-- (10) Verify AG health (all instances)
-- FLCC
:CONNECT SQLPRD-VTC-FLCC.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- DE
:CONNECT SQLPRD-VTC-DE.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- IND
:CONNECT SQLPRD-VTC-IN.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- KY
:CONNECT SQLPRD-VTC-KY.Atlanta.ver.com,1107
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- MI
:CONNECT SQLPRD-VTC-MI.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO


-- Put all databases into read-write (NOT applicable)

-- (11) Reboot server to disconnect all sessions - ATLSQLDBCN09

-- (12) Perform SQL 2016 in-place upgrade - ATLSQLDBCN09

-- (13) Reboot server once upgrade is finished - ATLSQLDBCN09

-- (14) Verify server / instance health (all instances)
	-- SQL error log
	-- SQL Agent log
	-- Windows Event Log
-- FLCC
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1108
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- DE
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1104
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- IND
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1105
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- KY
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1107
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- MI
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1106
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO


-- Put databases back to read-only (NOT applicable)

-- (15) Move WSFC owner to secondary replica "reporting" ATLSQLDBCN09

-- (16) Perform AG failover to secondary replica (all instances)
-- Make ATLSQLDBCN08 primary for all AGs
-- FLCC
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP FLCC_AG FAILOVER;  
GO 
-- DE
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP Delaware_AG FAILOVER;  
GO
-- IND
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP Indiana_AG FAILOVER;  
GO
-- KY
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP Kentucky_AG FAILOVER;  
GO
-- MI
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP Michigan_AG FAILOVER;  
GO


-- (17) Verify AG health (all instances)
-- FLCC
:CONNECT SQLPRD-VTC-FLCC.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- DE
:CONNECT SQLPRD-VTC-DE.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- IND
:CONNECT SQLPRD-VTC-IN.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- KY
:CONNECT SQLPRD-VTC-KY.Atlanta.ver.com,1107
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- MI
:CONNECT SQLPRD-VTC-MI.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO


-- (18) Reboot server to disconnect all sessions - ATLSQLDBCN07

-- (19) Perform SQL 2016 in-place upgrade - ATLSQLDBCN07

-- (20) Reboot server once upgrade is finished - ATLSQLDBCN07

-- (21) Verify server / instance health (all instances)
	-- SQL error log
	-- SQL Agent log
	-- Windows Event log
-- FLCC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1108
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- DE
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1104
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- IND
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1105
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- KY
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1107
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO
-- MI
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1106
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1;
EXEC sys.sp_readerrorlog 0, 2;
GO


-- (22) Verify AG health (all instances)
-- FLCC
:CONNECT SQLPRD-VTC-FLCC.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- DE
:CONNECT SQLPRD-VTC-DE.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- IND
:CONNECT SQLPRD-VTC-IN.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- KY
:CONNECT SQLPRD-VTC-KY.Atlanta.ver.com,1107
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- MI
:CONNECT SQLPRD-VTC-MI.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO

-- (23) Perform AG failover back to ATLSQLDBCN07 replica (all instances)
-- Make ATLSQLDBCN07 primary for all AGs
-- FLCC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP FLCC_AG FAILOVER;  
GO 
-- DE
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP Delaware_AG FAILOVER;  
GO
-- IND
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP Indiana_AG FAILOVER;  
GO
-- KY
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP Kentucky_AG FAILOVER;  
GO
-- MI
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP Michigan_AG FAILOVER;  
GO


-- (24) Verify AG health (all instances)
-- FLCC
:CONNECT SQLPRD-VTC-FLCC.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- DE
:CONNECT SQLPRD-VTC-DE.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- IND
:CONNECT SQLPRD-VTC-IN.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- KY
:CONNECT SQLPRD-VTC-KY.Atlanta.ver.com,1107
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- MI
:CONNECT SQLPRD-VTC-MI.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO

-- (25) Send email to LOBs to perform FINAL testing.

-- (26) Send email to LOBs stating upgrade completed!

-- (27) Enable all SQL Agent jobs (include backup jobs)
/**************************
	KYDPP Auto Close runs @ 12:35 am daily
	MIDPP AutoClose Transaction runs @ 1:00 am daily
***************************/
-- Do the same for all nodes, all instances
-- FLCC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - FLCC - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - FLCC', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - FLCC', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - FLCC - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - FLCC', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - FLCC', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - FLCC - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - FLCC', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - FLCC', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
-- DE
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - DEPDL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - DEPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DEPDL Create Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - DEPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Rebuild Encryption', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - DEPDL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - DEPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DEPDL Create Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - DEPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Rebuild Encryption', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - DEPDL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - DEPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DEPDL Create Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - DEPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Rebuild Encryption', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
-- IND
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - INDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - INDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - INDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'INDPP Lender Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - INDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - INDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - INDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'INDPP Lender Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - INDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - INDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - INDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'INDPP Lender Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
-- KY
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - KYDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - KYDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - KYDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'KYDPP Auto Close', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'KYDPP Create Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'KYDPP Remit Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - KYDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - KYDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - KYDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'KYDPP Auto Close', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'KYDPP Create Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'KYDPP Remit Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - KYDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - KYDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - KYDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'KYDPP Auto Close', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'KYDPP Create Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'KYDPP Remit Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
-- MI
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - USER_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - USER_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MI Archive Step 1', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MI Archive Step 2', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MI Archive Step 3', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MIDPP AutoClose Transaction', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MIDPP Lender Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MIDPP State Remit Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Weekly - MIDPPArchive Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN08.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - USER_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - USER_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MI Archive Step 1', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MI Archive Step 2', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MI Archive Step 3', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MIDPP AutoClose Transaction', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MIDPP Lender Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MIDPP State Remit Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Weekly - MIDPPArchive Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO
:CONNECT ATLSQLDBCN09.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - USER_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - USER_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MI Archive Step 1', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MI Archive Step 2', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MI Archive Step 3', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MIDPP AutoClose Transaction', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MIDPP Lender Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'MIDPP State Remit Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Weekly - MIDPPArchive Restore', @enabled = 1;
SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'OnDemand Prod Restore' );
GO


-- (28) Execute node/instance compare
:CONNECT INTSQLMON03.Intuition.com,1104
USE [msdb];
GO
EXEC dbo.sp_start_job @job_name = 'DBA - OnDemand - Replication Check';
GO

-- (29) Modify AG failovers to "automatic" (all instances)
-- FLCC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP [FLCC_AG]
MODIFY REPLICA ON N'ATLSQLDBCN08\FLCC' WITH (FAILOVER_MODE = AUTOMATIC);
GO
ALTER AVAILABILITY GROUP [FLCC_AG]
MODIFY REPLICA ON N'ATLSQLDBCN07\FLCC' WITH (FAILOVER_MODE = AUTOMATIC);
SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas;
GO

-- DE
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP [Delaware_AG]
MODIFY REPLICA ON N'ATLSQLDBCN08\DE' WITH (FAILOVER_MODE = AUTOMATIC);
GO
ALTER AVAILABILITY GROUP [Delaware_AG]
MODIFY REPLICA ON N'ATLSQLDBCN07\DE' WITH (FAILOVER_MODE = AUTOMATIC);
SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas;
GO

-- IND
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP [Indiana_AG]
MODIFY REPLICA ON N'ATLSQLDBCN08\IND' WITH (FAILOVER_MODE = AUTOMATIC);
GO
ALTER AVAILABILITY GROUP [Indiana_AG]
MODIFY REPLICA ON N'ATLSQLDBCN07\IND' WITH (FAILOVER_MODE = AUTOMATIC);
SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas;
GO

-- KY
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP [Kentucky_AG]
MODIFY REPLICA ON N'ATLSQLDBCN08\KY' WITH (FAILOVER_MODE = AUTOMATIC);
GO
ALTER AVAILABILITY GROUP [Kentucky_AG]
MODIFY REPLICA ON N'ATLSQLDBCN07\KY' WITH (FAILOVER_MODE = AUTOMATIC);
SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas;
GO

-- MI
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP [Michigan_AG]
MODIFY REPLICA ON N'ATLSQLDBCN08\MI' WITH (FAILOVER_MODE = AUTOMATIC);
GO
ALTER AVAILABILITY GROUP [Michigan_AG]
MODIFY REPLICA ON N'ATLSQLDBCN07\MI' WITH (FAILOVER_MODE = AUTOMATIC);
SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas;
GO


-- (30) Execute integrity check jobs
-- Can be run from UTIL or other instance and SQLSentry will alert to job failure 
-- Turn maintenance window off in SentryOne if enabled!!
-- FLCC
:CONNECT SQLPRD-VTC-FLCC.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - FLCC';
GO
-- DE
:CONNECT SQLPRD-VTC-DE.Atlanta.ver.com,1104
USE [msdb]
GO
WAITFOR DELAY '00:00:30';  -- pause for 30 sec before continuing to let previous job finish
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - DEPDL';
GO
-- IND
:CONNECT SQLPRD-VTC-IN.Atlanta.ver.com,1105
USE [msdb]
GO
WAITFOR DELAY '00:00:30';  -- pause for 30 sec before continuing to let previous job finish
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - INDPP';
GO
-- KY
:CONNECT SQLPRD-VTC-KY.Atlanta.ver.com,1107
USE [msdb]
GO
WAITFOR DELAY '00:06:00';  -- pause for 6 mins before continuing to let previous job finish
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - KYDPP';
GO
-- MI
:CONNECT SQLPRD-VTC-MI.Atlanta.ver.com,1106
USE [msdb]
GO
WAITFOR DELAY '00:05:00';  -- pause for 5 mins before continuing to let previous job finish
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - USER_DATABASES';
GO

-- (31) Execute Full backup jobs
-- FLCC
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - FLCC - FULL';
GO
-- DE
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - DEPDL - FULL';
GO
-- IND
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - INDPP - FULL';
GO
-- KY
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - KYDPP - FULL';
GO
-- MI
:CONNECT ATLSQLDBCN07.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - USER_DATABASES - FULL';
GO
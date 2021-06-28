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
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP [Alabama_AG]
MODIFY REPLICA ON N'ATLSQLDBCN02\AL' WITH (FAILOVER_MODE = MANUAL)
GO
ALTER AVAILABILITY GROUP [Alabama_AG]
MODIFY REPLICA ON N'ATLSQLDBCN01\AL' WITH (FAILOVER_MODE = MANUAL)
GO
:EXIT(SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas)

-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP [APL_AG]
MODIFY REPLICA ON N'ATLSQLDBCN02\APL' WITH (FAILOVER_MODE = MANUAL)
GO
ALTER AVAILABILITY GROUP [APL_AG]
MODIFY REPLICA ON N'ATLSQLDBCN01\APL' WITH (FAILOVER_MODE = MANUAL)
GO
:EXIT(SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas)

-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP [Illinois_AG]
MODIFY REPLICA ON N'ATLSQLDBCN02\IL' WITH (FAILOVER_MODE = MANUAL)
GO
ALTER AVAILABILITY GROUP [Illinois_AG]
MODIFY REPLICA ON N'ATLSQLDBCN01\IL' WITH (FAILOVER_MODE = MANUAL)
GO
:EXIT(SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas)

-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP [NorthDakota_AG]
MODIFY REPLICA ON N'ATLSQLDBCN02\ND' WITH (FAILOVER_MODE = MANUAL)
GO
ALTER AVAILABILITY GROUP [NorthDakota_AG]
MODIFY REPLICA ON N'ATLSQLDBCN01\ND' WITH (FAILOVER_MODE = MANUAL)
GO
:EXIT(SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas)

-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP [Oklahoma_AG]
MODIFY REPLICA ON N'ATLSQLDBCN02\OK' WITH (FAILOVER_MODE = MANUAL)
GO
ALTER AVAILABILITY GROUP [Oklahoma_AG]
MODIFY REPLICA ON N'ATLSQLDBCN01\OK' WITH (FAILOVER_MODE = MANUAL)
GO
:EXIT(SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas)

-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP [Wisconsin_AG]
MODIFY REPLICA ON N'ATLSQLDBCN02\WI' WITH (FAILOVER_MODE = MANUAL)
GO
ALTER AVAILABILITY GROUP [Wisconsin_AG]
MODIFY REPLICA ON N'ATLSQLDBCN01\WI' WITH (FAILOVER_MODE = MANUAL)
GO
:EXIT(SELECT replica_server_name, failover_mode_desc FROM sys.availability_replicas)


-- (3) Remove secondary replica "failover" from AG (all instances)
-- This will remove ATLSQLDBCN02 from all AGs
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP [Alabama_AG]
REMOVE REPLICA ON N'ATLSQLDBCN02\AL';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP [APL_AG]
REMOVE REPLICA ON N'ATLSQLDBCN02\APL';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP [Illinois_AG]
REMOVE REPLICA ON N'ATLSQLDBCN02\IL';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP [NorthDakota_AG]
REMOVE REPLICA ON N'ATLSQLDBCN02\ND';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP [Oklahoma_AG]
REMOVE REPLICA ON N'ATLSQLDBCN02\OK';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP [Wisconsin_AG]
REMOVE REPLICA ON N'ATLSQLDBCN02\WI';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)



-- (4) Verify AG health (all instances)
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO

-- (5) Disable all jobs on ALL replicas (all instances)
-- Exclude the rebuild encryption, so failover can occur successfully
-- Excluded the WIPDL job stated below
/**************************
	WIPDL Auto Close job runs 12:58 AM daily
***************************/
/*
SELECT 'EXEC dbo.sp_update_job @job_name = '''+name+''', @enabled = 0;'
FROM dbo.sysjobs
WHERE enabled = 1
ORDER BY 1
*/
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'ALDPP Create Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ALDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ALDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ALDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'ALDPP Create Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ALDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ALDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ALDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'ALDPP Create Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ALDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ALDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ALDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILAPL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILAPL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILAPL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1109
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILAPL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILAPL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILAPL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1109
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILAPL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILAPL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILAPL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'ILDPP Create invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'ILDPP Special Title Transfer', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'ILDPP Create invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'ILDPP Special Title Transfer', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'ILDPP Create invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'ILDPP Special Title Transfer', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'NDDPP Lender Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - NDDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - NDDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - NDDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'NDDPP Lender Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - NDDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - NDDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - NDDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'NDDPP Lender Invoice', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - NDDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - NDDPP', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - NDDPP - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - OKDDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'OKDDL Remit CCC', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'OKDDL Create Invoices', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - OKDDL', @enabled = 0;
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - OKDDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'OKDDL Remit CCC', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'OKDDL Create Invoices', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - OKDDL', @enabled = 0;
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - OKDDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'OKDDL Remit CCC', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'OKDDL Create Invoices', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - OKDDL', @enabled = 0;
-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - WIPDL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - WIPDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'WIPDL Remit Invoice Job', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'WIPDL Create DPP Invoices', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - WIPDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'WIPDL Auto Close', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - WIPDL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - WIPDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'WIPDL Remit Invoice Job', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'WIPDL Create DPP Invoices', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - WIPDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'WIPDL Auto Close', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - WIPDL - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - WIPDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'WIPDL Remit Invoice Job', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'WIPDL Create DPP Invoices', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - WIPDL', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 0;
--EXEC dbo.sp_update_job @job_name = 'WIPDL Auto Close', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 0;




-- (6) Drop all databases in "recovering" state (all instances)
-- AL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1108
USE [master]
GO
DROP DATABASE [ALDPP];
GO
-- APL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1109
USE [master]
GO
DROP DATABASE [ILAPL];
GO
-- IL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1106
USE [master]
GO
DROP DATABASE [ILDPP];
GO
-- ND
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1104
USE [master]
GO
DROP DATABASE [NDDPP];
GO
-- OK
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1105
USE [master]
GO
DROP DATABASE [OKDDL];
GO
-- WI
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1107
USE [master]
GO
DROP DATABASE [WIPDL];
GO


-- (7) Reboot server to disconnect all sessions - ATLSQLDBCN02

-- (8) Perform SQL 2016 in-place upgrade - ATLSQLDBCN02

-- (9) Reboot server once upgrade is finished - ATLSQLDBCN02

-- (10) Verify server / instance health (all instances)
	-- SQL error log
	-- SQL Agent log
	-- Windows Event log (Application and System)
-- AL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1108
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- APL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1109
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- IL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1106
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- ND
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1104
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- OK
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1105
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- WI
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1107
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2


-- (11) Add server "failover" back to AGs (all instances)
	-- Keep in mind database owners!
/***************
	(a) BACKUP
	~10 mins
****************/
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [master]
GO
BACKUP DATABASE [ALDPP] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\ALDPP_2016_FULL.bak' WITH INIT, STATS=10;
BACKUP LOG [ALDPP] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\ALDPP_2016_LOG.trn' WITH INIT, STATS=20;
GO
-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [master]
GO
BACKUP DATABASE [ILAPL] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\ILAPL_2016_FULL.bak' WITH INIT, STATS=10;
BACKUP LOG [ILAPL] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\ILAPL_2016_LOG.trn' WITH INIT, STATS=20;
GO
-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [master]
GO
BACKUP DATABASE [ILDPP] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\ILDPP_2016_FULL.bak' WITH INIT, STATS=10;
BACKUP LOG [ILDPP] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\ILDPP_2016_LOG.trn' WITH INIT, STATS=20;
GO
-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [master]
GO
BACKUP DATABASE [NDDPP] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\NDDPP_2016_FULL.bak' WITH INIT, STATS=10;
BACKUP LOG [NDDPP] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\NDDPP_2016_LOG.trn' WITH INIT, STATS=20;
GO
-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [master]
GO
BACKUP DATABASE [OKDDL] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\OKDDL_2016_FULL.bak' WITH INIT, STATS=10;
BACKUP LOG [OKDDL] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\OKDDL_2016_LOG.trn' WITH INIT, STATS=20;
GO
-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [master]
GO
BACKUP DATABASE [WIPDL] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\WIPDL_2016_FULL.bak' WITH INIT, STATS=10;
BACKUP LOG [WIPDL] TO DISK = '\\ATLSQLFS01\ProdSQLBackups\WIPDL_2016_LOG.trn' WITH INIT, STATS=20;
GO

/***************
	(b) RESTORE
	~10 mins
****************/
-- AL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1108
USE [master]
GO
RESTORE DATABASE [ALDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ALDPP_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [ALDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ALDPP_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- APL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1109
USE [master]
GO
RESTORE DATABASE [ILAPL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILAPL_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [ILAPL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILAPL_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- IL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1106
USE [master]
GO
RESTORE DATABASE [ILDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILDPP_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [ILAPL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILDPP_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- ND
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1104
USE [master]
GO
RESTORE DATABASE [NDDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\NDDPP_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [NDDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\NDDPP_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- OK
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1105
USE [master]
GO
RESTORE DATABASE [OKDDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\OKDDL_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [OKDDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\OKDDL_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- WI
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1107
USE [master]
GO
RESTORE DATABASE [WIPDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\WIPDL_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [WIPDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\WIPDL_2016_LOG.trn' WITH NORECOVERY, STATS=20;

/**************************
	(c) ADD REPLICA TO AG
	SELECT * FROM sys.availability_replicas;
	GO
***************************/
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP [Alabama_AG] 
ADD REPLICA ON 'ATLSQLDBCN02\AL' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN02.ATLANTA.VER.COM:5026', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SESSION_TIMEOUT = 15);
GO
-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP [APL_AG] 
ADD REPLICA ON 'ATLSQLDBCN02\APL' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN02.ATLANTA.VER.COM:5027', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SESSION_TIMEOUT = 15);
GO
-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP [Illinois_AG] 
ADD REPLICA ON 'ATLSQLDBCN02\IL' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN02.ATLANTA.VER.COM:5024', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SESSION_TIMEOUT = 15);
GO
-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP [NorthDakota_AG] 
ADD REPLICA ON 'ATLSQLDBCN02\ND' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN02.ATLANTA.VER.COM:5022', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SESSION_TIMEOUT = 15);
GO
-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP [Oklahoma_AG] 
ADD REPLICA ON 'ATLSQLDBCN02\OK' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN02.ATLANTA.VER.COM:5023', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SESSION_TIMEOUT = 15);
GO
-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP [Wisconsin_AG] 
ADD REPLICA ON 'ATLSQLDBCN02\WI' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN02.ATLANTA.VER.COM:5025', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SESSION_TIMEOUT = 15);
GO


/*******************
	(d) JOIN AG
********************/
-- AL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP Alabama_AG JOIN;  
GO 
-- APL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP APL_AG JOIN;  
GO
-- IL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP Illinois_AG JOIN;  
GO
-- ND
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP NorthDakota_AG JOIN;  
GO
-- OK
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP Oklahoma_AG JOIN;  
GO
-- WI
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP Wisconsin_AG JOIN;  
GO



-- (12) Remove secondary replica "reporting" from AG (all instances)
-- This will remove ATLSQLDBCN03 from all AGs
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP [Alabama_AG]
REMOVE REPLICA ON N'ATLSQLDBCN03\AL';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP [APL_AG]
REMOVE REPLICA ON N'ATLSQLDBCN03\APL';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP [Illinois_AG]
REMOVE REPLICA ON N'ATLSQLDBCN03\IL';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP [NorthDakota_AG]
REMOVE REPLICA ON N'ATLSQLDBCN03\ND';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP [Oklahoma_AG]
REMOVE REPLICA ON N'ATLSQLDBCN03\OK';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP [Wisconsin_AG]
REMOVE REPLICA ON N'ATLSQLDBCN03\WI';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)



-- (13) Verify AG health (all instances)
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO



-- (14) Drop all databases in "recovering" state (all instances)
-- AL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1108
USE [master]
GO
DROP DATABASE [ALDPP];
GO
-- APL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1109
USE [master]
GO
DROP DATABASE [ILAPL];
GO
-- IL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1106
USE [master]
GO
DROP DATABASE [ILDPP];
GO
-- ND
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1104
USE [master]
GO
DROP DATABASE [NDDPP];
GO
-- OK
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1105
USE [master]
GO
DROP DATABASE [OKDDL];
GO
-- WI
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1107
USE [master]
GO
DROP DATABASE [WIPDL];
GO



-- Put all databases into read-write (NOT applicable)

-- (16) Reboot server to disconnect all sessions - ATLSQLDBCN03

-- (17) Perform SQL 2016 in-place upgrade - ATLSQLDBCN03

-- (18) Reboot server once upgrade is finished - ATLSQLDBCN03

-- (19) Verify server / instance health (all instances)
	-- SQL error log
	-- SQL Agent log
	-- Windows Event Log
-- AL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1108
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- APL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1109
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- IL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1106
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- ND
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1104
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- OK
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1105
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- WI
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1107
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2


-- Put databases back to read-only (NOT applicable)

-- (20) Add server "reporting" back to AGs (all instances)
	-- Keep in mind database owners!
	-- SEE STEP 11 if NEW backup is needed!!!
/***************
	(b) RESTORE
	~10 mins
****************/
-- AL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1108
USE [master]
GO
RESTORE DATABASE [ALDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ALDPP_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [ALDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ALDPP_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- APL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1109
USE [master]
GO
RESTORE DATABASE [ILAPL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILAPL_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [ILAPL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILAPL_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- IL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1106
USE [master]
GO
RESTORE DATABASE [ILDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILDPP_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [ILAPL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILDPP_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- ND
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1104
USE [master]
GO
RESTORE DATABASE [NDDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\NDDPP_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [NDDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\NDDPP_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- OK
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1105
USE [master]
GO
RESTORE DATABASE [OKDDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\OKDDL_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [OKDDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\OKDDL_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- WI
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1107
USE [master]
GO
RESTORE DATABASE [WIPDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\WIPDL_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [WIPDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\WIPDL_2016_LOG.trn' WITH NORECOVERY, STATS=20;

/**************************
	(c) ADD REPLICA TO AG
	SELECT * FROM sys.availability_replicas;
	GO
***************************/
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP [Alabama_AG] 
ADD REPLICA ON 'ATLSQLDBCN03\AL' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN03.ATLANTA.VER.COM:5026', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP [APL_AG] 
ADD REPLICA ON 'ATLSQLDBCN03\APL' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN03.ATLANTA.VER.COM:5027', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP [Illinois_AG] 
ADD REPLICA ON 'ATLSQLDBCN03\IL' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN03.ATLANTA.VER.COM:5024', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP [NorthDakota_AG] 
ADD REPLICA ON 'ATLSQLDBCN03\ND' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN03.ATLANTA.VER.COM:5022', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP [Oklahoma_AG] 
ADD REPLICA ON 'ATLSQLDBCN03\OK' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN03.ATLANTA.VER.COM:5023', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP [Wisconsin_AG] 
ADD REPLICA ON 'ATLSQLDBCN03\WI' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN03.ATLANTA.VER.COM:5025', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO


/*******************
	(d) JOIN AG
********************/
-- AL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP Alabama_AG JOIN;  
GO 
-- APL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP APL_AG JOIN;  
GO
-- IL
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP Illinois_AG JOIN;  
GO
-- ND
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP NorthDakota_AG JOIN;  
GO
-- OK
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP Oklahoma_AG JOIN;  
GO
-- WI
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP Wisconsin_AG JOIN;  
GO



-- (21) Move WSFC owner to secondary replica "reporting" ATLSQLDBCN03

-- (22) Perform AG failover to secondary replica (all instances)
-- Make ATLSQLDBCN02 primary for all AGs
-- AL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP Alabama_AG FAILOVER;  
GO 
-- APL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP APL_AG FAILOVER;  
GO
-- IL
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP Illinois_AG FAILOVER;  
GO
-- ND
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP NorthDakota_AG FAILOVER;  
GO
-- OK
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP Oklahoma_AG FAILOVER;  
GO
-- WI
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP Wisconsin_AG FAILOVER;  
GO


-- (23) Verify AG health (all instances)
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO



-- (24) Remove secondary replica "old primary" from AG (all instances)
-- This will remove ATLSQLDBCN01 from all AGs
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP [Alabama_AG]
REMOVE REPLICA ON N'ATLSQLDBCN01\AL';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP [APL_AG]
REMOVE REPLICA ON N'ATLSQLDBCN01\APL';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP [Illinois_AG]
REMOVE REPLICA ON N'ATLSQLDBCN01\IL';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP [NorthDakota_AG]
REMOVE REPLICA ON N'ATLSQLDBCN01\ND';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP [Oklahoma_AG]
REMOVE REPLICA ON N'ATLSQLDBCN01\OK';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)

-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP [Wisconsin_AG]
REMOVE REPLICA ON N'ATLSQLDBCN01\WI';
GO
:EXIT(SELECT replica_server_name FROM sys.availability_replicas)



-- (25) Verify AG health (all instances)
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO


-- (26) Drop all databases in "recovering" state (all instances)
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [master]
GO
DROP DATABASE [ALDPP];
GO
-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [master]
GO
DROP DATABASE [ILAPL];
GO
-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [master]
GO
DROP DATABASE [ILDPP];
GO
-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [master]
GO
DROP DATABASE [NDDPP];
GO
-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [master]
GO
DROP DATABASE [OKDDL];
GO
-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [master]
GO
DROP DATABASE [WIPDL];
GO


-- (27) Reboot server to disconnect all sessions - ATLSQLDBCN01

-- (28) Perform SQL 2016 in-place upgrade - ATLSQLDBCN01

-- (29) Reboot server once upgrade is finished - ATLSQLDBCN01

-- (30) Verify server / instance health (all instances)
	-- SQL error log
	-- SQL Agent log
	-- Windows Event log
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2
-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [master]
GO
EXEC sys.sp_readerrorlog 0, 1
EXEC sys.sp_readerrorlog 0, 2


-- (31) Add server "old primary" back to AGs (all instances)
	-- Keep in mind database owners!
	-- SEE STEP 11 if NEW backup is needed!!!
/***************
	(b) RESTORE
	~10 mins
****************/
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [master]
GO
RESTORE DATABASE [ALDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ALDPP_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [ALDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ALDPP_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [master]
GO
RESTORE DATABASE [ILAPL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILAPL_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [ILAPL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILAPL_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [master]
GO
RESTORE DATABASE [ILDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILDPP_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [ILAPL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\ILDPP_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [master]
GO
RESTORE DATABASE [NDDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\NDDPP_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [NDDPP] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\NDDPP_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [master]
GO
RESTORE DATABASE [OKDDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\OKDDL_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [OKDDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\OKDDL_2016_LOG.trn' WITH NORECOVERY, STATS=20;
-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [master]
GO
RESTORE DATABASE [WIPDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\WIPDL_2016_FULL.bak' WITH NORECOVERY, STATS=10;
RESTORE LOG [WIPDL] FROM DISK = '\\ATLSQLFS01\ProdSQLBackups\WIPDL_2016_LOG.trn' WITH NORECOVERY, STATS=20;

/**************************
	(c) ADD REPLICA TO AG
	SELECT * FROM sys.availability_replicas;
	GO
***************************/
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP [Alabama_AG] 
ADD REPLICA ON 'ATLSQLDBCN01\AL' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN01.ATLANTA.VER.COM:5026', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP [APL_AG] 
ADD REPLICA ON 'ATLSQLDBCN01\APL' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN01.ATLANTA.VER.COM:5027', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP [Illinois_AG] 
ADD REPLICA ON 'ATLSQLDBCN01\IL' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN01.ATLANTA.VER.COM:5024', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP [NorthDakota_AG] 
ADD REPLICA ON 'ATLSQLDBCN01\ND' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN01.ATLANTA.VER.COM:5022', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP [Oklahoma_AG] 
ADD REPLICA ON 'ATLSQLDBCN01\OK' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN01.ATLANTA.VER.COM:5023', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO
-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP [Wisconsin_AG] 
ADD REPLICA ON 'ATLSQLDBCN01\WI' 
WITH (ENDPOINT_URL = N'TCP://ATLSQLDBCN01.ATLANTA.VER.COM:5025', FAILOVER_MODE = MANUAL, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 0, SESSION_TIMEOUT = 15);
GO


/*******************
	(d) JOIN AG
********************/
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [master]
GO
ALTER AVAILABILITY GROUP Alabama_AG JOIN;  
GO 
-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [master]
GO
ALTER AVAILABILITY GROUP APL_AG JOIN;  
GO
-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [master]
GO
ALTER AVAILABILITY GROUP Illinois_AG JOIN;  
GO
-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [master]
GO
ALTER AVAILABILITY GROUP NorthDakota_AG JOIN;  
GO
-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [master]
GO
ALTER AVAILABILITY GROUP Oklahoma_AG JOIN;  
GO
-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [master]
GO
ALTER AVAILABILITY GROUP Wisconsin_AG JOIN;  
GO


-- (32) Verify AG health (all instances)
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar 
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO
-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [master]
GO
SELECT ar.replica_server_name, ar.failover_mode_desc, hars.synchronization_health_desc 
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS hars
  ON hars.replica_id = ar.replica_id
GO

-- (33) Send email to LOBs stating upgrade completed!

-- (34) Enable all SQL Agent jobs (include backup jobs)
	-- Do the same for all nodes, all instances
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'ALDPP Create Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ALDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ALDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ALDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'ALDPP Create Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ALDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ALDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ALDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'ALDPP Create Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ALDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ALDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ALDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILAPL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILAPL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILAPL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1109
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILAPL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILAPL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILAPL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1109
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILAPL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILAPL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILAPL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'ILDPP Create invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'ILDPP Special Title Transfer', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'ILDPP Create invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'ILDPP Special Title Transfer', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - ILDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - ILDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'ILDPP Create invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'ILDPP Special Title Transfer', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - ILDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'NDDPP Lender Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - NDDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - NDDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - NDDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'NDDPP Lender Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - NDDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - NDDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - NDDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'NDDPP Lender Invoice', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - NDDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - NDDPP', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - NDDPP - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - OKDDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'OKDDL Remit CCC', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'OKDDL Create Invoices', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - OKDDL', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - OKDDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'OKDDL Remit CCC', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'OKDDL Create Invoices', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - OKDDL', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - OKDDL - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - OKDDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'OKDDL Remit CCC', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'OKDDL Create Invoices', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - OKDDL', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - WIPDL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - WIPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'WIPDL Remit Invoice Job', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'WIPDL Create DPP Invoices', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - WIPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'WIPDL Auto Close', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN02.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - WIPDL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - WIPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'WIPDL Remit Invoice Job', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'WIPDL Create DPP Invoices', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - WIPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'WIPDL Auto Close', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')
:CONNECT ATLSQLDBCN03.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - WIPDL - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'IndexOptimize - WIPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'WIPDL Remit Invoice Job', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'WIPDL Create DPP Invoices', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'syspolicy_purge_history', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - WIPDL', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'Veritec - Monthly - EOM Restore', @enabled = 1;
--EXEC dbo.sp_update_job @job_name = 'WIPDL Auto Close', @enabled = 0;
EXEC dbo.sp_update_job @job_name = 'SQL Sentry 2.0 Alert Trap', @enabled = 1;
EXEC dbo.sp_update_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES', @enabled = 1;
:EXIT(SELECT @@ServerName, COUNT(1) AS 'DisabledJobs' FROM dbo.sysjobs WHERE enabled = 0 AND name <> 'SQL Sentry 2.0 Queue Monitor')


-- (35) Execute node/instance compare
:CONNECT INTSQLMON03.Intuition.com,1104
USE [msdb];
GO
EXEC dbo.sp_start_job @job_name = 'DBA - OnDemand - Replication Check';
GO

-- (36) Execute integrity check jobs
-- Can be run from UTIL or other instance and SQLSentry will alert to job failure
-- AL
:CONNECT SQLPRD-VTC-AL.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - ALDPP';
GO
-- APL
:CONNECT SQLPRD-VTC-APL.Atlanta.ver.com,1109
USE [msdb]
GO
WAITFOR DELAY '00:02:30';  -- pause for 2 mins 30 sec before continuing to let previous job finish
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - ILAPL';
GO
-- IL
:CONNECT SQLPRD-VTC-IL.Atlanta.ver.com,1106
USE [msdb]
GO
WAITFOR DELAY '00:04:30';  -- pause for 4 mins 30 sec before continuing to let previous job finish
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - ILDPP';
GO
-- ND
:CONNECT SQLPRD-VTC-ND.Atlanta.ver.com,1104
USE [msdb]
GO
WAITFOR DELAY '00:06:00';  -- pause for 6 mins before continuing to let previous job finish
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - NDDPP';
GO
-- OK
:CONNECT SQLPRD-VTC-OK.Atlanta.ver.com,1105
USE [msdb]
GO
WAITFOR DELAY '00:01:00';  -- pause for 1 min before continuing to let previous job finish
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - OKDDL';
GO
-- WI
:CONNECT SQLPRD-VTC-WI.Atlanta.ver.com,1107
USE [msdb]
GO
WAITFOR DELAY '00:03:00';  -- pause for 3 mins before continuing to let previous job finish
EXEC dbo.sp_start_job @job_name = 'DatabaseIntegrityCheck - WIPDL';
GO

-- (37) Execute Full backup jobs
-- AL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1108
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - ALDPP - FULL';
GO
-- APL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1109
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - ILAPL - FULL';
GO
-- IL
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1106
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - ILDPP - FULL';
GO
-- ND
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1104
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - NDDPP - FULL';
GO
-- OK
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1105
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - OKDDL - FULL';
GO
-- WI
:CONNECT ATLSQLDBCN01.Atlanta.ver.com,1107
USE [msdb]
GO
EXEC dbo.sp_start_job @job_name = 'DatabaseBackup - WIPDL - FULL';
GO
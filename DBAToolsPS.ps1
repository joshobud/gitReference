# Add database to AG with or w/o backup/restore
Add-DbaAgDatabase -sqlinstance 'DocuphaseCSProd,1106' -AvailabilityGroup DocuphaseCS_AG -SqlCredential sa `
-Database ABLE_iSynergyResource -Secondary 'INTSQLCN02,1106' 'JAXSQLDBCN06,1106' 'INTSQLCN06,1106' -SecondarySqlCredential sa `
-SeedingMode Manual -SharedPath '\\JAXSQLFS01\ProdSQLBackups'

# If needed take backups prior to avoid error if Recovery model changed, maxtransfersize included to keep compression with TDE
Backup-DbaDatabase -SqlInstance 'savingsPCI_Prod.PCI.JAX.NET,4011' -CompressBackup -CreateFolder `
-Path '\\ATLSQLFS02\BetaSQLBackups\' -Type Full -WithFormat -Database TrainingBeta -MaxTransferSize 131072 -ExcludeDatabase '*copy'

Get-DbaAvailabilityGroup -SqlInstance 'DocuphaseCSProd,1106' -AvailabilityGroup DocuphaseCS_AG | Join-DbaAvailabilityGroup -SqlInstance sql02

Backup-DbaDatabase -SqlInstance 'INTSQLCN02,1104' -CompressBackup -Database prodSBL `
-Path '\\JAXSQLFS01\ProdSQLBackups' -Type Full -FilePath ProdSBL.bak -WithFormat -MaxTransferSize 131072

# Retrieve backup history
Get-DbaBackupInformation -SqlCredential jobudzinski -SqlInstance 'INTSQLCN01,1104' -DatabaseName ProdControl -Path '\\JAXSQLFS01\ProdSQLBackups\JAXSQLPRD01$Finance_AG\prodControl' -MaintenanceSolution
Restore-DbaDatabase -SqlInstance 'INTSQLDEV01,1104' -Path '\\JAXSQLFS01\DevSQLBackups\INTSQLDEV01$FINANCE\JAXSQLPRD01$Finance_AG_prodDPP_FULL_COPY_ONLY_20200109_190139.bak' -DatabaseName ProdDPP -UseDestinationDefaultDirectories -WithReplace

# Change recovery model to FULL in order to add database to AG
Get-DbaDbRecoveryModel -SqlInstance 'INTSQLBETACN01,3478' -SqlCredential jobudzinski -Database B2P_MeridianQA
Set-DbaDbRecoveryModel -SqlInstance 'INTSQLBETACN01,1109' -RecoveryModel Full -Database EnterpriseUserAccess -Confirm:$false

Get-dbaAvailabilityGroup -SqlCredential jobudzinski -SqlInstance 'ATLSQLDBCN04.Atlanta.ver.com,1106' -AvailabilityGroup Michigan_AG

# Create login on another server, will also copy permissions (server)
Copy-DbaLogin -SourceSqlCredential jobudzinski -Source 'INTSQLBETACN01,1109' -Destination 'INTSQLBETACN03,1109' -DestinationSqlCredential jobudzinski -Login 'ap_SVCS_USBankPrepaid'
Copy-DbaLogin -Source 'INTSQLBETACN02,1106' -Destination 'INTSQLBETACN01,1106' -Login 'INTUITION\SSolice' -WhatIf

# View object dependcies
$table = (Get-DbaDatabase -SqlInstance 'SQLMON,1104' -Database DBARepository).tables | Where-Object Name -eq DBADataCaptureSnapshots
$table | Get-DbaDependency | Out-Gridview

# Returns basic information on all the Availability Group(s) found on INTSQLCN02,1107.
Get-DbaAvailabilityGroup -SqlInstance 'intsqlcn02,1107'
# Same as above but outputs to grid
Get-DbaAvailabilityGroup -SqlInstance 'INTSQLCN02,1107' | Out-GridView
# Returns full object properties on all Availability Group(s) on INTSQLCN02,1107.
Get-DbaAvailabilityGroup -SqlInstance 'intsqlcn02,1107' | Select-Object *
# Returns the SQL Server instancename of the primary replica as a string
Get-DbaAvailabilityGroup -SqlInstance 'INTSQLCN02,1106' | Select-Object -ExpandProperty PrimaryReplicaServerName
# Safely (no potential data loss) fails over the selected availability groups to INTSQLCN02. Does not prompt for confirmation.
Get-DbaAvailabilityGroup -SqlInstance 'INTSQLCN02,1107' | Out-GridView -PassThru | Invoke-DbaAgFailover -Confirm:$false

# Safely (no potential data loss) fails over the noted AG to INTSQLCN02. Does not prompt for confirmation.
Invoke-DbaAgFailover -SqlInstance 'INTSQLCN02,1104' -AvailabilityGroup Finance_AG -Confirm:$false
Invoke-DbaAgFailover -SqlInstance 'INTSQLCN02,1105' -AvailabilityGroup B2P_AG -Confirm:$false
Invoke-DbaAgFailover -SqlInstance 'INTSQLCN02,1106' -AvailabilityGroup Savings_AG -Confirm:$false
Invoke-DbaAgFailover -SqlInstance 'intsqlcn02,1107' -AvailabilityGroup CT_AG -Confirm:$false
Invoke-DbaAgFailover -SqlInstance 'intsqlcn02,1107' -AvailabilityGroup Docuphase_AG -Confirm:$false
Invoke-DbaAgFailover -SqlInstance 'intsqlcn02,1107' -AvailabilityGroup TFS_AG -Confirm:$false
# Safely (no potential data loss) fails over the selected availability groups to INTSQLCN02. Does not prompt for confirmation.
Get-DbaAvailabilityGroup -SqlInstance 'INTSQLCN02,1107' | Out-GridView -PassThru | Invoke-DbaAgFailover -Confirm:$false

# Returns the SQL Server instancename of the primary replica as a string. Verify after failover.
Get-DbaAvailabilityGroup -SqlInstance 'INTSQLCN02,1107' | Select-Object -ExpandProperty PrimaryReplicaServerName
Get-DbaAvailabilityGroup -SqlInstance 'Savings_Prod,1106' | Select-Object -ExpandProperty PrimaryReplicaServerName
Get-DbaAvailabilityGroup -SqlInstance 'B2P_Prod,1105' | Select-Object -ExpandProperty PrimaryReplicaServerName
Get-DbaAvailabilityGroup -SqlInstance 'Finance_Prod,1104' | Select-Object -ExpandProperty PrimaryReplicaServerName

# Gets role information from the failover cluster JAXSQLPRD01
Get-DbaWsfcRole -ComputerName JAXSQLPRD01 | Where-Object Name -Like "*AG" | Out-GridView

Get-DbaAvailabilityGroup -SqlInstance 'ATLSQLDBCN10.Atlanta.ver.com,1105' | Out-File 'C:\Users\jobudzinski\Documents\Listeners.txt' -Append

# Using wait in between commands
Get-DbaAvailabilityGroup -SqlInstance 'B2P_Prod,1105' | Select-Object -ExpandProperty PrimaryReplicaServerName
Start-Sleep -Seconds 5
Get-DbaAvailabilityGroup -SqlInstance 'Finance_Prod,1104' | Select-Object -ExpandProperty PrimaryReplicaServerName

# Exports data in INSERT statements from 'dbo.Orion_Migrate' in database to Flat file
Get-DbaDbTable -SqlInstance 'INTSQLMON03,1104' -Database DBARepository -Table Orion_migrate `
    -SqlCredential jobudzinski | Export-DbaDbTableData -Path 'C:\Users\jobudzinski\Documents\ZohoImport.csv'

# Prompts then removes the Login mylogin on SQL Server
Remove-DbaLogin -SqlInstance '192.168.28.57,1109' -Login 'CollegeSavings\dhegwood' -SqlCredential jobudzinski
Remove-DbaDbUser -SqlInstance 'sqlbeta-int,1107' -User 'INTUITION\SWU'

# Finds and repairs user 'acilliers' on all databases, run without user to repair all orphans
Repair-DbaDbOrphanUser -SqlInstance 'sqlbeta-cs,1106' -Database CS_FLCAP_ProdCopy -Users acilliers

# Returns SQL Server instance properties on the local default SQL Server instance
Get-DbaInstanceProperty -SqlInstance '192.168.28.56,1109' -SqlCredential jobudzinski

# Creates a new Windows Authentication backed login on sql1. The login will be part of the public server role.
New-DbaLogin -SqlInstance 'JAXSQLDBCN06,1106', 'INTSQLCN01,1106', 'INTSQLCN02,1106', 'INTSQLCN06,1106' `
 -Login 'INTUITION\PHouston' -PasswordPolicyEnforced

# Add new login to sysadmin server role
Copy-DbaLogin -Source '192.168.28.56,1109' -SourceSqlCredential jobudzinski `
    -Destination '192.168.28.56,1104' -DestinationSqlCredential jobudzinski -Login 'DHegwood'

Set-DbaLogin -SqlInstance 'INTSQLCN06,1106' -Login 'INTUITION\PHouston'

# Sets database owner to 'sa' on all databases where the owner does not match 'sa'.
Set-DbaDbOwner -SqlInstance 'INTSQLDEV01,1104' -SqlCredential jobudzinski

# Sets database owner to 'sa' on specific database
Set-DbaDbOwner -SqlInstance 'vrtsqldev01,1104' -Database FLADPP

# Creates a new sql user with login named user1 in the specified database.
New-DbaDbUser -SqlInstance '192.168.28.56,1109' -Login 'ARobertson' -SqlCredential jobudzinski

# Adds user1 to the role db_owner in the database mydb on the local default SQL Server instance
Add-DbaDbRoleMember -SqlInstance 'Savings_Prod,1106' -Database CS_Logging_Prod -Role db_datareader -User 'INTUITION\PHouston'

# Change owner to sa, create database user for login, and add user to db role
Set-DbaDbOwner -SqlInstance 'vrtsqldev01,1104' -Database WIPDLTest
New-DbaDbUser -SqlInstance 'vrtsqldev01,1104' -Database WIPDLTest -Login wipdl_own
Add-DbaDbRoleMember -SqlInstance 'vrtsqldev01,1104' -Database WIPDLTest -Role db_owner -User wipdl_own

# Outputs all the active directory groups members for a server, or limits it to find a specific AD user in the groups
Find-DbaLoginInGroup -SqlInstance '192.168.28.56,1109' -SqlCredential jobudzinski

# returns an SMO Login object for the logins passed, if there are no users passed it will return all logins.
Get-DbaLogin -SqlInstance '192.168.28.56,1109' -SqlCredential jobudzinski -ExcludeSystemLogin `
 -ExcludeFilter '*MSSQL*', 'NT *', '*jobudzinski*', '*DHegwood*', '*svc_*', 'ap_*' | Out-File 'C:\Users\jobudzinski\Documents\CSSSQLRPT_Logins.txt'

# Exports Windows and SQL Logins to a T-SQL file.
Export-DbaLogin -SqlInstance 'atlsqldbcn01.atlanta.ver.com,1106' `
  -FilePath 'C:\Users\jobudzinski\source\Workspaces\DBA Source Code\Snapshots\Veritec\ILDPP\ILDPP\scripts\CreateLogins.sql' -Append

# Exports SQL Agent jobs to file
Get-DbaAgentJob -SqlInstance 'atlsqldbcn01.atlanta.ver.com,1106' | Export-DbaScript -FilePath 'C:\Users\jobudzinski\source\Workspaces\DBA Source Code\Snapshots\Veritec\ILDPP\ILDPP\scripts\SQLAgentJobs.sql' -Append

# Remove SQL Agent job
Remove-DbaAgentJob -SqlInstance 'atlsqldbcn01.atlanta.ver.com,1106', 'atlsqldbcn02.atlanta.ver.com,1106', 'atlsqldbcn03.atlanta.ver.com,1106' -Job Job1

# Returns all user database files and free space info
Get-DbaDbSpace -SqlInstance 'JAXSQLDBCN01,1107'

# Returns all user database files and free space that percent used greater than 80%
Get-DbaDbSpace -SqlInstance 'jaxsqldbcn01,1107' | Where-Object {$_.PercentUsed -gt 80}

# Returns info for all databases in msdb history
Get-DbaDbBackupHistory -SqlInstance 'ATLSQLDBCN04.Atlanta.ver.com,1106' -Database MIDPPArchive -LastFull

# Get SQL Server instance properties
Get-DbaInstanceProperty -SqlInstance 'jaxsqldbcn01,1107' | Out-GridView

# Get disk space
Get-CimInstance -ClassName Win32_logicaldisk -ComputerName 'INTSQLDEV01.Intuition.com'

# Filter above result set
Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName 'INTSQLDEV01.Intuition.com' | 
    Select-Object -Property DeviceID,@{'Name' = 'FreeSpace (GB)'; Expression= { [int]($_.FreeSpace / 1GB) }}

# Shrinks database files
Invoke-DbaDbShrink -SqlInstance 'INTSQLDEV01,1106' -PercentFreeSpace 20 -FileType Log -StepSize 50MB -AllUserDatabases

# Restore databases
Restore-DbaDatabase -SqlInstance 'INTSQLDEV01,1104' -Path '\\JAXSQLFS01\DevSQLBackups\INTSQLDEV01$FINANCE\TempRestore' -WithReplace

# Disable log backup, remove database from AG, shrink log file, add back to AG
Get-DbaAgentJob -SqlInstance 'SQLMON,1104' | Out-GridView
Set-DbaAgentJob -SqlInstance 'SQLMON,1104' -Job '2 - Beta - DatabaseBackup - USER_DATABASES - LOG' -Disabled

Get-DbaService -ComputerName 'INTSQLCN01' -InstanceName 'b2p' -Type Engine -Credential 'INTUITION\admin_obudzinski'
Get-DbaTcpPort -SqlInstance $Instance
Get-ADUser -Identity 'jaxsqlbeta02'

Remove-DbaAgDatabase -SqlInstance 'CT_Prod,1107' -Database WhatsUp,iDroneService,NetFlow,NFArchive -AvailabilityGroup CT_AG
Set-DbaDbRecoveryModel -SqlInstance 'INTSQLDEV01,1106' -RecoveryModel Simple -AllDatabases
# alter database file locations

Remove-DbaDatabase -SqlInstance 'INTSQLCN02,1107' -Database WhatsUp,iDroneService,NetFlow,NFArchive
Remove-DbaDatabase -SqlInstance 'INTSQLBETACN03,1107' -Database espeed -Confirm:$false

Get-DbaDbFile -SqlInstance $connectionstring -Database $database

Set-DbaAgentJob -SqlInstance 'SQLMON,1104' -Job '2 - Beta - DatabaseBackup - USER_DATABASES - LOG' -Enabled

# Retrieve Job History
Get-DbaAgentJobHistory -SqlInstance 'finance_prod,1104' -Job MFSQL-ContMenu.doARUpdateAll

## Bill2Pay beta remove TDE and backup for SFTP ##

# Disabled TLOG backup job
Set-DbaAgentJob -SqlInstance 'SQLMON,1104' -Job '2 - Beta - DatabaseBackup - USER_DATABASES - LOG' -Disabled
# Remove all databases from AG
Get-DbaDatabase -SqlInstance 'SQLBETA-B2P,3478' -ExcludeSystem | Remove-DbaAgDatabase -SqlInstance 'SQLBETA-B2P,3478' -Database $_.Name
# Turn off encryption (MANUALLY)
# Backup all database which are not %prodCopy%
Get-DbaDatabase  -SqlInstance 'SQLBeta-B2P,3478' -ExcludeSystem | Where-Object {$_.Name -notlike '*ProdCopy*'} | Backup-DbaDatabase -SqlInstance 'SQLBETA-ABLE,1109' -Path '\\JAXSQLFS01\B2PMoveIT' -Type FULL -CopyOnly -Initialize
# Turn on encryption (MANUALLY)
# Add databases back to AG
Get-DbaDatabase -SqlInstance 'SQLBETA-B2P,3478' | Add-DbaAgDatabase -AvailabilityGroup B2P_Beta_AG

# Gets information about one or more failover clusters in a given domain.
Get-DbaWsfcCluster -ComputerName TALISYNSQL -Credential 'INTUITION\Admin_Obudzinski'

# Gets information about one or more networks in a failover cluster.
Get-DbaWsfcNetwork -ComputerName INTSQLCN01 -Credential 'INTUITION\Admin_Obudzinski'

Stop-Computer 192.168.1.80 -Credential joshobud -Force

# Gets information on SQL services
Get-DbaService -ComputerName 'INTSQLMON03,1104' -Type Engine,Agent

# Gets job history
Get-DbaAgentJobHistory -SqlInstance 'sqlmon,1104' -Job '1 - Dev - Daily - Cycle Error Logs' -ExcludeJobSteps

# Sets the properties for a replica to an availability group on a SQL Server instance.
Set-DbaAgReplica -SqlInstance 'B2PPCI_Prod.PCI.JAX.NET,1104' -Replica 'INTSQLCN03\B2P' -AvailabilityGroup B2P_AG -SeedingMode Automatic -SessionTimeout 15 -SqlCredential jobudzinski

# Remove database user
Remove-DbaDbUser -SqlInstance 'INTSQLCN01,1105' -User YN -Force -
Get-DbaDbUser 'INTSQLCN01,1105' | Where-Object Name -like "ap_*" | Remove-DbaDbUser

Get-DbadbUser -SqlInstance 'CT_Prod,1107' -Database WhatsUp

$roles = Get-DbaDbRole -SqlInstance 'intsqlcn01,1105' -ExcludeFixedRole
$roles | Remove-DbaDbRole

Get-DbaUserPermission -SqlInstance 'CT_Prod,1107' -Database WhatsUp | Out-file 'C:\Users\jobudzinski\Documents\WhatsUpPerms.txt'

# Add replica back to Availability Group
# Need to execute ALTER AVAILABILITY GROUP [agName] GRANT CREATE ANY DATABASE; on secondary replica after command it executed.
Get-DbaAvailabilityGroup -SqlInstance 'SavingsPCI_Prod,4011' -AvailabilityGroup Savings_AG | `
    Add-DbaAgReplica -SqlInstance 'INTSQLBETACN03,1107' -SqlCredential sa -SeedingMode Automatic

# Read Extended Event files
Get-ChildItem 'F:\Microsoft SQL Server\MSSQL12.VA\MSSQL\Log\*.xel' | Read-DbaXEFile

# Pull cluster or windows event logs
Get-ClusterLog -Destination 'C:\Users\jobudzinski\Documents' -TimeSpan 300 -UseLocalTime -Node INTSQLCN01

Get-EventLog -LogName Application -ComputerName INTSQLCN01 -After '11/04/2019 05:00' -Before '11/04/2019 05:30'

# Checks all disks on a computer to see if they are formatted with allocation units of 64KB.
Test-DbaDiskAllocation -ComputerName INTSQLMON03

# Verifies that your non-dynamic disks are aligned according to physical constraints.
Test-DbaDiskAlignment -ComputerName INTSQLMON03 -Credential 'INTUITION\admin_Obudzinski' -SqlCredential jobudzinski

# Stop Service
Stop-Service -DisplayName 'SQL Server (MSSQLSERVER)'

# Start Service
Start-Service -DisplayName 'SQL Server (MSSQLSERVER)'
Start-Service -DisplayName 'SQL Server Agent (MSSQLSERVER)'

# Move files
Move-Item -Path 'D:\MICROSOFT SQL SERVER\MSSQL13.MSSQLSERVER\MSSQL\DATA\NETWRIX_AUDITOR_SQLPROD.MDF' -Destination 'G:\MICROSOFT SQL SERVER\MSSQL.MSSQLSERVER\MSSQL\DATA\Netwrix_Auditor_SQLPROD.mdf'
Move-Item -Path 'D:\MICROSOFT SQL SERVER\MSSQL13.MSSQLSERVER\MSSQL\LOG\NETWRIX_AUDITOR_SQLPROD_LOG.LDF' -Destination 'G:\MICROSOFT SQL SERVER\MSSQL.MSSQLSERVER\MSSQL\DATA\Netwrix_Auditor_SQLPROD_log.ldf'
Move-Item -Path 'D:\MICROSOFT SQL SERVER\MSSQL13.MSSQLSERVER\MSSQL\DATA\MSDBDATA.MDF' -Destination 'G:\MICROSOFT SQL SERVER\MSSQL.MSSQLSERVER\MSSQL\DATA\MSDBData.mdf'
Move-Item -Path 'D:\MICROSOFT SQL SERVER\MSSQL13.MSSQLSERVER\MSSQL\DATA\MSDBLOG.LDF' -Destination 'G:\MICROSOFT SQL SERVER\MSSQL.MSSQLSERVER\MSSQL\DATA\MSDBLog.ldf'
Move-Item -Path 'D:\MICROSOFT SQL SERVER\MSSQL13.MSSQLSERVER\MSSQL\DATA\MODEL.MDF' -Destination 'G:\MICROSOFT SQL SERVER\MSSQL.MSSQLSERVER\MSSQL\DATA\model.mdf'
Move-Item -Path 'D:\MICROSOFT SQL SERVER\MSSQL13.MSSQLSERVER\MSSQL\DATA\MODELLOG.LDF' -Destination 'G:\MICROSOFT SQL SERVER\MSSQL.MSSQLSERVER\MSSQL\DATA\modellog.ldf'


# SSRS
# List all subscriptions
$rs2010 = New-WebServiceProxy -Uri "https://SQLPROD-UTIL/ReportServer/ReportService2010.asmx" -Namespace SSRS.ReportingService2010 -UseDefaultCredential;
#$subscriptions = $rs2010.ListSubscriptions("/");  # Leave as specified to list all subscriptions under the root directory
$subscriptions = $rs2010.ListSubscriptions("/B2P/Bill2Pay/ReportsEmail/ACHReturns");
$subscriptions | Select-Object *

# List all disabled subscriptions
$rs2010 = New-WebServiceProxy -Uri "https://SQLPROD-UTIL/ReportServer/ReportService2010.asmx" -Namespace SSRS.ReportingService2010 -UseDefaultCredential;
$subscriptions = $rs2010.ListSubscriptions("/B2P");
Write-Host "--- Disabled subscriptions ---";
Write-Host "---------------------------------------";
$subscriptions | Where-Object {$_.status -eq "disabled" } | Select-Object subscriptionid, report, path, lastexecuted

# Enabled or Disable subscriptions
$rs2010 = New-WebServiceProxy -Uri "https://SQLPROD-UTIL/ReportServer/ReportService2010.asmx" -Namespace SSRS.ReportingService2010 -UseDefaultCredential;
$subscriptions = $rs2010.ListSubscriptions("/B2P");
ForEach ($subscription in $subscriptions)
{
    $rs2010.DisableSubscription($subscription.SubscriptionID);
#    $rs2010.EnableSubscription($subscription.SubscriptionID);
    $subscription | Select-Object subscriptionid, report, path
}

# Read Extended Events file
Get-DbaXESession -SqlInstance 'ATLSQLDBCN10.Atlanta.ver.com,1104' -Session 'DBA Logging' | Read-DbaXEFile

# Get SSIS execution
Get-DbaSsisExecutionHistory -SqlInstance '192.168.28.56,1109' -Status Failed,Cancelled -SqlCredential jobudzinski -Since '01/01/2020'

# Copy database assemblies between servers
Copy-DbaDbAssembly -Source 'SQLDEV-Finance,1104' -Destination 'INTSQLBETACN01,1104' -Force

# Set database as read-write
Set-DbaDbState -SqlInstance '192.168.28.56,1109' -Database PRIMAFL_201908 -ReadOnly -SqlCredential jobudzinski -Force
Get-DbaDbState -SqlInstance '192.168.28.56,1109' -SqlCredential jobudzinski | Where-Object RW -EQ 'Read_Only' | Set-DbaDbState -ReadWrite
# Add user to database role
New-DbaDbUser -SqlInstance '192.168.28.56,1109' -SqlCredential jobudzinski -Login 'ARobertson' -Username 'ARobertson'
Add-DbaDbRoleMember -SqlInstance '192.168.28.56,1109' -Role db_datareader -User 'ARobertson' -SqlCredential jobudzinski -Confirm $false
# Set database as read-only
Set-DbaDbState -SqlInstance '192.168.28.56,1109' -Database RAS -ReadOnly -Force -SqlCredential jobudzinski


# rename a database
# will update physical files and logical files
Rename-DbaDatabase -SqlInstance 'SQLBETA-VTC,1104' -Database INDPPBeta -LogicalName "INDPP_<FGN>" -WhatIf
Rename-DbaDatabase -SqlInstance '192.168.28.56,1109' -Database PRKFL_201901 -DatabaseName PRIMAFL_201912 -LogicalName PRIMAFL_201912 -SqlCredential jobudzinski

Get-DbaDbLogin -SqlInstance 

Invoke-DbaDiagnosticQuery -SqlInstance 'SQLMON,1104'

$output = Get-DbaDeprecatedFeature -SqlInstance 'ATLSQLDBCN12.Atlanta.ver.com,1104', 'ATLSQLDBCN12.Atlanta.ver.com,1105'
@($output).Count

Test-DbaMaxDop -SqlInstance 'JAXSQLDBCN06,1106'

Install-DbaFirstResponderKit -SqlInstance 'VRTSQLDEV01,1104' -Database msdb

Invoke-SqlVulnerabilityAssessmentScan -ServerInstance "INTSQLCN01,1106" -DatabaseName "ANTS" -ScanID "ObudScan"

# The purpose of this function is to find SQL Server logins that have no password 
# or the same password as login. You can add your own password to check for or add them to a csv file.
# By default it will test for empty password and the same password as username. 
Test-DbaLoginPassword -SqlInstance 'ABLEPCI_Prod.PCI.JAX.NET,1109' -SqlCredential 'ap_SchoolPortal_PC'

# Retrieve local system uptime
Get-CimInstance Win32_OperatingSystem | Select-Object LastBootUpTime

# install script for retrieving server reboots
Install-Script -Name Get-ServerUpTimeReport

# Display server reboots with duration between
Get-ServerUptimeReport.ps1 -ComputerName INTSQLCN02

# Build new Availability Group
$cred = Get-Credential sa
$cred2 = Get-Credential sa
$params = @{
    Primary = "INTSQLCN01,1106"
    PrimarySqlCredential = $cred
    Secondary = "INTSQLCN02,1106"
    SecondarySqlCredential = $cred2
    Name = "DocuphaseCS_AG"
    Database = "test1"
    SeedingMode = "Automatic"
    FailoverMode = "Manual"
    Confirm = $false
}
New-DbaAvailabilityGroup @params

# Add replica to AG
# ensure to include AvailabilityMode and FailoverMode as default is Synchronous and Automatic and check timeout value
Get-DbaAvailabilityGroup -SqlInstance 'intsqlcn01,1106' -AvailabilityGroup DocuphaseCS_AG | Add-DbaAgReplica -SqlInstance "JAXSQLDBCN06,1106" `
    -AvailabilityMode AsynchronousCommit -FailoverMode Manual -SeedingMode Automatic

# 
Get-DbatoolsLog

# Generate list of servers from CMS
Get-DbaRegServerGroup -SqlInstance 'SQLMON,1104' -Group 'Atlanta (Alpharetta, GA)\Prod'

# Invoke-DbaDiagnosticQuery runs the scripts provided by Glenn Berry's DMV scripts on specified servers
Invoke-DbaDiagnosticQuery -SqlInstance 'INTSQLMON03,1104' -UseSelectionHelper -Database DBARepository | Export-DbaDiagnosticQuery -Path C:\Users\jobudzinski\Documents
Save-DbaDiagnosticQueryScript -Path C:\Users\jobudzinski\Downloads

# Adam Machanic sp_WhoisActive
Install-DbaWhoIsActive -SqlInstance 'INTSQLMON03,1104' -Database msdb
Invoke-DbaWhoIsActive -SqlInstance 'INTSQLMON03,1104' -Database msdb

# Drop database
Remove-DbaDatabase -SqlInstance 'VRTSQLBETACN05.Intuition.com,1104' -Database 'FLADPPTEST'

# Remove SQL Agent job from multiple servers
Remove-DbaAgentJob -SqlInstance 'INTSQLCN01,1107', 'INTSQLCN02,1107', 'INTSQLCN06,1107', 'JAXSQLDBCN06,1107' -Job 'iSynergy - Monthly - ArchiveEventLogTable'
Remove-DbaAgentJob -SqlInstance 'INTSQLCN01,1107', 'INTSQLCN02,1107', 'INTSQLCN06,1107', 'JAXSQLDBCN06,1107' -Job 'iSynergy: Set Pending Status and Dates'
Remove-DbaAgentJob -SqlInstance 'INTSQLCN01,1107', 'INTSQLCN02,1107', 'INTSQLCN06,1107', 'JAXSQLDBCN06,1107' -Job 'iSynergy: Set status to open if no longer pended'
Remove-DbaAgentJob -SqlInstance 'INTSQLCN01,1107', 'INTSQLCN02,1107', 'INTSQLCN06,1107', 'JAXSQLDBCN06,1107' -Job 'iSynergy: Update incoming corr days open'
Remove-DbaAgentJob -SqlInstance 'INTSQLCN01,1107', 'INTSQLCN02,1107', 'INTSQLCN06,1107', 'JAXSQLDBCN06,1107' -Job 'Progression: Nightly Maintenance'


Set-DbaAgentJobOutputFile -SqlInstance 'INTSQLBETAUTIL,1104' -OutputFile 'D:\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\JOBS\' -WhatIf
Get-DbaAgentJob -SqlInstance 'INTSQLBETAUTIL,1104'

# Create example connection string for Docuphase to include MULTISUBNETFAILOVER option
New-DbaConnectionString -SqlInstance 'DocuphaseCSProd.Intuition.com,1106' -Database 'iSynergyProd' -Credential 'espeed' -MultiSubnetFailover 'True'

# Prevent double entry in DNS when have listener which contains 2 ips from geocluster or other means
# Best solution is including MULTISUBNETFAILOVER=TRUE in connection string, then this is not necessary
Get-ClusterResource "DocuphaseCS_AG_DocuphaseCSProd" | Get-ClusterParameter HostRecordTTL, RegisterAllProvidersIP
Get-ClusterResource "DocuphaseCS_AG_DocuphaseCSProd" | Set-ClusterParameter -Name HostRecordTTL -Value 300
Get-ClusterResource "DocuphaseCS_AG_DocuphaseCSProd" | Set-ClusterParameter -Name RegisterAllProvidersIP -Value 0
# To make changes take effect need to take listener WSFC resource offline/online
# Might want to remove dependency so it doesn't take AG offline as well
Remove-ClusterResourceDependency -Resource "DocuphaseCS_AG" -Provider "DocuphaseCS_AG_DocuphaseCSProd"
Stop-ClusterResource "DocuphaseCS_AG_DocuphaseCSProd"
Start-ClusterResource "DocuphaseCS_AG_DocuphaseCSProd"
Add-ClusterResourceDependency -Resource "DocuphaseCS_AG" -Provider "DocuphaseCS_AG_DocuphaseCSProd"


# Deploy Ola maintenance solution
Install-DbaMaintenanceSolution -SqlInstance 'SQLDEV-CS.Intuition.com,1106' -database msdb -ReplaceExisting -InstallJobs $False

# Install a new SQL Intstance via PS
$config = @{
   AGTSVCSTARTUPTYPE = "Manual"
   SQLCOLLATION = "Latin1_General_CI_AS"
   BROWSERSVCSTARTUPTYPE = "Manual"
   FILESTREAMLEVEL = 1
   }
Install-DbaInstance -SqlInstance localhost\v2017:1337 -Version 2019 -Configuration $config


# Refresh multiple databases for request
# STEP 1: move files to temporary directory
# STEP 2: restore files using temporary directory
Restore-DbaDatabase -SqlInstance 'INTSQLDEV01,1104' -Path '\\JAXSQLFS01\DevSQLBackups\INTSQLDEV01$FINANCE\TempRestore' -WithReplace
# STEP 3: update database owners back to sa
Set-DbaDbOwner -SqlInstance 'INTSQLDEV01,1104'
# STEP 4: repair orphaned users
Repair-DbaDbOrphanUser -SqlInstance 'INTSQLDEV01,1104'
# set recovery model
Set-DbaDbRecoveryModel -SqlInstance 'INTSQLDEV01,1104' -RecoveryModel Simple -AllDatabases
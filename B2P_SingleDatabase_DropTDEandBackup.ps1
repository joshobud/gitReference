$BkupInstance = 'INTSQLCN03.PCI.JAX.NET,1104'
$RptInstance = 'INTSQLCN05.PCI.JAX.NET,1104'
$databaseName = 'B2P_Milestone'
$restoreName = $databaseName+'COPY'
$encStat = 5

# Perform restore of latest full PCI

Get-DbaDbBackupHistory -LastFull -SqlInstance $BkupInstance -Database $databaseName -SqlCredential sa -Type Full -IncludeCopyOnly -Last `
    | Restore-DbaDatabase -SqlInstance $RptInstance -SqlCredential sa -DatabaseName $databaseName -DestinationDataDirectory 'Y:\data\' `
    -DestinationLogDirectory 'Y:\data\' -IgnoreLogBackup  -MaintenanceSolutionBackup

<#
# Perform restore of latest full INSIDE
Get-DbaDbBackupHistory -LastFull -SqlInstance $BkupInstance -Database $databaseName -SqlCredential jobudzinski -Type Full -IncludeCopyOnly -Last `
    | Restore-DbaDatabase -SqlInstance $RptInstance -SqlCredential jobudzinski -DatabaseName $restoreName -DestinationFilePrefix 'COPY_' #-OutputScriptOnly
#>
# Set dbowner
Set-DbaDbOwner -SqlInstance $RptInstance -Database $restoreName -SqlCredential jobudzinski

<#
# Retrieve Log file name from restored database
Get-DbaDbFile -SqlInstance $RptInstance -Database $restoreName
$LogFile = Get-DbaDbFile -SqlInstance 'intsqlcn02,1105' -Database $restoreName | Where-Object {$_.TypeDescription -eq 'LOG'} | Select LogicalName
#>

# Drop TDE encryption
$query1 = 'ALTER DATABASE ['+$restoreName+'] SET ENCRYPTION OFF;'
#write-output $query1
Invoke-DbaQuery -SqlInstance $RptInstance -SqlCredential jobudzinski -Database master -Query $query1

# Check encyption status
$query2 = "SELECT database_id FROM sys.databases WHERE name = '$restoreName'"
#write-output $query2
$database_id = (Invoke-DbaQuery -SqlInstance $RptInstance -SqlCredential jobudzinski -Database master `
    -Query $query2).database_id

$query3 = "SELECT encryption_state AS state FROM sys.dm_database_encryption_keys WHERE database_id = $database_id"
Write-Output $query3

$encStat = (Invoke-DbaQuery -SqlInstance $RptInstance -SqlCredential jobudzinski -Database master `
    -Query $query3).encStat

$encStat = $encStat.ToString()

Write-Host "Current encryption state is $encStat"

# Drop Encryption Key
Invoke-DbaQuery -SqlInstance $RptInstance -SqlCredential jobudzinski -Database $restoreName -Query 'DROP DATABASE ENCRYPTION KEY;'

# Set recovery SIMPLE
Set-DbaDbRecoveryModel -SqlInstance $RptInstance -Database $restoreName -RecoveryModel Simple

# Truncate log file and shrink
Invoke-DbaDbShrink -SqlInstance $RptInstance -Database $restoreName -FileType Log -SqlCredential jobudzinski -ShrinkMethod TruncateOnly -PercentFreeSpace 0


# Remove database users
Get-DbaDbUser -SqlInstance $RptInstance -SqlCredential jobudzinski -Database $restoreName | Remove-DbaDbUser -Force

# Set recovery FULL
Set-DbaDbRecoveryModel -SqlInstance $RptInstance -Database $restoreName -RecoveryModel Full

# Backup database
Backup-DbaDatabase -SqlInstance $RptInstance -SqlCredential jobudzinski -Database $restoreName -Type Full -CompressBackup -Path '\\JAXSQLFS01\ProdSQLbackups\'

# Drop COPY database (cleanup)
Remove-DbaDatabase -SqlInstance $RptInstance -SqlCredential jobudzinski -Database $restoreName
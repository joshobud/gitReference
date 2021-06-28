/*************************************************************************************************
*** Server Permissions Audit ***
**************************************************************************************************

This script is used for auditing the permissions that exist on a SQL Server. It will scan every
database on the server (separate scripts to run only one database are commented at the bottom)
and return four record sets:
1. Audit who is in server-level roles
2. Audit roles on each database, defining what they are and what they can do
3. Audit the roles that users are in
4. Audit any users that have access to specific objects outside of a role

NOTE: This script was written for MS SQL Server 2005 and uses undocumented system tables, rather
than the standard MS procedures. It is likely that this script will not work in future versions
of SQL Server.

Created: 2010-05-07
Jim Sebastiano

*/

DECLARE @ShowOnlyThisLogin VARCHAR(50)
SET @ShowOnlyThisLogin = NULL -- leave null for all IDs, otherwise 'SomeLogin'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF
SET NOCOUNT ON

DECLARE @currDB VARCHAR(100), @sql varchar(2000)
DECLARE @databases TABLE (dbname VARCHAR(100))

INSERT INTO @databases (dbname)
SELECT [Name]
FROM master.sys.databases
WHERE state_desc <> 'OFFLINE'

CREATE TABLE #AuditServerRoles
(	ServerName VARCHAR(100)
	, DatabaseName VARCHAR(100)
	, ServerRole VARCHAR(100)
	, MemberName VARCHAR(100)	
)
CREATE TABLE #AuditDatabaseRoleAssignments
(	ServerName VARCHAR(100)
	, DatabaseName VARCHAR(100)
	, RoleName VARCHAR(100)
	, UserName VARCHAR(100)
)
CREATE TABLE #AuditDatabaseRoles
(	ServerName VARCHAR(100)
	, DatabaseName VARCHAR(100)
	, RoleName VARCHAR(100)
	, SchemaName VARCHAR(100)
	, ObjectName VARCHAR(100)
	, PermissionType VARCHAR(100)
	, StateDesc VARCHAR(100)
	, Grantor VARCHAR(100)
)
CREATE TABLE #AuditUserLevelAssignments
(	ServerName VARCHAR(100)
	, DatabaseName VARCHAR(100)
	, SchemaName VARCHAR(100)
	, ObjectName VARCHAR(100)
	, ObjectType VARCHAR(100)
	, Grantee VARCHAR(100)
	, Grantor VARCHAR(100)
	, UserType VARCHAR(100)
	, PermissionType VARCHAR(100)
	, PermissionState VARCHAR(100)
)

-- Step 1: Audit who is in server-level roles
INSERT INTO #AuditServerRoles
SELECT
    @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName,
    SUSER_NAME(rm.role_principal_id) AS ServerRole, lgn.name AS MemberName
FROM
    sys.server_role_members rm
    INNER JOIN sys.server_principals lgn
        ON rm.role_principal_id >=3 AND rm.role_principal_id <=10
        AND rm.member_principal_id = lgn.principal_id
ORDER BY 1, 2, 3, 4

-- loop through all databases
while exists (select * from @databases)
begin
    set @currDB = (select top 1 dbname from @databases order by dbname)
    PRINT @currdb

    -- Step 2: Audit roles on each database, defining what they are, what they can do, and who belongs in them
    INSERT INTO #AuditDatabaseRoles
    exec ('use ' + @currdb + '; 
        SELECT @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName, dprin.name AS RoleName,
            ISNULL(sch.name, osch.name) AS SchemaName, ISNULL(o.name, ''.'') AS ObjectName,
            dperm.permission_name, dperm.state_desc, grantor.name AS Grantor
        FROM
            sys.database_permissions dperm
            INNER JOIN sys.database_principals dprin
                ON dperm.grantee_principal_id = dprin.principal_id
            INNER JOIN sys.database_principals grantor
                ON dperm.grantor_principal_id = grantor.principal_id
            LEFT OUTER JOIN sys.schemas sch
                ON dperm.major_id = sch.schema_id AND dperm.class = 3
            LEFT OUTER JOIN sys.all_objects o
                ON dperm.major_id = o.OBJECT_ID AND dperm.class = 1
            LEFT OUTER JOIN sys.schemas osch
                ON o.schema_id = osch.schema_id
        WHERE dprin.name <> ''public'' AND dperm.type <> ''CO'' AND dprin.type = ''R''
        ORDER BY 1, 2, 3, 4, 5, 6')
    -- Step 3: Audit the roles that users are in
    INSERT INTO #AuditDatabaseRoleAssignments
    exec ('use ' + @currdb + '; 
        SELECT
            @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName,
            CASE WHEN (r.principal_id IS NULL) THEN ''public''
            ELSE r.name
            END AS RoleName,
            u.name AS UserName
        FROM
            sys.database_principals u
            LEFT JOIN (sys.database_role_members m JOIN sys.database_principals r ON m.role_principal_id = r.principal_id)
                ON m.member_principal_id = u.principal_id
        
        ORDER BY 1, 2, 3, 4')
    -- Step 4: Audit any users that have access to specific objects outside of a role
    INSERT INTO #AuditUserLevelAssignments
    exec ('use ' + @currdb + '; 
        SELECT
            @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName, 
            ISNULL(sch.name, osch.name) AS SchemaName, ISNULL(o.name, ''.'') AS ObjectName,
            o.type_desc,
            dprin.NAME AS Grantee,
            grantor.name AS Grantor,
            dprin.type_desc AS principal_type_desc,
            dperm.permission_name,
            dperm.state_desc AS permission_state_desc 
        FROM
            sys.database_permissions dperm
            INNER JOIN sys.database_principals dprin
                ON dperm.grantee_principal_id = dprin.principal_id
            INNER JOIN sys.database_principals grantor
                ON dperm.grantor_principal_id = grantor.principal_id
            LEFT OUTER JOIN sys.schemas sch
                ON dperm.major_id = sch.schema_id AND dperm.class = 3
            LEFT OUTER JOIN sys.all_objects o
                ON dperm.major_id = o.OBJECT_ID AND dperm.class = 1
            LEFT OUTER JOIN sys.schemas osch
                ON o.schema_id = osch.schema_id
        WHERE dprin.name <> ''public'' AND dperm.type <> ''CO'' AND dprin.type <> ''R''
        ORDER BY 1, 2, 3, 4, 5')

 delete from @databases where dbname = @currDB
END

IF (@ShowOnlyThisLogin IS NULL)
BEGIN
    --SELECT 'Server Roles', * FROM #AuditServerRoles ORDER BY 1,2,3,4,5
    --SELECT 'Database Roles', * FROM #AuditDatabaseRoles ORDER BY 1,2,3,4,5,6,7
    --SELECT 'DB Role Assignments', * FROM #AuditDatabaseRoleAssignments ORDER BY 1,2,3,4,5
    --SELECT 'User Level Assignments', * FROM #AuditUserLevelAssignments ORDER BY 1,2,3,4,5,6
	SELECT ServerName, DatabaseName, 'Server Roles', ServerRole, MemberName, '', '', '', '', '', '', '', '' 
	FROM #AuditServerRoles
	UNION ALL
	SELECT ServerName, DatabaseName, 'DB Role Assignments', RoleName, UserName, '', '', '', '', '', '', '', '' 
	FROM #AuditDatabaseRoleAssignments
	UNION ALL
	SELECT ServerName, DatabaseName, 'Database Roles', RoleName, '', SchemaName, ObjectName, PermissionType, StateDesc, Grantor, '', '', '' 
	FROM #AuditDatabaseRoles
	UNION ALL
	SELECT ServerName, DatabaseName, 'User Level Assignments', '', '', SchemaName, ObjectName, PermissionType, PermissionState, Grantor, ObjectType, Grantee, UserType 
	FROM #AuditUserLevelAssignments
END 
ELSE 
BEGIN
    SELECT 'Server Roles', * FROM #AuditServerRoles WHERE MemberName = @ShowOnlyThisLogin ORDER BY 1,2,3,4,5
    SELECT 'DB Role Assignments', * FROM #AuditDatabaseRoleAssignments WHERE UserName = @ShowOnlyThisLogin ORDER BY 1,2,3,4,5
    SELECT 'User Level Assignments', * FROM #AuditUserLevelAssignments WHERE Grantee = @ShowOnlyThisLogin ORDER BY 1,2,3,4,5,6
END

DROP TABLE #AuditServerRoles, #AuditDatabaseRoles, #AuditDatabaseRoleAssignments, #AuditUserLevelAssignments


/* originals
-- Step 1: Audit who is in server-level roles
    SELECT
        @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName,
        SUSER_NAME(rm.role_principal_id) AS ServerRole, lgn.name AS MemberName
    FROM
        sys.server_role_members rm
        INNER JOIN sys.server_principals lgn
            ON rm.role_principal_id >=3 AND rm.role_principal_id <=10
            AND rm.member_principal_id = lgn.principal_id
    ORDER BY 1, 2, 3, 4

-- Step 2: Audit roles on each database, defining what they are, what they can do, and who belongs in them
    SELECT @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName, dprin.name AS RoleName,
        ISNULL(sch.name, osch.name) AS SchemaName, ISNULL(o.name, '.') AS ObjectName,
        dperm.permission_name, dperm.state_desc, grantor.name AS Grantor
    FROM
        sys.database_permissions dperm
        INNER JOIN sys.database_principals dprin
            ON dperm.grantee_principal_id = dprin.principal_id
        INNER JOIN sys.database_principals grantor
            ON dperm.grantor_principal_id = grantor.principal_id
        LEFT OUTER JOIN sys.schemas sch
            ON dperm.major_id = sch.schema_id AND dperm.class = 3
        LEFT OUTER JOIN sys.all_objects o
            ON dperm.major_id = o.OBJECT_ID AND dperm.class = 1
        LEFT OUTER JOIN sys.schemas osch
            ON o.schema_id = osch.schema_id
    WHERE dprin.name <> 'public' AND dperm.type <> 'CO' AND dprin.type = 'R'
    ORDER BY 1, 2, 3, 4, 5, 6
-- Step 3: Audit the roles that users are in
    SELECT
        @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName,
        CASE WHEN (r.principal_id IS NULL) THEN 'public'
        ELSE r.name
        END AS RoleName,
        u.name AS UserName
    FROM
        sys.database_principals u
        LEFT JOIN (sys.database_role_members m JOIN sys.database_principals r ON m.role_principal_id = r.principal_id)
            ON m.member_principal_id = u.principal_id
    --WHERE u.type <> 'R'
    ORDER BY 1, 2, 3, 4
-- Step 4: Audit any users that have access to specific objects outside of a role
    SELECT
        @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName, 
        ISNULL(sch.name, osch.name) AS SchemaName, ISNULL(o.name, '.') AS ObjectName,
        o.type_desc,
        dprin.NAME AS Grantee,
        grantor.name AS Grantor,
        dprin.type_desc AS principal_type_desc,
        dperm.permission_name,
        dperm.state_desc AS permission_state_desc 
    FROM
        sys.database_permissions dperm
        INNER JOIN sys.database_principals dprin
            ON dperm.grantee_principal_id = dprin.principal_id
        INNER JOIN sys.database_principals grantor
            ON dperm.grantor_principal_id = grantor.principal_id
        LEFT OUTER JOIN sys.schemas sch
            ON dperm.major_id = sch.schema_id AND dperm.class = 3
        LEFT OUTER JOIN sys.all_objects o
            ON dperm.major_id = o.OBJECT_ID AND dperm.class = 1
        LEFT OUTER JOIN sys.schemas osch
            ON o.schema_id = osch.schema_id
    WHERE dprin.name <> 'public' AND dperm.type <> 'CO' AND dprin.type <> 'R'
    ORDER BY 1, 2, 3, 4, 5
*/


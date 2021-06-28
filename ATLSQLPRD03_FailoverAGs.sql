-- Execute on SQLPRD-VTC-FLCC.Atlanta.ver.com,1104

:Connect ATLSQLDBCN08.Atlanta.ver.com,1104

USE [master];

ALTER AVAILABILITY GROUP [FloridaCC_AG] FAILOVER;


:Connect ATLSQLDBCN08.Atlanta.ver.com,1106

USE [master];

ALTER AVAILABILITY GROUP [SouthCarolina_AG] FAILOVER;

:Connect ATLSQLDBCN07.Atlanta.ver.com,1108
-- disable jobs before failing over the Reporting Services dbs
USE [msdb];

--SELECT [name], 'EXEC sp_update_job @job_name = '''+name+''', @enabled = 1;'
--FROM dbo.sysjobs
--WHERE [name] NOT LIKE 'Database%'
--AND [name] NOT LIKE 'Index%'
--AND [name] <> 'syspolicy_purge_history'
--AND [enabled] = 1;

EXEC sp_update_job @job_name = 'ECC29E5D-B118-45CC-B18C-A9E64D1FA689', @enabled = 0;
EXEC sp_update_job @job_name = '9FE34B36-3886-42D6-959F-40ED4B58B28E', @enabled = 0;
EXEC sp_update_job @job_name = '98CA22BB-C5E8-4AE2-B889-926783E98FF7', @enabled = 0;
EXEC sp_update_job @job_name = '1AA1EB63-3CCA-401F-90C4-87C7EE418808', @enabled = 0;
EXEC sp_update_job @job_name = '570F4714-3550-4A76-A0D8-78376704F4EF', @enabled = 0;
EXEC sp_update_job @job_name = 'BDECA3FD-543B-4408-9C4E-950B26A9FAA9', @enabled = 0;
EXEC sp_update_job @job_name = '548B67A5-D612-4539-8FCE-0A7627F0FE25', @enabled = 0;
EXEC sp_update_job @job_name = '51B3244B-1212-4CC0-AFF3-DDE06113F903', @enabled = 0;
EXEC sp_update_job @job_name = '421592FD-07B6-48FE-8155-C4679B5EA703', @enabled = 0;
EXEC sp_update_job @job_name = 'CB495802-329C-46EE-B345-008EC10C0CE0', @enabled = 0;
EXEC sp_update_job @job_name = 'C584A8B7-29FD-4DBA-96C9-0AED787A7D2E', @enabled = 0;
EXEC sp_update_job @job_name = 'E96C4D30-35A0-4273-BDA4-BEE1A8FB652D', @enabled = 0;
EXEC sp_update_job @job_name = '6380DAD2-D18A-4536-B576-334FDCEF343A', @enabled = 0;
EXEC sp_update_job @job_name = '9CC49679-3CC2-4CCC-8955-EA05914F7465', @enabled = 0;
EXEC sp_update_job @job_name = '827E9394-2D0E-4060-B8A7-1FF4AF958ABE', @enabled = 0;
EXEC sp_update_job @job_name = 'EAC4045A-F454-4B7F-9839-A408BBB04622', @enabled = 0;
EXEC sp_update_job @job_name = '2744C690-18E1-44D1-84F4-076E666507F1', @enabled = 0;
EXEC sp_update_job @job_name = '215213A1-5CC7-4750-870F-BFCB74A0F663', @enabled = 0;
EXEC sp_update_job @job_name = '96B225DE-F669-43F8-846F-F512C46CC979', @enabled = 0;
EXEC sp_update_job @job_name = 'DEC663D8-AF4E-4FD0-8324-1025DB7283ED', @enabled = 0;
EXEC sp_update_job @job_name = 'BF920AB9-0D5D-4260-87B6-ABCD404DBB46', @enabled = 0;
EXEC sp_update_job @job_name = '35574042-5C5F-4D00-82F3-87775BE4460C', @enabled = 0;
EXEC sp_update_job @job_name = '211D9C4E-1952-4C76-AE1B-A405FE88C70C', @enabled = 0;
EXEC sp_update_job @job_name = '374B6CB6-CA4B-4E7F-A8A2-862916BD6676', @enabled = 0;
EXEC sp_update_job @job_name = '08F7B687-3892-4975-9D5D-BC86EF721DC1', @enabled = 0;
EXEC sp_update_job @job_name = 'E2C2CEB0-26C5-448C-8E7B-71A82EC4A7EA', @enabled = 0;
EXEC sp_update_job @job_name = '85552395-E319-4339-96E1-096E9FF74226', @enabled = 0;
EXEC sp_update_job @job_name = '338E40A1-8F15-44F1-B677-14EBD44A6E0B', @enabled = 0;
EXEC sp_update_job @job_name = 'A330AE83-299C-4C24-92A1-855E41199AC1', @enabled = 0;
EXEC sp_update_job @job_name = '5AF6423E-567A-4028-B432-CCD4BCD8C0A7', @enabled = 0;
EXEC sp_update_job @job_name = '6431CEA9-79ED-4458-827E-AC5D92DCF6AF', @enabled = 0;
EXEC sp_update_job @job_name = 'EE89F545-3848-403B-8452-EA9BD6C6275F', @enabled = 0;
EXEC sp_update_job @job_name = '9DF0D6CE-A964-4157-AB2F-AD39DFBF65E4', @enabled = 0;
EXEC sp_update_job @job_name = '1AAF8BBD-D1D6-4C3D-9E13-DEF83C1B1C8D', @enabled = 0;
EXEC sp_update_job @job_name = '58808346-A836-4293-BB30-33BBCABA848E', @enabled = 0;
EXEC sp_update_job @job_name = '27144844-D706-4BC9-950F-3C325B072DF7', @enabled = 0;
EXEC sp_update_job @job_name = 'DC2F551F-F16D-4EC7-B7C2-A4A0C2BF886A', @enabled = 0;
EXEC sp_update_job @job_name = '32216F74-3061-438E-B8CA-0CCE073584F3', @enabled = 0;
EXEC sp_update_job @job_name = '1D9C3298-2CD8-4818-B7C2-812BF3C686CA', @enabled = 0;
EXEC sp_update_job @job_name = '18346309-2F99-4C73-AE38-EF8C69AB1641', @enabled = 0;
EXEC sp_update_job @job_name = '17C49F05-1DC3-45BE-AB7E-77B9184A032B', @enabled = 0;
EXEC sp_update_job @job_name = '00E44522-4981-4F2A-B0C4-BD049085B696', @enabled = 0;
EXEC sp_update_job @job_name = '1C623E09-DB3E-45D7-8595-B8417E39D3F9', @enabled = 0;
EXEC sp_update_job @job_name = '7F0A4EE7-5228-42D7-94E7-E65F33B7E1B9', @enabled = 0;
EXEC sp_update_job @job_name = '24AF53DA-DEF2-4DC2-A24E-69D86F444D9C', @enabled = 0;
EXEC sp_update_job @job_name = '97E54DC1-61ED-4AB3-BB25-4594C9318322', @enabled = 0;
EXEC sp_update_job @job_name = '42977C9A-5DD6-4220-BBC6-7B02AF0DB3FE', @enabled = 0;
EXEC sp_update_job @job_name = '807C1B62-811A-4EDF-9C6D-F1F101BAFCA1', @enabled = 0;
EXEC sp_update_job @job_name = '84FD3FFE-D43B-44B1-BAE0-505973660E3E', @enabled = 0;
EXEC sp_update_job @job_name = '185E0284-657A-493E-A47E-F38B845B7B50', @enabled = 0;
EXEC sp_update_job @job_name = '98970F6C-D903-40AA-8115-8E5DC55C947A', @enabled = 0;
EXEC sp_update_job @job_name = 'CE6327D8-5061-469A-AD3A-56249895A1BD', @enabled = 0;
EXEC sp_update_job @job_name = '771BA43F-2E26-434F-9D03-9EAD1AEF9FA9', @enabled = 0;
EXEC sp_update_job @job_name = '303041CD-5CF4-4A83-A09D-CE069E97AE06', @enabled = 0;
EXEC sp_update_job @job_name = 'B7103E94-6B1F-49F1-85DF-8B8D70EFFD19', @enabled = 0;
EXEC sp_update_job @job_name = '89B7B2A8-2CB3-4E66-895B-756F4F013AA8', @enabled = 0;
EXEC sp_update_job @job_name = '4E824BD9-180F-4DA2-958D-86505F3F8168', @enabled = 0;
EXEC sp_update_job @job_name = '86305C15-0CA0-4536-9A1F-53D887282D46', @enabled = 0;
EXEC sp_update_job @job_name = '6B16A52E-3FE4-4A5E-8394-82515EC435FB', @enabled = 0;
EXEC sp_update_job @job_name = 'BAC7FA95-C358-41BF-853D-4061596C8160', @enabled = 0;
EXEC sp_update_job @job_name = '87BCCFE9-728A-4EFA-B052-F2D626C939FC', @enabled = 0;
EXEC sp_update_job @job_name = '14CF5E5C-7CAA-4653-944F-94AAF25DB5BF', @enabled = 0;
EXEC sp_update_job @job_name = 'A0C4AE74-1862-4D93-A118-F28EA3427265', @enabled = 0;
EXEC sp_update_job @job_name = 'DAE3470E-A686-45BE-9C98-9D775A3D95A2', @enabled = 0;
EXEC sp_update_job @job_name = '1306B0DD-15B6-4F41-8A69-6C772D9711CA', @enabled = 0;
EXEC sp_update_job @job_name = '39BC096F-8305-4A8A-942A-D0546AD00007', @enabled = 0;
EXEC sp_update_job @job_name = 'DD2DE9CC-F8AB-4CB4-9B59-B8BFDF4D7276', @enabled = 0;
EXEC sp_update_job @job_name = '370822EE-9D00-408D-9967-DE0965A16E0A', @enabled = 0;
EXEC sp_update_job @job_name = 'AD51C1EB-3DC0-4B34-8630-96D4D1997B3A', @enabled = 0;
EXEC sp_update_job @job_name = '0CA16FF1-E1F7-4D6D-8A45-17C5A7C35B72', @enabled = 0;
EXEC sp_update_job @job_name = '90DE3BE2-B931-4709-B447-A85654EF0CBC', @enabled = 0;
EXEC sp_update_job @job_name = '410A5ED0-9C93-4D14-BB7E-840E3859E46E', @enabled = 0;
EXEC sp_update_job @job_name = 'F2EE07D1-96A0-4B78-939B-BDDA9675128B', @enabled = 0;
EXEC sp_update_job @job_name = '00B884DC-D5F6-40D8-BEB5-F1B01F2AF651', @enabled = 0;

:Connect ATLSQLDBCN08.Atlanta.ver.com,1108

USE [master];

ALTER AVAILABILITY GROUP [SSN_AG] FAILOVER;
ALTER AVAILABILITY GROUP [SSRS_AG] FAILOVER;  --Need to restart Reporting Services on ATLSSRS2012

:Connect ATLSQLDBCN08.Atlanta.ver.com,1108
-- enable jobs after failing over Reporting Service databases
-- does restart of SSRS after failover automatically enable jobs???
USE [msdb];

EXEC sp_update_job @job_name = 'ECC29E5D-B118-45CC-B18C-A9E64D1FA689', @enabled = 1;
EXEC sp_update_job @job_name = '9FE34B36-3886-42D6-959F-40ED4B58B28E', @enabled = 1;
EXEC sp_update_job @job_name = '98CA22BB-C5E8-4AE2-B889-926783E98FF7', @enabled = 1;
EXEC sp_update_job @job_name = '1AA1EB63-3CCA-401F-90C4-87C7EE418808', @enabled = 1;
EXEC sp_update_job @job_name = '570F4714-3550-4A76-A0D8-78376704F4EF', @enabled = 1;
EXEC sp_update_job @job_name = 'BDECA3FD-543B-4408-9C4E-950B26A9FAA9', @enabled = 1;
EXEC sp_update_job @job_name = '548B67A5-D612-4539-8FCE-0A7627F0FE25', @enabled = 1;
EXEC sp_update_job @job_name = '51B3244B-1212-4CC0-AFF3-DDE06113F903', @enabled = 1;
EXEC sp_update_job @job_name = '421592FD-07B6-48FE-8155-C4679B5EA703', @enabled = 1;
EXEC sp_update_job @job_name = 'CB495802-329C-46EE-B345-008EC10C0CE0', @enabled = 1;
EXEC sp_update_job @job_name = 'C584A8B7-29FD-4DBA-96C9-0AED787A7D2E', @enabled = 1;
EXEC sp_update_job @job_name = 'E96C4D30-35A0-4273-BDA4-BEE1A8FB652D', @enabled = 1;
EXEC sp_update_job @job_name = '6380DAD2-D18A-4536-B576-334FDCEF343A', @enabled = 1;
EXEC sp_update_job @job_name = '9CC49679-3CC2-4CCC-8955-EA05914F7465', @enabled = 1;
EXEC sp_update_job @job_name = '827E9394-2D0E-4060-B8A7-1FF4AF958ABE', @enabled = 1;
EXEC sp_update_job @job_name = 'EAC4045A-F454-4B7F-9839-A408BBB04622', @enabled = 1;
EXEC sp_update_job @job_name = '2744C690-18E1-44D1-84F4-076E666507F1', @enabled = 1;
EXEC sp_update_job @job_name = '215213A1-5CC7-4750-870F-BFCB74A0F663', @enabled = 1;
EXEC sp_update_job @job_name = '96B225DE-F669-43F8-846F-F512C46CC979', @enabled = 1;
EXEC sp_update_job @job_name = 'DEC663D8-AF4E-4FD0-8324-1025DB7283ED', @enabled = 1;
EXEC sp_update_job @job_name = 'BF920AB9-0D5D-4260-87B6-ABCD404DBB46', @enabled = 1;
EXEC sp_update_job @job_name = '35574042-5C5F-4D00-82F3-87775BE4460C', @enabled = 1;
EXEC sp_update_job @job_name = '211D9C4E-1952-4C76-AE1B-A405FE88C70C', @enabled = 1;
EXEC sp_update_job @job_name = '374B6CB6-CA4B-4E7F-A8A2-862916BD6676', @enabled = 1;
EXEC sp_update_job @job_name = '08F7B687-3892-4975-9D5D-BC86EF721DC1', @enabled = 1;
EXEC sp_update_job @job_name = 'E2C2CEB0-26C5-448C-8E7B-71A82EC4A7EA', @enabled = 1;
EXEC sp_update_job @job_name = '85552395-E319-4339-96E1-096E9FF74226', @enabled = 1;
EXEC sp_update_job @job_name = '338E40A1-8F15-44F1-B677-14EBD44A6E0B', @enabled = 1;
EXEC sp_update_job @job_name = 'A330AE83-299C-4C24-92A1-855E41199AC1', @enabled = 1;
EXEC sp_update_job @job_name = '5AF6423E-567A-4028-B432-CCD4BCD8C0A7', @enabled = 1;
EXEC sp_update_job @job_name = '6431CEA9-79ED-4458-827E-AC5D92DCF6AF', @enabled = 1;
EXEC sp_update_job @job_name = 'EE89F545-3848-403B-8452-EA9BD6C6275F', @enabled = 1;
EXEC sp_update_job @job_name = '9DF0D6CE-A964-4157-AB2F-AD39DFBF65E4', @enabled = 1;
EXEC sp_update_job @job_name = '1AAF8BBD-D1D6-4C3D-9E13-DEF83C1B1C8D', @enabled = 1;
EXEC sp_update_job @job_name = '58808346-A836-4293-BB30-33BBCABA848E', @enabled = 1;
EXEC sp_update_job @job_name = '27144844-D706-4BC9-950F-3C325B072DF7', @enabled = 1;
EXEC sp_update_job @job_name = 'DC2F551F-F16D-4EC7-B7C2-A4A0C2BF886A', @enabled = 1;
EXEC sp_update_job @job_name = '32216F74-3061-438E-B8CA-0CCE073584F3', @enabled = 1;
EXEC sp_update_job @job_name = '1D9C3298-2CD8-4818-B7C2-812BF3C686CA', @enabled = 1;
EXEC sp_update_job @job_name = '18346309-2F99-4C73-AE38-EF8C69AB1641', @enabled = 1;
EXEC sp_update_job @job_name = '17C49F05-1DC3-45BE-AB7E-77B9184A032B', @enabled = 1;
EXEC sp_update_job @job_name = '00E44522-4981-4F2A-B0C4-BD049085B696', @enabled = 1;
EXEC sp_update_job @job_name = '1C623E09-DB3E-45D7-8595-B8417E39D3F9', @enabled = 1;
EXEC sp_update_job @job_name = '7F0A4EE7-5228-42D7-94E7-E65F33B7E1B9', @enabled = 1;
EXEC sp_update_job @job_name = '24AF53DA-DEF2-4DC2-A24E-69D86F444D9C', @enabled = 1;
EXEC sp_update_job @job_name = '97E54DC1-61ED-4AB3-BB25-4594C9318322', @enabled = 1;
EXEC sp_update_job @job_name = '42977C9A-5DD6-4220-BBC6-7B02AF0DB3FE', @enabled = 1;
EXEC sp_update_job @job_name = '807C1B62-811A-4EDF-9C6D-F1F101BAFCA1', @enabled = 1;
EXEC sp_update_job @job_name = '84FD3FFE-D43B-44B1-BAE0-505973660E3E', @enabled = 1;
EXEC sp_update_job @job_name = '185E0284-657A-493E-A47E-F38B845B7B50', @enabled = 1;
EXEC sp_update_job @job_name = '98970F6C-D903-40AA-8115-8E5DC55C947A', @enabled = 1;
EXEC sp_update_job @job_name = 'CE6327D8-5061-469A-AD3A-56249895A1BD', @enabled = 1;
EXEC sp_update_job @job_name = '771BA43F-2E26-434F-9D03-9EAD1AEF9FA9', @enabled = 1;
EXEC sp_update_job @job_name = '303041CD-5CF4-4A83-A09D-CE069E97AE06', @enabled = 1;
EXEC sp_update_job @job_name = 'B7103E94-6B1F-49F1-85DF-8B8D70EFFD19', @enabled = 1;
EXEC sp_update_job @job_name = '89B7B2A8-2CB3-4E66-895B-756F4F013AA8', @enabled = 1;
EXEC sp_update_job @job_name = '4E824BD9-180F-4DA2-958D-86505F3F8168', @enabled = 1;
EXEC sp_update_job @job_name = '86305C15-0CA0-4536-9A1F-53D887282D46', @enabled = 1;
EXEC sp_update_job @job_name = '6B16A52E-3FE4-4A5E-8394-82515EC435FB', @enabled = 1;
EXEC sp_update_job @job_name = 'BAC7FA95-C358-41BF-853D-4061596C8160', @enabled = 1;
EXEC sp_update_job @job_name = '87BCCFE9-728A-4EFA-B052-F2D626C939FC', @enabled = 1;
EXEC sp_update_job @job_name = '14CF5E5C-7CAA-4653-944F-94AAF25DB5BF', @enabled = 1;
EXEC sp_update_job @job_name = 'A0C4AE74-1862-4D93-A118-F28EA3427265', @enabled = 1;
EXEC sp_update_job @job_name = 'DAE3470E-A686-45BE-9C98-9D775A3D95A2', @enabled = 1;
EXEC sp_update_job @job_name = '1306B0DD-15B6-4F41-8A69-6C772D9711CA', @enabled = 1;
EXEC sp_update_job @job_name = '39BC096F-8305-4A8A-942A-D0546AD00007', @enabled = 1;
EXEC sp_update_job @job_name = 'DD2DE9CC-F8AB-4CB4-9B59-B8BFDF4D7276', @enabled = 1;
EXEC sp_update_job @job_name = '370822EE-9D00-408D-9967-DE0965A16E0A', @enabled = 1;
EXEC sp_update_job @job_name = 'AD51C1EB-3DC0-4B34-8630-96D4D1997B3A', @enabled = 1;
EXEC sp_update_job @job_name = '0CA16FF1-E1F7-4D6D-8A45-17C5A7C35B72', @enabled = 1;
EXEC sp_update_job @job_name = '90DE3BE2-B931-4709-B447-A85654EF0CBC', @enabled = 1;
EXEC sp_update_job @job_name = '410A5ED0-9C93-4D14-BB7E-840E3859E46E', @enabled = 1;
EXEC sp_update_job @job_name = 'F2EE07D1-96A0-4B78-939B-BDDA9675128B', @enabled = 1;
EXEC sp_update_job @job_name = '00B884DC-D5F6-40D8-BEB5-F1B01F2AF651', @enabled = 1;

:Connect ATLSQLDBCN08.Atlanta.ver.com,1105

USE [master];

ALTER AVAILABILITY GROUP [Virginia_AG] FAILOVER;
USE [DBACentral]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_]
/*********************************************************************************************
PURPOSE:	Purpose of this....
----------------------------------------------------------------------------------------------
REVISION HISTORY:
Date			Developer Name			Change Description	
----------		--------------			------------------
03/16/2014		Josh Obudzinski			Original Version
----------------------------------------------------------------------------------------------
USAGE:		EXEC DBACentral.dbo.usp_

**********************************************************************************************/
	@serverRole BIT = 0			-- comparison between server_roles & server_roles_stage

AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRY


END TRY
BEGIN CATCH

    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

	-- drop temp tables if they exist


    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    -- Use RAISERROR inside the CATCH block to return error
    -- information about the original error that caused
    -- execution to jump to the CATCH block.
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );

END CATCH
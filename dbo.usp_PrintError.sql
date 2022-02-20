
use Project_DB
go

IF OBJECT_ID('dbo.usp_PrintError') IS NOT NULL
DROP PROCEDURE dbo.usp_PrintError
GO

CREATE PROCEDURE dbo.usp_PrintError
    @error varchar(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    select @error = 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', State ' + CONVERT(varchar(5), ERROR_STATE()) +
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') +
          ', Line ' + CONVERT(varchar(5), ERROR_LINE()) + ',
		  Message: '+ CONVERT(varchar(MAX), ERROR_MESSAGE());

    -- Print error information.
    PRINT @error
    --PRINT ERROR_MESSAGE();


END;
go

exec sp_addextendedproperty 'MS_Description', 'Prints error information about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without printing any error information.', 'SCHEMA', 'dbo', 'PROCEDURE', 'usp_PrintError'
go
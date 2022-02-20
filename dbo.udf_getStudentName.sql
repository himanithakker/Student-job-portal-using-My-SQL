USE Project_DB
GO

IF OBJECT_ID('dbo.udf_getStudentName') IS NOT NULL
DROP FUNCTION dbo.udf_getStudentName
GO

CREATE FUNCTION dbo.udf_getStudentName(@StudentID INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @FullName VARCHAR(100)
	
	SELECT @FullName = CONCAT(FirstName,' '+LastName)
	FROM applicant.STUDENT
	
	RETURN @FullName
END


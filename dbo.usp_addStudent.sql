

USE Project_DB
GO


IF OBJECT_ID('dbo.usp_addStudent') IS NOT NULL
DROP PROCEDURE dbo.usp_addStudent
GO

CREATE PROCEDURE dbo.usp_addStudent(
	@FirstName VARCHAR(50),
	@LastName VARCHAR(50) = NULL,
	@Email VARCHAR(40) = NULL,
	@phone VARCHAR(20) = NULL,
	@DOB DATE = NULL,
	@SSN VARCHAR(20) = NULL,
	@resume XML = NULL,
	@advisor_ID INT = NULL,
	@Location_ID INT = NULL,
	@Graduation_Date DATE = NULL,
	@output VARCHAR(200) OUTPUT
	)
AS
BEGIN

BEGIN TRY

	INSERT INTO applicant.STUDENT (
		FirstName,
		LastName,
		Email,
		phone,
		DOB,
		SSN,
		resume,
		advisor_ID,
		Location_ID,
		Graduation_Date
	)
	SELECT @FirstName,
		@LastName,
		@Email,
		@phone,
		@DOB,
		EncryptByKey(Key_GUID('Team10_Crt_SM'),  @SSN),
		@resume,
		@advisor_ID,
		@Location_ID,
		@Graduation_Date

	SELECT @output = CONCAT('New StudentID: ', (SELECT MAX(Student_ID) FROM applicant.STUDENT))

END TRY

BEGIN CATCH

	EXEC dbo.usp_PrintError @output

END CATCH

END

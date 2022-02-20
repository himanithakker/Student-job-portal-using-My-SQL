USE Project_DB
GO

IF OBJECT_ID('dbo.usp_updateStudent') IS NOT NULL
DROP PROCEDURE dbo.usp_updateStudent
GO

CREATE PROCEDURE dbo.usp_updateStudent ( 
	@Student_ID INT,
	@FirstName VARCHAR(50) = NULL,
	@LastName VARCHAR(50) = NULL,
	@Email VARCHAR(40) = NULL,
	@phone NUMERIC(18,0) = NULL,
	@DOB DATE = NULL,
	@SSN VARBINARY(200) = NULL,
	@resume XML = NULL,
	@advisor_ID INT = NULL,
	@Location_ID INT = NULL,
	@Graduation_Date DATE = NULL,
	@output VARCHAR(200) OUTPUT
	)
AS
BEGIN

BEGIN TRY

	UPDATE s
	SET FirstName = ISNULL(@FirstName, FirstName),
		LastName = ISNULL(@LastName, LastName),
		Email = ISNULL(@Email, Email),
		Phone = ISNULL(@phone, Phone),
		DOB = ISNULL(@DOB, DOB),
		SSN = ISNULL(EncryptByKey(Key_GUID('Team10_Crt_SM'),  @SSN), SSN),
		Resume = ISNULL(@resume, Resume),
		Advisor_ID = ISNULL(@advisor_ID, Advisor_ID),
		Location_ID = ISNULL(@Location_ID, Location_ID),
		Graduation_Date = ISNULL(@Graduation_Date, Graduation_Date)
	FROM applicant.STUDENT s
	WHERE s.Student_ID = @Student_ID

	SELECT @output = CONCAT('Updated data for StudentID: ', @Student_ID,
		'FirstName: ' + @FirstName,
		'LastName: ' + @LastName,
		'Email: ' + @Email,
		'Phone: ' + CONVERT(VARCHAR(20),@phone),
		'DOB: ' + CONVERT(VARCHAR(20),@DOB),
		'SSN: XXX-XX-' + CONVERT(VARCHAR(20),RIGHT(@SSN,4)),
		'Resume: ' + CASE WHEN @resume IS NULL THEN NULL ELSE 'Updated' END,
		'Advisor_ID: ' + CONVERT(VARCHAR(20),@advisor_ID),
		'Location_ID: ' + CONVERT(VARCHAR(20),@Location_ID),
		'Graduation_Date: ' + CONVERT(VARCHAR(20),@Graduation_Date))

END TRY

BEGIN CATCH

	EXEC dbo.usp_PrintError @output

END CATCH

END

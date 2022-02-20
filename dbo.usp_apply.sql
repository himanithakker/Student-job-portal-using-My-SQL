
USE Project_DB
GO

IF OBJECT_ID('dbo.usp_apply') IS NOT NULL
DROP PROCEDURE dbo.usp_apply
GO

CREATE PROCEDURE dbo.usp_apply(
	@StudentId INT,
	@PostingID INT,
	@Status VARCHAR(20),
	@Source VARCHAR(100) = 'Unknown',
	@output VARCHAR(MAX) OUTPUT
	)
AS
BEGIN

BEGIN TRY

	DECLARE @runtime DATETIME = GETDATE()
	DECLARE @StatusId INT
	DECLARE @applicationID INT

	IF NOT EXISTS(SELECT 1 FROM platform.STATUS WHERE Status_Description = @Status)
	BEGIN
		INSERT INTO platform.STATUS (Status_Description)
		SELECT @Status
	END

	SELECT @StatusId = Status_ID
	FROM platform.STATUS
	WHERE Status_Description = @Status

	UPDATE a
	SET Is_Current = 0,
		Eff_Status_end_date = @runtime
	FROM platform.APPLICATION a
	WHERE Student_ID = @StudentId
		AND Posting_ID = @PostingID
		AND Is_Current = 1

	DECLARE @update_count INT = @@ROWCOUNT

	SELECT @applicationID = Applcation_ID
	FROM platform.APPLICATION

	INSERT INTO platform.APPLICATION (Applcation_ID, Student_ID, Posting_ID, status_ID, Eff_Status_Start_date, Eff_Status_end_date, Is_Current, Source)
	SELECT ISNULL((SELECT MAX(Applcation_ID) FROM platform.APPLICATION)+1,10000),
		@StudentId,  @PostingID, @StatusId, IIF(@update_count = 1, @runtime, GETDATE()), '9999-12-31 23:59:59', 1, @Source

	SELECT @output = CONCAT('Application of Student: ', dbo.udf_getStudentName(@StudentId), ' to PostingID: ', @PostingID, ' is Successfull.')

END TRY

BEGIN CATCH

	EXEC dbo.usp_PrintError @output

END CATCH

END

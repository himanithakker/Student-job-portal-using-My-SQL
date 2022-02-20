CREATE DATABASE Project_DB;
GO

USE Project_DB;
GO

CREATE SCHEMA applicant;
GO

CREATE SCHEMA platform;
GO

create schema employer;
GO



---- Schema: APPLICANT -------

IF OBJECT_ID('applicant.ADVISOR', 'U') IS NOT NULL
    DROP TABLE applicant.ADVISOR;

CREATE TABLE applicant.ADVISOR
(
    Advisor_ID int not null identity (10000, 1),
    Name       varchar(50),
    Email      varchar(40),
    Phone      varchar(20),
    CONSTRAINT ADVISOR_PK primary key (Advisor_ID)
);
GO

IF OBJECT_ID('applicant.COURSE', 'U') IS NOT NULL
    DROP TABLE applicant.COURSE;

CREATE TABLE applicant.COURSE
(
    Course_ID    int not null identity (10000, 1),
    Course_Name  varchar(100),
    Credits      int,
    Grading_Type varchar(10),
    CONSTRAINT COURSE_PK primary key (Course_ID)
);
GO

---- schema: PLATFORM ----


IF OBJECT_ID('platform.STATUS', 'U') IS NOT NULL
    DROP TABLE platform.STATUS;

CREATE TABLE platform.STATUS
(
    Status_ID          int not null identity (10000, 1),
    Status_Description varchar(50),
    CONSTRAINT STATUS_PK primary key (Status_ID)
);
GO


IF OBJECT_ID('platform.SKILL', 'U') IS NOT NULL
    DROP TABLE platform.SKILL;

CREATE TABLE platform.SKILL
(
    Skill_ID   int not null identity (10000, 1),
    Skill_Name varchar(50),
    CONSTRAINT SKILL_PK primary key (Skill_ID)
);
GO

IF OBJECT_ID('platform.PLATFORM', 'U') IS NOT NULL
    DROP TABLE platform.PLATFORM;

CREATE TABLE platform.PLATFORM
(
    Platform_ID int not null identity (10000, 1),
    Name        varchar(50),
    URL         varchar(2000),
    CONSTRAINT PLATFORM_PK primary key (Platform_ID)
);
GO

IF OBJECT_ID('platform.QUALIFICATION', 'U') IS NOT NULL
    DROP TABLE platform.QUALIFICATION;

CREATE TABLE platform.QUALIFICATION
(
    Qualification_ID  int not null identity (10000, 1),
    Degree_Level      varchar(50),
    Major             varchar(50),
    Minor             varchar(50),
    Degree_Level_Rank int,
    CONSTRAINT QUALIFICATION_PK primary key (Qualification_ID)
);
GO

IF OBJECT_ID('platform.LOCATION', 'U') IS NOT NULL
    DROP TABLE platform.LOCATION;

CREATE TABLE platform.LOCATION
(
    Location_ID int not null identity (10000, 1),
    Street      varchar(225),
    City        varchar(50),
    State       varchar(25),
    Country     varchar(50),
    Zip_Code    varchar(10),
    CONSTRAINT LOCATION_PK primary key (Location_ID)
);
GO

---------------- LEVEL 2 --------


---- Schema: APPLICANT ----

IF OBJECT_ID('applicant.STUDENT', 'U') IS NOT NULL
    DROP TABLE applicant.STUDENT;

CREATE TABLE applicant.STUDENT
(
    Student_ID      int not null identity (10000, 1),
    FirstName            varchar(50),
    LastName            varchar(50),
    Email           varchar(50),
    Phone           varchar(15),
    DOB             DATE CHECK (DOB<GETDATE()),
    SSN             VARBINARY(200),
    Resume          XML,
    Advisor_ID      int,
    Location_ID     int,
    Graduation_Date DATE,
    TotalGPA DECIMAL(4,2),
    CONSTRAINT STUDENT_PK primary key (Student_ID),
    CONSTRAINT ADVISOR_FK FOREIGN KEY (Advisor_ID)
        REFERENCES applicant.ADVISOR (Advisor_ID),
    CONSTRAINT Location_FK1 FOREIGN KEY (Location_ID)
        REFERENCES platform.LOCATION (Location_ID),
);
GO

---- schema: EMPLOYER ----

IF OBJECT_ID('employer.ORGANIZATION', 'U') IS NOT NULL
    DROP TABLE employer.ORGANIZATION;

CREATE TABLE employer.ORGANIZATION
(
    Organization_ID   int not null identity (10000, 1),
    Organization_Name varchar(120),
    URL               varchar(2000),
    Location_ID       int,
    CONSTRAINT ORGANIZATION_PK PRIMARY KEY (Organization_ID),
    CONSTRAINT Location_FK2 FOREIGN KEY (Location_ID)
        REFERENCES platform.LOCATION (Location_ID),
);
GO

---------------- LEVEL 3 --------


---- Schema: APPLICANT ----

IF OBJECT_ID('applicant.TRANSCRIPT', 'U') IS NOT NULL
    DROP TABLE applicant.TRANSCRIPT;

CREATE TABLE applicant.TRANSCRIPT
(
    Transcript_ID int not null identity (10000, 1),
    Student_ID    int,
    Course_ID     int,
    Grade         char(2),
	GPA			  DECIMAL(4,2) CHECK (GPA between 0 and 10),
    Semester      varchar(20),
    Course_Status varchar(50),
    CONSTRAINT TRANSCRIPT_PK PRIMARY KEY (Transcript_ID),
    CONSTRAINT STUDENT_FK1 FOREIGN KEY (Student_ID)
        REFERENCES applicant.STUDENT (Student_ID),
    CONSTRAINT COURSE_FK2 FOREIGN KEY (Course_ID)
        REFERENCES applicant.COURSE (Course_ID)
);
GO


IF OBJECT_ID('applicant.STUDENT_SKILL', 'U') IS NOT NULL
    DROP TABLE applicant.STUDENT_SKILL;

CREATE TABLE applicant.STUDENT_SKILL
(
    Student_ID   int not null,
    Skill_ID     int,
    Years_of_Exp int,
    Rating_1_5   int,
    CONSTRAINT STUDENT_SKILL_PK PRIMARY KEY (Student_ID, Skill_ID),
    CONSTRAINT Student_FK2 FOREIGN KEY (Student_ID)
        REFERENCES applicant.STUDENT (Student_ID),
    CONSTRAINT Skill_FK FOREIGN KEY (Skill_ID)
        REFERENCES platform.SKILL (Skill_ID)
);
GO


IF OBJECT_ID('applicant.ACQUIRED_QUALIFICATION', 'U') IS NOT NULL
    DROP TABLE applicant.ACQUIRED_QUALIFICATION;

CREATE TABLE applicant.ACQUIRED_QUALIFICATION
(
    Qualification_ID int not null,
    Student_ID       int not null,
    GPA              int,
    CONSTRAINT ACQUIRED_QUALIFICATION_PK primary key (Qualification_ID, Student_ID),
    CONSTRAINT QUALIFICATION_FK FOREIGN KEY (Qualification_ID)
        REFERENCES platform.QUALIFICATION (Qualification_ID),
    CONSTRAINT Student_FK3 FOREIGN KEY (Student_ID)
        REFERENCES applicant.STUDENT (Student_ID),
);
GO

---- schema: PLATFORM ----


IF OBJECT_ID('platform.POSTING', 'U') IS NOT NULL
    DROP TABLE platform.POSTING;

CREATE TABLE platform.POSTING
(
    Posting_ID         int not null identity (10000, 1),
    Title              varchar(100),
    Platform_ID        int,
    Organization_ID    int,
    Date_Posted        date,
    Last_Date_To_Apply date,
    Description        varchar(2000),
    URL                varchar(2000),
    CONSTRAINT POSTING_PK PRIMARY KEY (Posting_ID),
    CONSTRAINT PLATFORM_FK1 FOREIGN KEY (Platform_ID)
        REFERENCES platform.PLATFORM (Platform_ID),
    CONSTRAINT ORGANIZATION_FK2 FOREIGN KEY (Organization_ID)
        REFERENCES employer.ORGANIZATION (Organization_ID)
);
GO

IF OBJECT_ID('platform.LOGIN', 'U') IS NOT NULL
    DROP TABLE platform.LOGIN;

CREATE TABLE platform.LOGIN
(
    Login_ID     int not null identity (10000, 1),
    Student_ID   int,
    Platform_ID  int,
    Is_Connected int,
    CONSTRAINT LOGIN_PK PRIMARY KEY (Login_ID),
    CONSTRAINT STUDENT_FK4 FOREIGN KEY (Student_ID)
        REFERENCES applicant.STUDENT (Student_ID),
    CONSTRAINT PLATFORM_FK2 FOREIGN KEY (Platform_ID)
        REFERENCES platform.PLATFORM (Platform_ID)
);
GO

---- LEVEL 4 ------


IF OBJECT_ID('platform.APPLICATION', 'U') IS NOT NULL
    DROP TABLE platform.APPLICATION;

CREATE TABLE platform.APPLICATION
(
    Applcation_ID         int not null,
    Student_ID            int,
    Posting_ID            int,
    status_ID             int,
    Eff_Status_Start_date date,
    Eff_Status_end_date   date,
    Is_Current            BIT,
    Source                varchar(50),
    CONSTRAINT APPLICATION_PK PRIMARY KEY (Applcation_ID),
    CONSTRAINT STUDENT_FK5 FOREIGN KEY (Student_ID)
        REFERENCES applicant.STUDENT (Student_ID),
    CONSTRAINT POSTING_FK FOREIGN KEY (Posting_ID)
        REFERENCES platform.POSTING (Posting_ID),
    CONSTRAINT STATUS_FK10 FOREIGN KEY (Status_ID)
        REFERENCES platform.STATUS (Status_ID)
);
GO

---- EMPLOYER -----

IF OBJECT_ID('employer.REQUIRED_QUALIFICATION', 'U') IS NOT NULL
    DROP TABLE employer.REQUIRED_QUALIFICATION;

CREATE TABLE employer.REQUIRED_QUALIFICATION
(
    Qualification_ID int not null,
    Posting_ID       int not null,
    Minimum_GPA      int,
    CONSTRAINT REQUIRED_QUALIFICATION_PK primary key (Qualification_ID, Posting_ID),
    CONSTRAINT QUALIFICATION_FK FOREIGN KEY (Qualification_ID)
        REFERENCES platform.QUALIFICATION (Qualification_ID),
    CONSTRAINT POSTING_FK1 FOREIGN KEY (Posting_ID)
        REFERENCES platform.POSTING (Posting_ID)
);
GO


IF OBJECT_ID('employer.REQUIRED_SKILL', 'U') IS NOT NULL
    DROP TABLE employer.REQUIRED_SKILL;

CREATE TABLE employer.REQUIRED_SKILL
(
    Posting_ID   int,
    Skill_ID     int,
    Years_of_Exp int,
    CONSTRAINT REQUIRED_SKILL_PK PRIMARY KEY (Posting_ID, Skill_ID),
    CONSTRAINT POSITING_FK FOREIGN KEY (Posting_ID)
        REFERENCES platform.POSTING (Posting_ID),
    CONSTRAINT SKILL_FK FOREIGN KEY (Skill_ID)
        REFERENCES platform.SKILL (Skill_ID)
);
GO

--Create a master key for the database.
create MASTER KEY
ENCRYPTION BY PASSWORD = 'damg_6210_group10';
-- drop master key
-- very that master key exists
SELECT name KeyName,
  symmetric_key_id KeyID,
  key_length KeyLength,
  algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
go
--Create a self signed certificate and name it Team10_Crt
CREATE CERTIFICATE Team10_Crt
   WITH SUBJECT = 'Team 10 Sample Password';
GO
-- drop CERTIFICATE EmpPass
--Create a symmetric key  with AES 256 algorithm using the certificate
-- as encryption/decryption method
CREATE SYMMETRIC KEY Team10_Crt_SM
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE Team10_Crt;
GO
--drop SYMMETRIC KEY EmpPass_SM
--Now we are ready to encrypt the password and also decrypt
-- Open the symmetric key with which to encrypt the data.
OPEN SYMMETRIC KEY Team10_Crt_SM
   DECRYPTION BY CERTIFICATE Team10_Crt;

GO

CREATE NONCLUSTERED INDEX IX_Country_State
   ON platform.LOCATION (Country ASC,State ASC);
GO

CREATE NONCLUSTERED INDEX IX_Date_Job_Posted
   ON platform.POSTING (Date_Posted ASC);
GO


CREATE TRIGGER applicant.t_updateTotalGPA ON applicant.Transcript
FOR INSERT, UPDATE, DELETE
AS
BEGIN

	UPDATE s
	SET TotalGPA = t.TotalGPA
	FROM applicant.Student s
	JOIN (
		SELECT t.Student_ID, AVG(t.GPA) TotalGPA
		FROM applicant.Transcript t
		WHERE Student_ID IN (SELECT Student_ID FROM inserted UNION SELECT Student_ID FROM deleted)
		GROUP BY t.Student_ID
	) t ON t.Student_ID = s.Student_ID
END

GO


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
	PRINT 1
END CATCH

END

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

GO

IF OBJECT_ID('dbo.udf_getActivePostingsFromOrganisation') IS NOT NULL
DROP FUNCTION dbo.udf_getActivePostingsFromOrganisation
GO

CREATE FUNCTION dbo.udf_getActivePostingsFromOrganisation(@OrganisationID INT)
RETURNS TABLE
AS
    RETURN(
	SELECT o.Organization_ID,
	       Organization_Name,
	       p.Posting_ID,
	       p.Title,
	       p.URL
	FROM employer.ORGANIZATION o
	join platform.POSTING p
	 on o.Organization_ID = p.Organization_ID
	WHERE Last_Date_To_Apply >= GETDATE()
	    and o.Organization_ID = @OrganisationID
	)

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

GO


IF OBJECT_ID('dbo.vw_advisor_level_offers') IS NOT NULL
DROP VIEW dbo.vw_advisor_level_offers
GO

CREATE VIEW dbo.vw_advisor_level_offers AS
SELECT ad.Name,
	COUNT(DISTINCT st.Student_ID) as total_students,
	COUNT(a.Applcation_ID) as total_applications,
	SUM(IIF(Status_Description LIKE '%Offer', 1, 0)) as total_offers,
	COUNT(DISTINCT IIF(Status_Description LIKE '%Offer', st.Student_ID, NULL)) as students_with_offers
FROM applicant.ADVISOR ad
JOIN applicant.STUDENT st ON st.Advisor_ID = ad.Advisor_ID
LEFT JOIN (SELECT * FROM platform.APPLICATION WHERE Is_Current = 1) a ON st.Student_ID = a.Student_ID
LEFT JOIN platform.STATUS s ON s.Status_ID = a.status_ID
GROUP BY ad.Name

GO

IF OBJECT_ID('dbo.vw_application') IS NOT NULL
DROP VIEW dbo.vw_application
GO

CREATE VIEW dbo.vw_application AS
SELECT dbo.udf_getStudentName(Student_ID) StudentFullName,
	p.Title JobTitle,
	s.Status_Description,
	Source
FROM platform.APPLICATION a
JOIN platform.POSTING p ON a.Posting_ID = p.Posting_ID
JOIN platform.STATUS s ON s.Status_ID = a.status_ID
WHERE a.Is_Current = 1

GO


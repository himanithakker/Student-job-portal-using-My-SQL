USE Project_DB
GO


------- LEVEL 2 --------
DECLARE student_cursor CURSOR FOR 
/*
--insert into applicant.STUDENT
select FirstName,
       LastName,
       EmailAddress as Email,
       PhoneNumber Phone,
       DOB,
       SSN,
       Resume,
       Advisor_ID,
       Location_ID,
       DATEADD(year, ABS(CHECKSUM(NEWID()) % 12) + 18, DOB) Graduation_Date,
       NULL TotalGPA*/
SELECT 'EXEC dbo.usp_addStudent ''' + replace(FirstName, '''', '') + ''' , '''
                                    + replace(LastName, '''', '') + ''' , '''
                                    + replace(EmailAddress, 'adventure', 'team10') + ''' , '''
                                    + PhoneNumber + ''' , '''
                                    + convert(varchar, DOB, 101) + ''' , '''
                                    + convert(varchar, SSN) + ''' , '''
                                    + ''' , '''
                                    + convert(varchar, Advisor_ID) + ''' , '''
                                    + convert(varchar, Location_ID) + ''' , '''
                                    + convert(varchar, DATEADD(year, ABS(CHECKSUM(NEWID()) % 12) + 18, DOB), 101) + ''' , '''
                                    + FirstName + ''' ;' as code
from (
    SELECT e.BusinessEntityID,
           FirstName,
           LastName,
           EmailAddress,
           PhoneNumber,
           DATEADD(day, (ABS(CHECKSUM(NEWID())) % 9125), '1975-01-01')               DOB,
           CAST(RAND(CHECKSUM(NEWID())) * 99999998 as int) + 100000000               SSN,
           10000 + abs(checksum(newid()) % (select count(*) from applicant.ADVISOR)) Advisor_ID,
           10000 + abs(checksum(newid()) % (select count(*) from platform.LOCATION)) Location_ID
    from AdventureWorks2019.Person.Person p
             join AdventureWorks2019.Person.EmailAddress e
                  on p.BusinessEntityID = e.BusinessEntityID
             join AdventureWorks2019.Person.PersonPhone pp
                  on p.BusinessEntityID = pp.BusinessEntityID
    where len(PhoneNumber) <= 15
) d
where FirstName + LastName not like ''
;

DECLARE @code VARCHAR(MAX)

OPEN student_cursor  
FETCH NEXT FROM student_cursor INTO @code

WHILE @@FETCH_STATUS = 0  
BEGIN  
      
	  EXEC (@code)

      FETCH NEXT FROM student_cursor INTO @code 
END 

CLOSE student_cursor  
DEALLOCATE student_cursor 

GO

Update s
set s.Resume = j.Resume
from applicant.STUDENT s
    join AdventureWorks2019.HumanResources.JobCandidate j
        on s.Student_ID % 12 = JobCandidateID
;

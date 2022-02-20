-- Insert Query Level 1
USE Project_DB;
-- platform.platform


INSERT INTO platform.PLATFORM (Name, URL)
VALUES ('NUWorks', 'https://northeastern-csm.symplicity.com/students/index.php?s=home'),
       ('LinkedIn', 'https://www.linkedin.com/'),
       ('Indeed', 'https://www.indeed.com/'),
       ('Glassdoor', 'https://www.glassdoor.com/'),
       ('Naukri', 'https://www.naukri.com/'),
       ('Amazon', 'https://www.amazon.jobs/'),
       ('Google', 'https://careers.google.com/'),
       ('Facebook', 'https://www.facebookcareers.com/'),
       ('StackOverFlow', 'https://stackoverflow.com/jobs')
;

INSERT INTO platform.STATUS(Status_Description)
VALUES ('Open/Wishlist'),
       ('Applied'),
       ('Cleared Round 1 - TELE SCREENING'),
       ('Cleared Round 2 - TECH ROUND 1'),
       ('Cleared Round 3 - TECH ROUND 2'),
       ('Cleared Round 4 - TECH ROUND 3'),
       ('Cleared Round 5 - Managerial '),
       ('Cleared Round 6 - HR'),
       ('Got Offer'),
       ('Accepted Offer'),
       ('Rejected'),
       ('Declined Offer')
;
/*
select 'INSERT INTO platform.LOCATION VALUES (''' + [Street Address] + ''', ''' +  City + ''', ''' + [State/Province] + ''', ''' + Country + ''', ' + Postcode + ');'
from sample.dbo.directory
where Country = 'US'
and  ([Street Address] + City + [State/Province] + Country + Postcode) is not null;
*/

--INSERT INTO platform.LOCATION
--SELECT [Street Address], City, [State/Province], Country, Postcode
--from sample.dbo.directory
--where Country = 'US'
--  and ([Street Address] + City + [State/Province] + Country + Postcode) is not null;


INSERT INTO platform.QUALIFICATION
SELECT Graduation_Level, Major, Minor, Degree_level
FROM (
         SELECT 'Data Analytics' Major, NULL minor
         UNION
         SELECT 'Computer Science', 'DataBase Systems'
         UNION
         SELECT 'Data Science', 'Machine Learning'
         UNION
         SELECT 'Information Systems', NULL
         UNION
         SELECT 'Artificial Intelligence', NULL
         UNION
         SELECT 'Big Data', NULL
         UNION
         SELECT 'Regulatory Affairs', NULL
         UNION
         SELECT 'Networking', 'Cyber Security'
         UNION
         SELECT 'Electrical Engineering', 'Quantum mechanics'
     ) mjr
         cross join (
    SELECT 'Phd' Graduation_Level, 1 Degree_level
    UNION
    SELECT 'Masters', 2
    UNION
    SELECT 'Graduation', 3
    UNION
    SELECT 'Bachelors', 4
    UNION
    SELECT 'Degree', 4
    UNION
    SELECT 'Diploma', 5
) grad_lvl;



--- applicant.advisor
-- ID, Name, Email, Phone
INSERT INTO applicant.ADVISOR
select top 100 p.FirstName + p.LastName as Name,
               EmailAddress,
               PhoneNumber
from AdventureWorks2019.Person.Person p
         join AdventureWorks2019.Person.EmailAddress ea on p.BusinessEntityID = ea.BusinessEntityID
         join AdventureWorks2019.Person.PersonPhone pp on p.BusinessEntityID = pp.BusinessEntityID
;

--- applicant.course
-- ID, Name, Credits, Grading_Type,
--INSERT INTO applicant.COURSE
--select name, CAST(RAND(CHECKSUM(NEWID())) * 4 as int) + 1 Credits, 'GPA' Grading_Type
--from (
--         select distinct [Course Title] name
--         from AdventureWorks2019.dbo.Courses_harvard
--         where [Course Subject] like '%computer%'
--            or [Course Subject] like '%Technology%'
--            or [Course Subject] like '%Mathematics%'
--     ) a
--;

INSERT INTO applicant.COURSE (Course_Name, Credits, Grading_Type) VALUES('Introduction to Computer Science and Programming', CAST(RAND(CHECKSUM(NEWID())) * 4 as int) + 1, 'GPA')
INSERT INTO applicant.COURSE (Course_Name, Credits, Grading_Type) VALUES('Introduction to Computer Science', CAST(RAND(CHECKSUM(NEWID())) * 4 as int) + 1, 'GPA')
INSERT INTO applicant.COURSE (Course_Name, Credits, Grading_Type) VALUES('Design and Development of Educational Technology', CAST(RAND(CHECKSUM(NEWID())) * 4 as int) + 1, 'GPA')
INSERT INTO applicant.COURSE (Course_Name, Credits, Grading_Type) VALUES('Introduction to Computer Science and Programming Using Python', CAST(RAND(CHECKSUM(NEWID())) * 4 as int) + 1, 'GPA')
INSERT INTO applicant.COURSE (Course_Name, Credits, Grading_Type) VALUES('Implementation and Evaluation of Educational Technology', CAST(RAND(CHECKSUM(NEWID())) * 4 as int) + 1, 'GPA')
INSERT INTO applicant.COURSE (Course_Name, Credits, Grading_Type) VALUES('Computation Structures: Computer Architecture', CAST(RAND(CHECKSUM(NEWID())) * 4 as int) + 1, 'GPA')
INSERT INTO applicant.COURSE (Course_Name, Credits, Grading_Type) VALUES('Introduction to Computer Science (2016)', CAST(RAND(CHECKSUM(NEWID())) * 4 as int) + 1, 'GPA')


INSERT INTO platform.SKILL
VALUES ('Python')
     , ('HTML')
     , ('DJANGO')
     , ('Javascript')
     , ('R')
     , ('Power BI')
     , ('Sql')
     , ('Excel')
     , ('Mircosoft Suite ')
     , ('Node JS ')
     , ('Machine Learning ')
     , ('Git ')
     , ('NoSql')
     , ('Tableau')
     , ('Java')
;
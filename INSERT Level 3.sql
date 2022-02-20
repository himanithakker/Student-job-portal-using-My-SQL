USE Project_DB
GO


----- Level 3 -----

with _grade AS (
SELECT 1 id, 'A+' Grade
UNION SELECT 2 ,'A'
UNION SELECT 3 ,'A-'
UNION SELECT 4 ,'B+'
UNION SELECT 5 ,'B'
UNION SELECT 6 ,'B-'
UNION SELECT 7 ,'C+'
UNION SELECT 8 ,'C'
UNION SELECT 9 ,'C-'
UNION SELECT 10 ,'D+'
UNION SELECT 11 ,'D'
UNION SELECT 12 ,'D-'
UNION SELECT 13  ,'F' ),
     _course_status AS(
select 1 as id, 'COMPLETED' Course_Status
UNION SELECT 2, 'REGISTERED'
UNION SELECT 3, 'IN PROGRESS'
UNION SELECT 4, 'NOT REGISTERED'
)

INSERT INTO  applicant.TRANSCRIPT
 select Student_ID,
        Course_ID,
        Grade,
        case
            when Grade like 'A%' then 9 + RAND(CHECKSUM(NEWID()))
            when Grade like 'B%' then 8 + RAND(CHECKSUM(NEWID()))
            when Grade like 'C%' then 7 + RAND(CHECKSUM(NEWID()))
            when Grade like 'D%' then 6 + RAND(CHECKSUM(NEWID()))
            else RAND(CHECKSUM(NEWID())) * 6
            end                                      as                        GPA,
        cast(RAND(CHECKSUM(NEWID())) * 8 as int) + 1 as                        Semester,
        Course_Status
 from applicant.STUDENT s
          join applicant.COURSE c
            on 10000 + (s.Student_ID % 73) = c.Course_ID
          join _grade g on (s.Student_ID % 12) + 1 = g.id
          join _course_status cs on (s.Student_ID % 4) + 1 = cs.id

;


INSERT INTO applicant.STUDENT_SKILL
 select s.Student_ID, sk.Skill_ID,
        cast(RAND(CHECKSUM(NEWID())) * 8 as int) + 1 Years_of_Exp,
       cast(RAND(CHECKSUM(NEWID())) * 5 as int) + 1 Rating_1_5
 from applicant.STUDENT s
     join platform.SKILL sk
on 10000 + (s.Student_ID % 16)  = sk.Skill_ID
;


INSERT INTO applicant.ACQUIRED_QUALIFICATION
select Qualification_ID, Student_ID,  round((RAND(CHECKSUM(NEWID())) * 2)+2, 2)  GPA
from applicant.STUDENT s
     join platform.QUALIFICATION q
on 10000 + (s.Student_ID % 54)  = q.Qualification_ID
;

insert into PLATFORM.LOGIN
select Student_ID, Platform_ID, cast(RAND(CHECKSUM(NEWID())) * 2 as int)
from applicant.STUDENT s
 cross join platform.PLATFORM p
;


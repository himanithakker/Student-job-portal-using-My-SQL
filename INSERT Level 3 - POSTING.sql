USE Project_DB
GO

INSERT INTO platform.POSTING
select job_title Title,
       10000 + abs(checksum(newid()) % (select count(*) from platform.PLATFORM)) Platform_ID,
       Organization_ID,
       post_date Date_Posted,
       dateadd(day, 100, post_date) Last_Date_To_Apply,
       job_description Description,
       j.url
from AdventureWorks2019.dbo.job_postings j
    join employer.ORGANIZATION o
        on j.company_name = o.Organization_Name
where len(job_description) <= 2000
and len(job_title) <= 100
;
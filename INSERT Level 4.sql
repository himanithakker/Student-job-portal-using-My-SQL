
---- LEVEL 4 -----

insert into employer.REQUIRED_QUALIFICATION
select  Qualification_ID, Posting_ID, round((RAND(CHECKSUM(NEWID())) * 2 ) + 2, 1) Minimum_GPA
from platform.POSTING p
  join platform.QUALIFICATION q
on 10000 + (p.Posting_ID % 54)  = Qualification_ID
order by 1,2
;


insert into employer.REQUIRED_SKILL
select  Posting_ID, Skill_ID, cast(RAND(CHECKSUM(NEWID())) * 8 as int) + 1  Years_of_Exp
from platform.POSTING p
  join platform.SKILL q
on 10000 + (p.Posting_ID % 15)  = Skill_ID
;

GO

DECLARE apply_cursor CURSOR FOR 
select 'EXEC dbo.usp_apply ''' + convert(varchar, p.Posting_ID) + ''' , '''
                                    + convert(varchar, s.Student_ID) + ''' , '''
                                    + st.Status_Description + ''' , '''
                                    + pf.Name + ''' , '''';'
from platform.POSTING p
 join applicant.STUDENT s
    on 10000 + p.Posting_ID % 9931 = s.STUDENT_ID
 join platform.STATUS st
    on 10000 + p.Posting_ID % 12 = st.STATUS_ID
 join platform.PLATFORM pf
    on 10000 + p.Posting_ID % 9 = pf.Platform_ID
;

DECLARE @code2 VARCHAR(MAX)

OPEN apply_cursor  
FETCH NEXT FROM apply_cursor INTO @code2

WHILE @@FETCH_STATUS = 0  
BEGIN  
      
	  EXEC (@code2)

      FETCH NEXT FROM apply_cursor INTO @code2
END 

CLOSE apply_cursor  
DEALLOCATE apply_cursor 

GO

--EXEC dbo.usp_apply '10306' , '10375' , 'Got Offer' , 'LinkedIn' , '';

--EXEC dbo.usp_apply '10314' , '10383' , 'Cleared Round 5 - Managerial ' , 'NUWorks' , '';

USE Project_DB
GO

ALTER TABLE applicant.Student
ADD TotalGPA DECIMAL(4,2)
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


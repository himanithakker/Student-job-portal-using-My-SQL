
USE Project_DB
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
;
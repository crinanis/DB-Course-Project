use Oishi;
GO

-- Export

GO
CREATE OR ALTER PROCEDURE ExportToXML
AS
BEGIN
	SELECT UserRID, ReviewText FROM REVIEWS 
	FOR XML PATH('review'), ROOT('reviews');

	--Sql server config to export stored procedures to xml file 
	EXEC master.dbo.sp_configure 'show advanced options', 1
	RECONFIGURE with override
	EXEC master.dbo.sp_configure 'xp_cmdshell', 1
	RECONFIGURE with override

	DECLARE @cmd nvarchar(255);
	SELECT @cmd = 'bcp "use [Oishi]; SELECT UserRID, ReviewText FROM REVIEWS FOR XML PATH(''review''), root(''reviews'')" ' +
    'queryout "C:\Users\Administrator\Desktop\CW\reviews.xml" -w -T -S' + @@SERVERNAME;
exec xp_cmdshell @cmd;
END;
GO

exec ExportToXML;
GO

-- Import

CREATE OR ALTER PROCEDURE ImportFromXML
AS
BEGIN
DECLARE @xml XML;

SELECT @xml = CONVERT(xml, BulkColumn, 2) FROM OPENROWSET(BULK 'C:\Users\Administrator\Desktop\CW\reviews.xml', SINGLE_BLOB) AS x

INSERT INTO REVIEWS(UserRID, ReviewText)
SELECT 
	t.x.query('UserRID').value('.', 'int'),
	t.x.query('ReviewText').value('.', 'nvarchar(500)')
FROM @xml.nodes('//reviews/review') t(x)
END
GO

exec GetAllReviews;
exec DeleteReview @reviewid = 1;
exec ImportFromXML;

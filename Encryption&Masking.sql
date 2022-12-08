use Oishi;

-- Маскирование данных

CREATE USER TestClient WITHOUT LOGIN;  
CREATE USER TestAdmin WITHOUT LOGIN;  

GRANT SELECT on USERS to TestClient; 
GRANT SELECT on ORDERS to TestClient; 

GRANT SELECT on USERS to TestAdmin; 
GRANT SELECT on ORDERS to TestAdmin; 
GRANT UNMASK to TestAdmin;

EXECUTE AS USER = 'TestClient';  
SELECT * FROM USERS;  
SELECT * FROM ORDERS;  
REVERT;	 

EXECUTE AS USER = 'TestAdmin';  
SELECT * FROM USERS;  
SELECT * FROM ORDERS;  
REVERT;


SELECT 
	c.name AS [column_name], 
	tbl.name AS [table_name], 
	c.is_masked, 
	c.masking_function  
		FROM sys.masked_columns AS c  
			JOIN sys.tables AS tbl   
			ON c.[object_id] = tbl.[object_id]  
			WHERE is_masked = 1;

-- Шифрование данных

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Ksusha1234';
select name, symmetric_key_id  From sys.symmetric_keys;
CREATE CERTIFICATE MyCert WITH SUBJECT = 'Cert' 

CREATE SYMMETRIC KEY MySymKey WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE MyCert;
GO

CREATE OR ALTER PROCEDURE Encrypt
AS
BEGIN TRY
	OPEN SYMMETRIC KEY MySymKey
    DECRYPTION BY CERTIFICATE MyCert;

UPDATE dbo.USERS
        SET UserPassword = EncryptByKey (Key_GUID('MySymKey'), UserPassword)
        FROM dbo.USERS;
        
CLOSE SYMMETRIC KEY MySymKey;
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;

EXEC Encrypt;
GO


CREATE OR ALTER PROCEDURE EncryptByLogin
		@login nvarchar(50)
AS 
BEGIN TRY
	OPEN SYMMETRIC KEY MySymKey
    DECRYPTION BY CERTIFICATE MyCert;

UPDATE dbo.USERS
        SET UserPassword = EncryptByKey (Key_GUID('MySymKey'), UserPassword) 
        FROM dbo.USERS WHERE UserLogin = @login;
        
CLOSE SYMMETRIC KEY MySymKey;
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
EXEC EncryptByLogin @login = 'prvv';
GO


CREATE OR ALTER PROCEDURE Decrypt
AS
BEGIN TRY
	OPEN SYMMETRIC KEY MySymKey
        DECRYPTION BY CERTIFICATE MyCert;

SELECT UserLogin, UserAffiliation, UserPassword AS 'Encrypted password',
            CONVERT(nvarchar, DecryptByKey(UserPassword)) AS 'Decrypted password'
            FROM dbo.USERS;
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;

EXEC Decrypt;
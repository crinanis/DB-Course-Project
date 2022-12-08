use Oishi;
GO 


CREATE OR ALTER PROCEDURE Registrate
				@login nvarchar(50),
				@password nvarchar(50)
AS
BEGIN TRY
	OPEN SYMMETRIC KEY MySymKey
    DECRYPTION BY CERTIFICATE MyCert;
	SET @password = EncryptByKey (Key_GUID('MySymKey'), @password)
	IF EXISTS(SELECT TOP 1 * FROM USERS WHERE USERS.UserLogin = @login)
		print 'User with such login exists!';
	ELSE IF (@login != '' AND @password != '')
		BEGIN
		INSERT INTO USERS(UserLogin, UserPassword)
			VALUES(@login, @password)
			print 'You successfully signed up!'
		END;
	ELSE print 'Fields cant be null.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE Authorize
				 @login nvarchar(50),
				 @pass nvarchar(50)
AS
BEGIN TRY
	IF (@login != 'Admin')
		IF EXISTS(SELECT TOP 1 * FROM USERS WHERE USERS.UserLogin = @login)
			IF EXISTS(SELECT TOP 1 * FROM USERS WHERE USERS.UserLogin = @login AND CONVERT(nvarchar, DecryptByKey(USERS.UserPassword)) = @pass)
				print 'You are successfully logged in!'
			ELSE print 'Input correct password.'
		ELSE print 'User with such login dont exist. Sign up to proceed.'
	ELSE print 'You cant authorize as admin'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE AddReview
				@login nvarchar(50),
				@text nvarchar(500)
AS
BEGIN TRY
	DECLARE @userid int;
	SET @userid = (SELECT UserID FROM USERS WHERE USERS.UserLogin = @login);
	IF (@userid != 0)
		BEGIN
		IF (@login != '' AND @text != '')
			BEGIN
			INSERT INTO REVIEWS(UserRID, ReviewText)
				VALUES(@userid, @text)
			END;
		ELSE print 'Fields cant be null.'
		END;
	ELSE print 'User with this login dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE MakeOrder
				@login nvarchar(50),
				@datetime smalldatetime,
				@tablenum int,
				@email nvarchar(50),
				@wishes nvarchar(500)
AS
BEGIN TRY
	DECLARE @userid int, @tableid int;
	SET @userid = (SELECT UserID FROM USERS WHERE USERS.UserLogin = @login);
	SET @tableid = (SELECT TableID FROM RESTABLES WHERE RESTABLES.OrdinalNumber = @tablenum);

	IF EXISTS(SELECT TOP 1 * FROM ORDERS WHERE ORDERS.BookingDatetime = @datetime AND ORDERS.TableOID = @tableid)
		print 'This table has already been reserved on this time.'
	ELSE IF (@userid != 0)
		BEGIN
			IF (@tableid != 0)
				BEGIN
					IF (@login != '' AND @datetime != '' AND @tablenum != 0 AND @email != '' AND @wishes != '' AND @datetime > GETDATE())
						BEGIN
						INSERT INTO ORDERS(UserOID, BookingDatetime, TableOID, UserEmail, Wishes)
							VALUES(@userid, @datetime, @tableid, @email, @wishes)
						END;
					ELSE print 'Error in entries.'
				END;
			ELSE print 'Table with this ordinal number dont exist.'
		END;
	ELSE print 'User with this login dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO
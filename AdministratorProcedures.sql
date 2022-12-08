use Oishi;
GO


CREATE OR ALTER PROCEDURE GetAllUsers
AS
BEGIN
	OPEN SYMMETRIC KEY MySymKey
    DECRYPTION BY CERTIFICATE MyCert;
	SELECT UserID [ID], UserLogin[Login], CONVERT(nvarchar, DecryptByKey(UserPassword))[Password], UserAffiliation[Role] 
		FROM USERS GROUP BY UserID, UserLogin, UserPassword, UserAffiliation;
END
GO


CREATE OR ALTER PROCEDURE GetAllOrders
AS
BEGIN
	SELECT * FROM ORDERS ORDER BY OrderID;
END
GO


CREATE OR ALTER PROCEDURE GetAllUnconfirmedOrders
AS
BEGIN
	SELECT * FROM VORDERS;
END
GO


CREATE OR ALTER PROCEDURE GetAllDishTypes
AS
BEGIN
	SELECT * FROM DISHTYPES ORDER BY TypeId;
END
GO


CREATE OR ALTER PROCEDURE DeleteAllUsers
AS
BEGIN
	DELETE FROM USERS WHERE UserID > 0;
END
GO


CREATE OR ALTER PROCEDURE DeleteUser
				 @login nvarchar(50)
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM USERS WHERE USERS.UserLogin = @login)
		IF (@login != '')
			DELETE FROM USERS WHERE USERS.UserLogin = @login;
		ELSE print 'Enter login.'
		
	ELSE print 'User with such login dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE InsertIntoDishtypes
				 @dishtypename nvarchar(50)
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM DISHTYPES WHERE DISHTYPES.TypeName = @dishtypename)
		print 'This type exists!';
	ELSE IF (@dishtypename != '')
		BEGIN
		INSERT INTO DISHTYPES(TypeName)
			VALUES(@dishtypename)
		END;
	ELSE print 'Fields cant be null.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE InsertIntoMenu
				 @name nvarchar(50),
				 @price decimal(5,2),
				 @weight int,
				 @typename nvarchar(50),
				 @desc nvarchar(500)
AS
BEGIN TRY
	DECLARE @type int;
	SET @type = (SELECT TypeId from DISHTYPES where DISHTYPES.TypeName = @typename);
	IF (@type != 0)
		BEGIN
			IF EXISTS(SELECT TOP 1 * FROM MENU WHERE MENU.DishName = @name)
				print 'This unit exists in menu!';
			ELSE IF (@name != '' AND @price != 0 AND @weight != 0 AND @desc != '' AND @type != 0)
				BEGIN
				INSERT INTO MENU(DishName, DishPrice, DishWeight, DishType, DishDescription)
					VALUES(@name, @price, @weight, @type, @desc)
				END;
			ELSE print 'Fields cant be null.'
		END;
	ELSE print 'Invalid dish type'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE InsertIntoRestables
				 @number int,
				 @desc nvarchar(500)
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM RESTABLES WHERE RESTABLES.OrdinalNumber = @number)
		print 'This table exists!';
	ELSE IF (@number != 0)
		BEGIN
		INSERT INTO RESTABLES(OrdinalNumber, TableDescription)
			VALUES(@number, @desc)
		END;
	ELSE print 'Fields cant be null.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE AddAdmin
				 @login nvarchar(50),
				 @pass nvarchar(50),
				 @role nvarchar(13)
AS 
BEGIN TRY
	OPEN SYMMETRIC KEY MySymKey
    DECRYPTION BY CERTIFICATE MyCert;
	SET @pass = EncryptByKey (Key_GUID('MySymKey'), @pass);
	IF EXISTS(SELECT TOP 1 * FROM USERS WHERE USERS.UserLogin = @login)
		print 'User with such login exists!';
	ELSE IF (@login != '' AND @pass != '' AND @role != '')
		BEGIN
		INSERT INTO USERS(UserLogin, UserPassword, UserAffiliation)
			VALUES(@login, @pass, @role)
		END;
	ELSE print 'Fields cant be null.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE ConfirmOrder
				 @orderid int
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM ORDERS WHERE ORDERS.OrderID = @orderid AND ORDERS.OrderStatus = 0)
		BEGIN
			UPDATE ORDERS set OrderStatus = 1 WHERE OrderID = @orderid;
		END;
	ELSE print 'Order with this id dont exist or it has been already confirmed.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE DeleteDish
				 @name nvarchar(50)
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM MENU WHERE MENU.DishName = @name)
		BEGIN
			DELETE FROM MENU WHERE DishName = @name;
		END;
	ELSE print 'Dish with this name dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE DeleteDishType
				 @typename nvarchar(50)
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM DISHTYPES WHERE DISHTYPES.TypeName = @typename)
		BEGIN
			DELETE FROM DISHTYPES WHERE TypeName = @typename;
		END;
	ELSE print 'Dishtype with this name dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE DeleteTable
				 @number int
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM RESTABLES WHERE RESTABLES.OrdinalNumber = @number)
		BEGIN
			DELETE FROM RESTABLES WHERE OrdinalNumber = @number;
		END;
	ELSE print 'Table with this number dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE DeleteReview
				 @reviewid int
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM REVIEWS WHERE REVIEWS.ReviewID = @reviewid)
		BEGIN
			DELETE FROM REVIEWS WHERE ReviewID = @reviewid;
		END;
	ELSE print 'Review with this id dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE DeleteOrder
				 @orderid int
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM ORDERS WHERE ORDERS.OrderID = @orderid)
		BEGIN
			DELETE FROM ORDERS WHERE OrderID = @orderid;
		END;
	ELSE print 'Order with this id dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE UpdateUser
				 @login nvarchar(50),
				 @password nvarchar(50),
				 @affiliation nvarchar(13)
AS
BEGIN TRY
	OPEN SYMMETRIC KEY MySymKey
    DECRYPTION BY CERTIFICATE MyCert;
	IF EXISTS(SELECT TOP 1 * FROM USERS WHERE USERS.UserLogin = @login)
		BEGIN
		SET @password = EncryptByKey (Key_GUID('MySymKey'), @password);
			IF (@login != '' AND @password != '' AND @affiliation != '')
				BEGIN
				UPDATE USERS SET UserPassword = @password, UserAffiliation = @affiliation WHERE UserLogin = @login;
				END;
			ELSE print 'Values cant be empty.'
		END;
	ELSE print 'User with this login dont exist';
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE UpdateDishType
				 @id int,
				 @name nvarchar(50)
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM DISHTYPES WHERE DISHTYPES.TypeName = @name)
		print 'Enter new dishtype name!'
	ELSE IF EXISTS(SELECT TOP 1 * FROM DISHTYPES WHERE DISHTYPES.TypeId = @id)
		BEGIN
			IF (@id != 0 AND @name != '')
				BEGIN
					UPDATE DISHTYPES SET TypeName = @name WHERE TypeId = @id;
				END;
			ELSE print 'Values cant be empty.'
		END;
	ELSE print 'Dishtype with this id dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE UpdateDish
				 @name nvarchar(50),
				 @price decimal(5,2),
				 @weight int,
				 @desc nvarchar(500),
				 @type int
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM MENU WHERE MENU.DishName = @name)
		BEGIN
			IF (@name != '' AND @price != 0 AND @weight != 0 AND @desc != '' AND @type != 0 )
				BEGIN
					UPDATE MENU SET DishPrice = @price, DishWeight = @weight, DishDescription = @desc, DishType = @type WHERE DishName = @name;
				END;
			ELSE print 'Values cant be empty.'
		END;
	ELSE print 'Dish with this name dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


CREATE OR ALTER PROCEDURE UpdateTable
				 @number nvarchar(50), 
				 @desc nvarchar(500)
AS
BEGIN TRY
	IF EXISTS(SELECT TOP 1 * FROM RESTABLES WHERE RESTABLES.OrdinalNumber = @number)
		BEGIN
			IF (@number != 0 AND @desc != '')
				BEGIN
					UPDATE RESTABLES SET TableDescription = @desc WHERE OrdinalNumber = @number;
				END;
			ELSE print 'Values cant be empty.'
		END;
	ELSE print 'Table with this number dont exist.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO
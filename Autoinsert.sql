use Oishi;
GO

--generation of random string
GO
CREATE OR ALTER VIEW VRand(vR) AS SELECT rand();
GO

SELECT * FROM VRand;
GO

CREATE OR ALTER FUNCTION RandomString(
@min_length int,
@max_length int,
@charPool nvarchar(50)
)
RETURNS NVARCHAR(12)
AS
BEGIN
	DECLARE @Length int,@PoolLength int, @LoopCount int, @RandomString nvarchar(12)
	SET @Length = floor((select vR from vRand) * (@max_length - @min_length) + @min_length);

	SET @PoolLength = LEN(@charPool);

	SET @LoopCount = 0;
	SET @RandomString = '';

	WHILE(@LoopCount < @Length)
		BEGIN
			SELECT @RandomString = @RandomString + SUBSTRING(@charPool, CONVERT(int, floor((select vR from vRand) * @PoolLength)),1)
			SELECT @LoopCount = @LoopCount +1
		END;

	RETURN @RandomString;
END;


GO


CREATE OR ALTER PROCEDURE InsertUsers
AS
BEGIN
	DECLARE @LoopCounter int, @login nvarchar(50), @password nvarchar(50);
	SET @LoopCounter = 1;
	WHILE @LoopCounter <= 100000
		BEGIN
		OPEN SYMMETRIC KEY MySymKey
		DECRYPTION BY CERTIFICATE MyCert;
			SET @login = dbo.RandomString(6, 12, 'qwertyuioplkjhgfdsazxcvbnm0198726543');
			SET @password = dbo.RandomString(6, 12, 'qwertyuioplkjhgfdsazxcvbnm0198726543');
			SET @password = EncryptByKey (Key_GUID('MySymKey'), @password);
			INSERT INTO USERS(UserLogin, UserPassword) 
				VALUES (@login, @password);
			SET @LoopCounter = @LoopCounter + 1;
		END;
END;

exec InsertUsers;
exec GetAllUsers;
GO


CREATE OR ALTER PROCEDURE InsertDishtypes
AS
BEGIN
	DECLARE @LoopCounter int, @typename nvarchar(50);
	SET @LoopCounter = 1;
	WHILE @LoopCounter <= 100000
		BEGIN
			SET @typename = dbo.RandomString(6, 12, 'qwertyuioplkjhgfdsazxcvbnm');
			INSERT INTO DISHTYPES(TypeName) 
				VALUES (@typename);
			SET @LoopCounter = @LoopCounter + 1;
		END;
END;

exec InsertDishtypes;
exec GetAllDishTypes;
GO


CREATE OR ALTER PROCEDURE InsertMenu
AS
BEGIN
	DECLARE @LoopCounter int, @name nvarchar(50), @price decimal(5,2), @weight int, @desc nvarchar(500), @type int;
	SET @LoopCounter = 1;
	WHILE @LoopCounter <= 100000
		BEGIN
			SET @name = dbo.RandomString(6, 12, 'qwertyuioplkjhgfdsazxcvbnm');
			SET @price = @LoopCounter + 1;
			SET @weight = @LoopCounter + 20;
			SET @desc = dbo.RandomString(6, 100, 'qwertyuioplkjhgfdsazxcvbnm');
			SET @type = (SELECT TOP 1 TypeId FROM DISHTYPES ORDER BY NEWID());
			INSERT INTO MENU(DishName, DishPrice, DishWeight, DishDescription, DishType) 
				VALUES (@name, @price, @weight, @desc, @type);
			SET @LoopCounter = @LoopCounter + 1;
		END;
END;

exec InsertMenu;
exec GetAllDishes;
GO


CREATE OR ALTER PROCEDURE InsertRestables
AS
BEGIN
	DECLARE @LoopCounter int, @number int, @desc nvarchar(500);
	SET @LoopCounter = 1;
	WHILE @LoopCounter <= 100000
		BEGIN
			SET @number = @LoopCounter + 10;
			SET @desc = dbo.RandomString(6, 100, 'qwertyuioplkjhgfdsazxcvbnm');
			INSERT INTO RESTABLES(OrdinalNumber, TableDescription) 
				VALUES (@number, @desc);
			SET @LoopCounter = @LoopCounter + 1;
		END;
END;

exec InsertRestables;
exec GetAllRestables;
GO


CREATE OR ALTER PROCEDURE InsertOrders
AS
BEGIN
	DECLARE @LoopCounter int, @userid int, @date datetime, @tableid int, @email nvarchar(50), @wishes nvarchar(500);
	SET @LoopCounter = 1;
	WHILE @LoopCounter <= 100000
		BEGIN
		declare @email_domain char(10) = (SELECT TOP 1 letter  
												FROM
												( 
												VALUES ('@gmail.com'),('@mail.ru'),('@yahoo.com'),('@yandex.ru'),('@bk.ru'),('@tut.by')
												) AS letters(letter)
												ORDER BY abs(checksum(newid()))
										 )
			SET @userid = (SELECT TOP 1 UserID FROM USERS ORDER BY NEWID());
			SET @date= (SELECT DATEADD(DAY, FLOOR(rand()*23000), '2022-12-09'));
			SET @tableid = (SELECT TOP 1 TableId FROM RESTABLES ORDER BY NEWID());
			SET @email = CONCAT(dbo.RandomString(6, 15, 'qwertyuioplkjhgfdsazxcvbnm1098764325'), @email_domain);
			SET @wishes = dbo.RandomString(6, 100, 'qwertyuioplkjhgfdsazxcvbnm');
			INSERT INTO ORDERS(UserOID, BookingDatetime, TableOID, UserEmail, Wishes) 
				VALUES (@userid, @date, @tableid, @email, @wishes);
			SET @LoopCounter = @LoopCounter + 1;
		END;
END;

exec InsertOrders;
exec GetAllOrders;
GO


CREATE OR ALTER PROCEDURE InsertReviews
AS
BEGIN
	DECLARE @LoopCounter int, @userid int, @text nvarchar(500);
	SET @LoopCounter = 1;
	WHILE @LoopCounter <= 100000
		BEGIN
			SET @userid = (SELECT TOP 1 UserID FROM USERS ORDER BY NEWID());
			SET @text = dbo.RandomString(6, 100, 'qwertyuioplkjhgfdsazxcvbnm');
			INSERT INTO REVIEWS(UserRID, ReviewText) 
				VALUES (@userid, @text);
			SET @LoopCounter = @LoopCounter + 1;
		END;
END;

exec InsertReviews;
exec GetAllReviews;
GO

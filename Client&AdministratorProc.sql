use Oishi;
GO


CREATE OR ALTER PROCEDURE usp_GetErrorInfo  
AS  
SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  
GO  


CREATE OR ALTER PROCEDURE GetAllDishes
AS
BEGIN
	SELECT DishID, DishName, DishPrice, DishWeight, DishDescription, TypeName FROM MENU
		INNER JOIN DISHTYPES ON DishType = TypeId ORDER BY DishID;
END
GO


CREATE OR ALTER PROCEDURE GetAllRestables
AS
BEGIN
	SELECT * FROM RESTABLES ORDER BY TableId;
END
GO


CREATE OR ALTER PROCEDURE GetAllReviews
AS
BEGIN
	SELECT * FROM REVIEWS ORDER BY ReviewID;
END
GO


CREATE OR ALTER PROCEDURE GetDishesByCategory
				 @category nvarchar(50)
AS
BEGIN TRY
	DECLARE @dishid int = (SELECT TypeId FROM DISHTYPES WHERE TypeName = @category);
	IF(@category != '' AND @dishid != 0)
		SELECT DishID, DishName, DishPrice, DishWeight, DishDescription, TypeName 
			FROM MENU
				INNER JOIN DISHTYPES ON DishType = TypeId WHERE MENU.DishType = @dishid ORDER BY DishId;
	ELSE print 'Input correct dish type.'
END TRY
BEGIN CATCH
	EXECUTE usp_GetErrorInfo;  
END CATCH;
GO


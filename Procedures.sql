use Oishi;
GO

-- Admin
execute as user='OishiAdminU'
revert

exec Encrypt;
exec EncryptByLogin @login = 'prvv';
exec Decrypt;


exec GetAllUsers;
exec GetAllOrders;
exec GetAllUnconfirmedOrders;
exec GetAllDishTypes;
exec GetAllDishes;
exec GetDishesByCategory @category = 'Лапша';
exec GetAllRestables;
exec GetAllReviews;


exec DeleteUser @login = 'Ksu1';
exec DeleteDish @name = 'Фунчоза с цыплёнком-гриль';
exec DeleteDishType @typename = 'Суп';
exec DeleteTable @number = 22;
exec DeleteReview @reviewid = 4440;
exec DeleteOrder @orderid = 1;
exec DeleteAllUsers;


exec AddAdmin @login = 'Admin', @pass = '12345', @role = 'administrator';
exec ConfirmOrder @orderid = 1;
exec ExportToXML;
exec ImportFromXML;


exec InsertIntoDishtypes @dishtypename = 'Суп';
exec InsertIntoMenu @name = 'Фунчоза с цыплёнком-гриль', @price = 13.52, @weight = 420, @typename = 'Лапша', @desc = 'Рисовая лапша в пекинском соусе, цыпленок-гриль, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, яйцо, лук-порей, кунжут. Острое.';
exec InsertIntoRestables @number = 1, @desc = 'Столик на 4 персоны у окна.';


exec InsertUsers;
exec InsertDishtypes;
exec InsertMenu;
exec InsertRestables;
exec InsertOrders;
exec InsertReviews;


exec UpdateUser @login = 'rinma2yx', @password = '12345', @affiliation = 'client';
exec UpdateDishType @id = 9, @name = 'Салат';
exec UpdateDish @name = 'Фунчоза с тигровыми креветками', @price = 20.90, @weight = 420, @desc = 'Рисовая лапша в пекинском соусе, цыпленок-гриль, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, яйцо, лук-порей, кунжут. Острое.', @type = 1;
exec UpdateTable @number = 2, @desc = 'Столик на 2 персоны у окна.';


-- Client 
execute as user='OishiClientU'
revert

exec Registrate @login = 'sekjfjsf', @password = '11srg11';
exec Authorize @login = 'sekjfjsf', @pass = '11srg11';
exec AddReview @login = 'Ksu', @text = 'Отличное заведение с приемлимыми ценами и приятным обслуживанием!';
exec MakeOrder @login = 'Ksu', @datetime = '20230718 16:30:00', @tablenum = 2, @email = 'budanowa.ksenia@gmail.com', @wishes = 'Maybe table 2';

exec GetAllDishes;
exec GetDishesByCategory @category = 'Донбури';
exec GetAllRestables;
exec GetAllReviews;

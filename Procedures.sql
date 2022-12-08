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
exec GetDishesByCategory @category = '�����';
exec GetAllRestables;
exec GetAllReviews;


exec DeleteUser @login = 'Ksu1';
exec DeleteDish @name = '������� � ��������-�����';
exec DeleteDishType @typename = '���';
exec DeleteTable @number = 22;
exec DeleteReview @reviewid = 4440;
exec DeleteOrder @orderid = 1;
exec DeleteAllUsers;


exec AddAdmin @login = 'Admin', @pass = '12345', @role = 'administrator';
exec ConfirmOrder @orderid = 1;
exec ExportToXML;
exec ImportFromXML;


exec InsertIntoDishtypes @dishtypename = '���';
exec InsertIntoMenu @name = '������� � ��������-�����', @price = 13.52, @weight = 420, @typename = '�����', @desc = '������� ����� � ��������� �����, ��������-�����, ��������� �������, �������, ��������� ������, ������� �����, ����, ���-�����, ������. ������.';
exec InsertIntoRestables @number = 1, @desc = '������ �� 4 ������� � ����.';


exec InsertUsers;
exec InsertDishtypes;
exec InsertMenu;
exec InsertRestables;
exec InsertOrders;
exec InsertReviews;


exec UpdateUser @login = 'rinma2yx', @password = '12345', @affiliation = 'client';
exec UpdateDishType @id = 9, @name = '�����';
exec UpdateDish @name = '������� � ��������� ����������', @price = 20.90, @weight = 420, @desc = '������� ����� � ��������� �����, ��������-�����, ��������� �������, �������, ��������� ������, ������� �����, ����, ���-�����, ������. ������.', @type = 1;
exec UpdateTable @number = 2, @desc = '������ �� 2 ������� � ����.';


-- Client 
execute as user='OishiClientU'
revert

exec Registrate @login = 'sekjfjsf', @password = '11srg11';
exec Authorize @login = 'sekjfjsf', @pass = '11srg11';
exec AddReview @login = 'Ksu', @text = '�������� ��������� � ����������� ������ � �������� �������������!';
exec MakeOrder @login = 'Ksu', @datetime = '20230718 16:30:00', @tablenum = 2, @email = 'budanowa.ksenia@gmail.com', @wishes = 'Maybe table 2';

exec GetAllDishes;
exec GetDishesByCategory @category = '�������';
exec GetAllRestables;
exec GetAllReviews;

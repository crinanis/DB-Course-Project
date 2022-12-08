create database Oishi;
drop database Oishi;
use Oishi;

DROP TABLE USERS;
ALTER TABLE USERS ALTER COLUMN UserID DROP MASKED;
CREATE TABLE USERS(
	UserID int MASKED WITH (FUNCTION = 'default()') identity(1,1) primary key,
	UserLogin nvarchar(50) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX", 1)') not null unique,
	UserPassword nvarchar(50) not null,
	UserAffiliation nvarchar(13) MASKED WITH (FUNCTION = 'default()') default 'client'
)

DROP TABLE DISHTYPES;
ALTER TABLE DISHTYPES ALTER COLUMN TypeId DROP MASKED;
CREATE TABLE DISHTYPES(
	TypeId int MASKED WITH (FUNCTION = 'default()') identity(1,1) primary key,
	TypeName nvarchar(50) not null
)

DROP TABLE MENU;
CREATE TABLE MENU(
	DishId int MASKED WITH (FUNCTION = 'default()') identity(1,1) primary key,
	DishName nvarchar(50) not null,
	DishPrice decimal(5,2) not null,
	DishWeight int not null,
	DishDescription nvarchar(500) not null,
	DishType int foreign key references DISHTYPES(TypeId) ON DELETE CASCADE
)

DROP TABLE RESTABLES;
ALTER TABLE RESTABLES ALTER COLUMN TableID DROP MASKED;
CREATE TABLE RESTABLES(
	TableID int MASKED WITH (FUNCTION = 'default()') identity(1,1) primary key,
	OrdinalNumber smallint not null,
	TableDescription nvarchar(500) not null
)

DROP TABLE ORDERS;
CREATE TABLE ORDERS(
	OrderID int MASKED WITH (FUNCTION = 'default()') identity(1,1) primary key,
	UserOID int MASKED WITH (FUNCTION ='default()') foreign key references USERS(UserID) ON DELETE CASCADE,
	BookingDatetime smalldatetime not null,
	TableOID int foreign key references RESTABLES(TableID) ON DELETE CASCADE,
	UserEmail nvarchar(50) MASKED WITH (FUNCTION = 'email()') not null,
	Wishes nvarchar(200),
	OrderStatus int default 0
)

DROP TABLE REVIEWS;
CREATE TABLE REVIEWS(
	ReviewID int MASKED WITH (FUNCTION = 'default()') identity(1,1) primary key,
	UserRID int foreign key references USERS(UserID) ON DELETE CASCADE,
	ReviewText nvarchar(500) not null
)
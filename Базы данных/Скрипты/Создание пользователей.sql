create login Admin --пользователь Администратор
with password = '123456',
default_database = [is1_ivanovavaTRBD]

create login Manager --пользователь Менеджер
with password = '123456',
default_database = [is1_ivanovavaTRBD]

create login Seller --пользователь Продавец
with password = '123456',
default_database = [is1_ivanovavaTRBD]

create login Consultant -- пользователь Консультант 
with password = '123456',
default_database = [is1_ivanovavaTRBD]

--Создание роли Администратор
create role AdminRoles
--Создание пользователя и добавление его в БД
create user Admin for login Admin
--Назначение роли пользователю
alter role AdminRoles add member Admin
--Выдача привелегий ролям 
-- Администратор может добавлять пользователей и управлять базой данных
use master
grant alter any database to Admin

--Создание роли Менеджер
create role ManagerRole
--Создание пользователя и добавление его в БД
create user Manager for login Manager
--Назначение роли пользователю
alter role ManagerRole add member Manager
--Менеджер может изменять доступ пользователям
grant alter any user to ManagerRole

--Создание роли Продавец
create role SellerRole
--Создание пользователя и добавление его в БД
create user Seller for login Seller
--Назначение роли пользователю
alter role SellerRole add member Seller
--Продавцы имеют доступ к таблице товаров
grant select on Product to SalaryRole

--Создание роли Консультант 
create role ConsultantRoles
--Создание пользователя и добавление его в БД
create user Consultant for login Consultant
--Назначение роли пользователю
alter role ConsultantRoles add member Consultant
--Консультанты аналогично продавцам, но также могут изменять товары
grant select, update on Product to RoleConsultantRoles
EXECUTE AS User = 'Consultant'
SELECT *
FROM Categorys
REVERT;



--Создание БД
create table Users(--таблица Пользователи
idUser int identity primary key,
Login nvarchar(max),
Password nvarchar(max))

insert into Users
values
('Svetik228','112233'),
('Polik77','445566'),
('Zn4ak','778899');

create table Categorys(--таблицца Категория продуктов
idCategory int identity primary key,
Name nvarchar(max))

insert into Categorys
values
('Напитки'),
('Фрукты'),
('Горячее блюдо');

create table Product(--таблица Продуктов
idProduct int identity primary key,
Name nvarchar(max),
id_Category int foreign key references Categorys(idCategory),
Price money)

insert into Product
values
('Сок вишнёвый',1,13),
('Яблоко',2,45),
('Суп',3,68);

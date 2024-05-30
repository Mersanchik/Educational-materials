create table Users(--таблица Пользователи
idUser int identity primary key,
Name nvarchar(max),
Password nvarchar(max),
Email nvarchar(max))

insert into Users
values
('Пользователь1','1','почта1'),
('Пользователь2','2','почта2'),
('Пользователь3','3','почта3'),
('Пользователь4','4','почта4'),
('Пользователь5','5','почта5');

create table Category(--таблица Категории
idCategory int identity primary key,
Name nvarchar(max))

insert into Category
values
('Категория1'),
('Категория2'),
('Категория3'),
('Категория4'),
('Категория5');

create table Transactions(--таблица Финансовые операции
idTransaction int identity primary key,
id_User int foreign key references Users(idUser),
id_Category int foreign key references Category(idCategory),
Date date,
Amount money,--сумма
Description nvarchar(max),
SourceDectination nvarchar(max))--источник/назначение средств

insert into Transactions
values
(1,1,'2023/09/04',15000,'Описание1','Источник1'),
(2,2,'2023/09/15',7000,'Описание2','Источник2'),
(3,3,'2023/09/18',1000,'Описание3','Источник3'),
(4,4,'2023/09/28',3000,'Описание4','Источник4'),
(5,5,'2023/10/02',9000,'Описание5','Источник5');

create table Budgets(-- таблица Бюджеты
idBudgets int identity primary key,
id_User int foreign key references Users(idUser),
id_Category int foreign key references Category(idCategory),
MaxAmount money,--максимальные суммы
DateTo date,--доступность их на определённый период
DateOut date,
constraint Periods check (DateOut>DateTo))
--проверка что Дата Окончания больше Даты Начала

insert into Budgets
values 
(1,1,18000,'2023/09/01','2024/09/01'),
(2,2,10000,'2023/09/01','2023/10/01'),
(3,3,5000,'2023/09/10','2023/09/18'),
(4,4,3000,'2023/09/20','2023/09/28'),
(5,5,10000,'2023/09/10','2023/10/10');

create table TypeInvestment (--таблица Типы инвестиции
idType int identity primary key,
Name nvarchar(max))

insert into TypeInvestment
values 
('Тип1'),
('Тип2'),
('Тип3'),
('Тип4'),
('Тип5');

create table Investment(--таблица Инвестиции
idInvestment int identity primary key,
id_User int foreign key references Users(idUser),
id_Type int foreign key references TypeInvestment(idType),
Amount money,--сумма вложения
ExpectedReturn money,--ожидаемая доходность
InvestmentDateTo date,--срок вложения
InvestmentDateOut date,
constraint InvestDate check (InvestmentDateOut > InvestmentDateTo))
--проверка что Срок Вложения Окончания больше чем Срок Вложения Начала

insert into Investment
values 
(1,1,7000,18000,'2023/09/01','2023/09/18'),
(2,2,1000,3000,'2023/09/03','2023/09/12'),
(3,3,2000,5000,'2023/09/01','2023/09/14'),
(4,4,4000,8000,'2023/09/10','2023/09/15'),
(4,4,6000,20000,'2023/09/04','2023/09/28');

create table Product(--таблица Товары
idProduct int identity primary key,
Name nvarchar(max),
Price money)

insert into Product
values 
('Товар1',62),
('Товар2',135),
('Товар3',93),
('Товар4',78),
('Товар5',296);

create table NewPrices(--таблица Новые цены
idPrices int identity primary key,
id_Product int foreign key references Product(idProduct),
id_User int foreign key references Users(idUser),
NewPrice money,
Date date)

insert into NewPrices
values
(1,1,84,'2023/10/06'),
(2,2,152,'2023/09/28'),
(3,3,82,'2023/09/12'),
(4,4,69,'2023/10/08'),
(5,5,147,'2023/10/03');

create table BankOperation(--таблица Операции
idOperation int identity primary key,
Name nvarchar(max))

insert into BankOperation
values 
('Операция1'),
('Операция2'),
('Операция3'),
('Операция4'),
('Операция5');

create table BankAccount(--таблица Банковские счета
idAccount int identity primary key,
id_User int foreign key references Users(idUser),
id_Operation int foreign key references BankOperation(idOperation),
AccountNumber nvarchar(20),
Date date)
 
insert into BankAccount
values
(1,1,'1','2023/05/23'),
(2,2,'2','2020/03/17'),
(3,3,'3','2021/07/13'),
(4,4,'4','2022/10/19'),
(5,5,'5','2023/02/27');

create table FinancialGoal(--таблица Финансовые цели
idGoal int identity primary key,
id_User int foreign key references Users(idUser),
Name nvarchar(max),
Amount money,
Term date);--срок

insert into FinancialGoal
values
(1,'Название1',23000,'2023/12/31'),
(2,'Название2',13000,'2024/03/05'),
(3,'Название3',5000,'2023/11/04'),
(4,'Название4',27000,'2024/03/20'),
(5,'Название5',20000,'2024/04/01');

------Хранимые процедуры
--1.Добавление нового пользователя в таблицу Users:
go
create proc AddNewUser
as
declare
    @Name nvarchar(max),
    @Password nvarchar(max),
    @Email nvarchar(max)
begin
set @Name = 'Петров'
set @Password = 'Петров123'
set @Email = 'Петров@'
insert into Users
values (@Name, @Password, @Email)
end

exec AddNewUser
select *
from Users

--2.Обновление пароля пользователя в таблице Users:
go
create proc UpdateUserPassword
as
declare
    @idUser int,
    @NewPassword nvarchar(max)
begin
set @idUser = 7
set @NewPassword = 'ТруЧел'
update Users
set Password = @NewPassword
where idUser = @idUser
end

exec UpdateUserPassword
select *
from Users

--3.Удаление пользователя из таблицы Users:
go
create proc DeleteUser
as
declare
    @idUser int
begin
set @idUser = 7
delete from Users
where idUser = @idUser
end

exec DeleteUser
select *
from Users

--4.Добавление новой категории в таблицу Category:
go
create proc AddNewCategory
as
declare
    @Name nvarchar(max)
begin
set @Name = 'Просто категория'
insert into Category (Name)
values (@Name)
end

exec AddNewCategory
select *
from Category

--5.Обновление названия категории в таблице Category:
go
create proc UpdateCategoryName
as
declare
    @idCategory int,
    @NewName nvarchar(max)
begin
set @idCategory = 8
set @NewName = 'Нууу'
update Category
set Name = @NewName
where idCategory = @idCategory
end

exec UpdateCategoryName
select *
from Category

--6.Удаление категории из таблицы Category:
go
create proc DeleteCategory
as
declare
    @idCategory int
begin
set @idCategory = 8
delete from Category
where idCategory = @idCategory
end

exec DeleteCategory
select *
from Category

--7.Добавление новой финансовой операции в таблицу Transactions:
go
create proc AddNewTransaction
as
declare
    @id_User int,
    @id_Category int,
    @Date date,
    @Amount money,
    @Description nvarchar(max),
    @SourceDestination nvarchar(max)
begin
set @id_User = 5
set @id_Category = 1
set @Date = '2023/12/15'
set @Amount = 225
set @Description = 'Тут должно быть описание'
set @SourceDestination = 'Источник мама'
    insert into Transactions (id_User, id_Category, Date, Amount, Description, SourceDectination)
    values (@id_User, @id_Category, @Date, @Amount, @Description, @SourceDestination)
end

exec AddNewTransaction
select *
from Transactions

--8.Обновление описания финансовой операции в таблице Transactions:
go
create proc UpdateTransactionDescription
as
declare
    @idTransaction int,
    @NewDescription nvarchar(max)
begin
set @idTransaction = 7
set @NewDescription = 'Мани'
update Transactions
set Description = @NewDescription
where idTransaction = @idTransaction
end

exec UpdateTransactionDescription
select *
from Transactions

--9.Удаление финансовой операции из таблицы Transactions:
go
create proc DeleteTransaction
as
declare
    @idTransaction int
begin
set @idTransaction = 7
delete from Transactions
where idTransaction = @idTransaction
end

exec DeleteTransaction
select *
from Transactions

--10.Добавление новой финансовой цели в таблицу FinancialGoal:
go
create proc AddNewFinancialGoal
as
declare
    @id_User int,
    @Name nvarchar(max),
    @Amount money,
    @Term date
begin
set @id_User = 2
set @Name = 'На что то'
set @Amount = 50000000
set @Term = '2025/05/23'
insert into FinancialGoal (id_User, Name, Amount, Term)
values (@id_User, @Name, @Amount, @Term)
end

exec AddNewFinancialGoal
select *
from FinancialGoal
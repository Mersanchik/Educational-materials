create table Users(--������� ������������
idUser int identity primary key,
Name nvarchar(max),
Password nvarchar(max),
Email nvarchar(max))

insert into Users
values
('������������1','1','�����1'),
('������������2','2','�����2'),
('������������3','3','�����3'),
('������������4','4','�����4'),
('������������5','5','�����5');

create table Category(--������� ���������
idCategory int identity primary key,
Name nvarchar(max))

insert into Category
values
('���������1'),
('���������2'),
('���������3'),
('���������4'),
('���������5');

create table Transactions(--������� ���������� ��������
idTransaction int identity primary key,
id_User int foreign key references Users(idUser),
id_Category int foreign key references Category(idCategory),
Date date,
Amount money,--�����
Description nvarchar(max),
SourceDectination nvarchar(max))--��������/���������� �������

insert into Transactions
values
(1,1,'2023/09/04',15000,'��������1','��������1'),
(2,2,'2023/09/15',7000,'��������2','��������2'),
(3,3,'2023/09/18',1000,'��������3','��������3'),
(4,4,'2023/09/28',3000,'��������4','��������4'),
(5,5,'2023/10/02',9000,'��������5','��������5');

create table Budgets(-- ������� �������
idBudgets int identity primary key,
id_User int foreign key references Users(idUser),
id_Category int foreign key references Category(idCategory),
MaxAmount money,--������������ �����
DateTo date,--����������� �� �� ����������� ������
DateOut date,
constraint Periods check (DateOut>DateTo))
--�������� ��� ���� ��������� ������ ���� ������

insert into Budgets
values 
(1,1,18000,'2023/09/01','2024/09/01'),
(2,2,10000,'2023/09/01','2023/10/01'),
(3,3,5000,'2023/09/10','2023/09/18'),
(4,4,3000,'2023/09/20','2023/09/28'),
(5,5,10000,'2023/09/10','2023/10/10');

create table TypeInvestment (--������� ���� ����������
idType int identity primary key,
Name nvarchar(max))

insert into TypeInvestment
values 
('���1'),
('���2'),
('���3'),
('���4'),
('���5');

create table Investment(--������� ����������
idInvestment int identity primary key,
id_User int foreign key references Users(idUser),
id_Type int foreign key references TypeInvestment(idType),
Amount money,--����� ��������
ExpectedReturn money,--��������� ����������
InvestmentDateTo date,--���� ��������
InvestmentDateOut date,
constraint InvestDate check (InvestmentDateOut > InvestmentDateTo))
--�������� ��� ���� �������� ��������� ������ ��� ���� �������� ������

insert into Investment
values 
(1,1,7000,18000,'2023/09/01','2023/09/18'),
(2,2,1000,3000,'2023/09/03','2023/09/12'),
(3,3,2000,5000,'2023/09/01','2023/09/14'),
(4,4,4000,8000,'2023/09/10','2023/09/15'),
(4,4,6000,20000,'2023/09/04','2023/09/28');

create table Product(--������� ������
idProduct int identity primary key,
Name nvarchar(max),
Price money)

insert into Product
values 
('�����1',62),
('�����2',135),
('�����3',93),
('�����4',78),
('�����5',296);

create table NewPrices(--������� ����� ����
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

create table BankOperation(--������� ��������
idOperation int identity primary key,
Name nvarchar(max))

insert into BankOperation
values 
('��������1'),
('��������2'),
('��������3'),
('��������4'),
('��������5');

create table BankAccount(--������� ���������� �����
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

create table FinancialGoal(--������� ���������� ����
idGoal int identity primary key,
id_User int foreign key references Users(idUser),
Name nvarchar(max),
Amount money,
Term date);--����

insert into FinancialGoal
values
(1,'��������1',23000,'2023/12/31'),
(2,'��������2',13000,'2024/03/05'),
(3,'��������3',5000,'2023/11/04'),
(4,'��������4',27000,'2024/03/20'),
(5,'��������5',20000,'2024/04/01');

------�������� ���������
--1.���������� ������ ������������ � ������� Users:
go
create proc AddNewUser
as
declare
    @Name nvarchar(max),
    @Password nvarchar(max),
    @Email nvarchar(max)
begin
set @Name = '������'
set @Password = '������123'
set @Email = '������@'
insert into Users
values (@Name, @Password, @Email)
end

exec AddNewUser
select *
from Users

--2.���������� ������ ������������ � ������� Users:
go
create proc UpdateUserPassword
as
declare
    @idUser int,
    @NewPassword nvarchar(max)
begin
set @idUser = 7
set @NewPassword = '������'
update Users
set Password = @NewPassword
where idUser = @idUser
end

exec UpdateUserPassword
select *
from Users

--3.�������� ������������ �� ������� Users:
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

--4.���������� ����� ��������� � ������� Category:
go
create proc AddNewCategory
as
declare
    @Name nvarchar(max)
begin
set @Name = '������ ���������'
insert into Category (Name)
values (@Name)
end

exec AddNewCategory
select *
from Category

--5.���������� �������� ��������� � ������� Category:
go
create proc UpdateCategoryName
as
declare
    @idCategory int,
    @NewName nvarchar(max)
begin
set @idCategory = 8
set @NewName = '����'
update Category
set Name = @NewName
where idCategory = @idCategory
end

exec UpdateCategoryName
select *
from Category

--6.�������� ��������� �� ������� Category:
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

--7.���������� ����� ���������� �������� � ������� Transactions:
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
set @Description = '��� ������ ���� ��������'
set @SourceDestination = '�������� ����'
    insert into Transactions (id_User, id_Category, Date, Amount, Description, SourceDectination)
    values (@id_User, @id_Category, @Date, @Amount, @Description, @SourceDestination)
end

exec AddNewTransaction
select *
from Transactions

--8.���������� �������� ���������� �������� � ������� Transactions:
go
create proc UpdateTransactionDescription
as
declare
    @idTransaction int,
    @NewDescription nvarchar(max)
begin
set @idTransaction = 7
set @NewDescription = '����'
update Transactions
set Description = @NewDescription
where idTransaction = @idTransaction
end

exec UpdateTransactionDescription
select *
from Transactions

--9.�������� ���������� �������� �� ������� Transactions:
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

--10.���������� ����� ���������� ���� � ������� FinancialGoal:
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
set @Name = '�� ��� ��'
set @Amount = 50000000
set @Term = '2025/05/23'
insert into FinancialGoal (id_User, Name, Amount, Term)
values (@id_User, @Name, @Amount, @Term)
end

exec AddNewFinancialGoal
select *
from FinancialGoal
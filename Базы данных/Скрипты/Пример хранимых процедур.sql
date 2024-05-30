create table Postman(
id_Postman integer identity primary key,
Name_firm nvarchar(max),
Adres nvarchar(max),
Phone int)

create table Buyer(
id_Buyer integer identity primary key,
Name nvarchar(max),
Adres nvarchar(max),
Phone int)

create table Product(
id_Product integer identity primary key,
Name nvarchar(max),
Unit float,
Count integer,
Purchase money,
Sell money)

create table Sales_Transactions(
id_product integer foreign key references Product (id_Product),
id_postman integer foreign key references Postman (id_Postman),
id_buyer integer foreign key references Buyer (id_Buyer),
Count_buyprod integer,
Date_order date)

insert into Postman
values('Фирма первая', 'Улица первая 1', 896655),
('Фирма вторая', 'Улица вторая 2', 894446),
('Фирма третья', 'Улица третья 3', 893366)

insert into Buyer
values('Покупатель первый', 'Улица первая 11', 895558),
('Покупатель второй', 'Улица первая 22', 891114),
('Покупатель третий', 'Улица первая 33', 896669)

insert into Product
values('Кофты',400,1000,200,800),
('Штаны',200,200,100,400),
('Обувь',250,300,130,600)

insert into Sales_Transactions
values(1,1,1,30,'2022-12-02'),
(2,2,2,70,'2023-01-06'),
(3,3,3,40,'2022-11-18')


--Увеличим сумму за которую покупает поставщик, все товры стали стоить на 100 рублей дороже
create proc Sale
as 
Declare @purchase money
begin 
set @purchase = 100
Update Product
set Purchase = Purchase+@purchase
end
--просмотр
exec Sale 
Select *
from Product

--нахождение суммы
create Proc Symma
as 
begin
select P.Name as Название_товара, (p.Purchase*S.Count_buyprod) as Сумма_проданного_товара,P.Purchase as цена_товара,S.Count_buyprod as Количество_Проданного_товара
from Product as P
Join Sales_Transactions as S on S.id_product = P.id_Product
end
--просмотр 
exec Symma


--нахождение максимальной суммы
Create proc Maxsum
as
begin
select  Max(P.Purchase*S.Count_buyprod) as Максимальная_сумма
from Product as P
Join Sales_Transactions as S on S.id_product = P.id_Product
end
--просмотр
exec Maxsum


--нахождение максимальной суммы
Create proc Minsum
as
begin
select  Min(P.Purchase*S.Count_buyprod) as Минимальная_сумма
from Product as P
Join Sales_Transactions as S on S.id_product = P.id_Product
end
--просмотр
exec Minsum


--Создания нового поставщика
Create Proc NewPostman
as
Declare @Name nvarchar(50),@adress nvarchar(50),@phone int
begin
set @Name = 'Фирма фиг пойми какая'
set @adress = 'Улица какая-то там'
set @phone = 89004455
insert into Postman
values(@Name,@adress,@phone)
end
--посмотр
exec NewPostman
select *
from Postman

--Создания нового покупателя
Create proc NewBuyer
as
Declare @Name nvarchar(50),@adress nvarchar(50),@phone int
begin
set @Name = 'Покупатель фиг пойми какой'
set @address = 'Улица какая-то там'
set @phone = 8955664
insert into Buyer
values(@Name,@adress,@phone)
end
--просмотр
exec NewBuyer
select *
from Buyer

--Представления общей таблицы 
Create View Orderr
as
SELECT P.Name as Названия_Продукта,Postm.Name_firm as Названия_фирмы,B.Name as Имя_покупателя,Sales_Transactions.Date_order as Дата_Заказа
From Sales_Transactions
Join Product as P on Sales_Transactions.id_product = P.id_Product
Join Postman as Postm on Sales_Transactions.id_postman=Postm.id_Postman
Join Buyer as B on Sales_Transactions.id_buyer = B.id_Buyer
--Вывод Общего представления
Select * from Orderr



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
values('����� ������', '����� ������ 1', 896655),
('����� ������', '����� ������ 2', 894446),
('����� ������', '����� ������ 3', 893366)

insert into Buyer
values('���������� ������', '����� ������ 11', 895558),
('���������� ������', '����� ������ 22', 891114),
('���������� ������', '����� ������ 33', 896669)

insert into Product
values('�����',400,1000,200,800),
('�����',200,200,100,400),
('�����',250,300,130,600)

insert into Sales_Transactions
values(1,1,1,30,'2022-12-02'),
(2,2,2,70,'2023-01-06'),
(3,3,3,40,'2022-11-18')


--�������� ����� �� ������� �������� ���������, ��� ����� ����� ������ �� 100 ������ ������
create proc Sale
as 
Declare @purchase money
begin 
set @purchase = 100
Update Product
set Purchase = Purchase+@purchase
end
--��������
exec Sale 
Select *
from Product

--���������� �����
create Proc Symma
as 
begin
select P.Name as ��������_������, (p.Purchase*S.Count_buyprod) as �����_����������_������,P.Purchase as ����_������,S.Count_buyprod as ����������_����������_������
from Product as P
Join Sales_Transactions as S on S.id_product = P.id_Product
end
--�������� 
exec Symma


--���������� ������������ �����
Create proc Maxsum
as
begin
select  Max(P.Purchase*S.Count_buyprod) as ������������_�����
from Product as P
Join Sales_Transactions as S on S.id_product = P.id_Product
end
--��������
exec Maxsum


--���������� ������������ �����
Create proc Minsum
as
begin
select  Min(P.Purchase*S.Count_buyprod) as �����������_�����
from Product as P
Join Sales_Transactions as S on S.id_product = P.id_Product
end
--��������
exec Minsum


--�������� ������ ����������
Create Proc NewPostman
as
Declare @Name nvarchar(50),@adress nvarchar(50),@phone int
begin
set @Name = '����� ��� ����� �����'
set @adress = '����� �����-�� ���'
set @phone = 89004455
insert into Postman
values(@Name,@adress,@phone)
end
--�������
exec NewPostman
select *
from Postman

--�������� ������ ����������
Create proc NewBuyer
as
Declare @Name nvarchar(50),@adress nvarchar(50),@phone int
begin
set @Name = '���������� ��� ����� �����'
set @address = '����� �����-�� ���'
set @phone = 8955664
insert into Buyer
values(@Name,@adress,@phone)
end
--��������
exec NewBuyer
select *
from Buyer

--������������� ����� ������� 
Create View Orderr
as
SELECT P.Name as ��������_��������,Postm.Name_firm as ��������_�����,B.Name as ���_����������,Sales_Transactions.Date_order as ����_������
From Sales_Transactions
Join Product as P on Sales_Transactions.id_product = P.id_Product
Join Postman as Postm on Sales_Transactions.id_postman=Postm.id_Postman
Join Buyer as B on Sales_Transactions.id_buyer = B.id_Buyer
--����� ������ �������������
Select * from Orderr



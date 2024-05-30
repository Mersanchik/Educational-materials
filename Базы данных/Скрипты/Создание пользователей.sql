create login Admin --������������ �������������
with password = '123456',
default_database = [is1_ivanovavaTRBD]

create login Manager --������������ ��������
with password = '123456',
default_database = [is1_ivanovavaTRBD]

create login Seller --������������ ��������
with password = '123456',
default_database = [is1_ivanovavaTRBD]

create login Consultant -- ������������ ����������� 
with password = '123456',
default_database = [is1_ivanovavaTRBD]

--�������� ���� �������������
create role AdminRoles
--�������� ������������ � ���������� ��� � ��
create user Admin for login Admin
--���������� ���� ������������
alter role AdminRoles add member Admin
--������ ���������� ����� 
-- ������������� ����� ��������� ������������� � ��������� ����� ������
use master
grant alter any database to Admin

--�������� ���� ��������
create role ManagerRole
--�������� ������������ � ���������� ��� � ��
create user Manager for login Manager
--���������� ���� ������������
alter role ManagerRole add member Manager
--�������� ����� �������� ������ �������������
grant alter any user to ManagerRole

--�������� ���� ��������
create role SellerRole
--�������� ������������ � ���������� ��� � ��
create user Seller for login Seller
--���������� ���� ������������
alter role SellerRole add member Seller
--�������� ����� ������ � ������� �������
grant select on Product to SalaryRole

--�������� ���� ����������� 
create role ConsultantRoles
--�������� ������������ � ���������� ��� � ��
create user Consultant for login Consultant
--���������� ���� ������������
alter role ConsultantRoles add member Consultant
--������������ ���������� ���������, �� ����� ����� �������� ������
grant select, update on Product to RoleConsultantRoles
EXECUTE AS User = 'Consultant'
SELECT *
FROM Categorys
REVERT;



--�������� ��
create table Users(--������� ������������
idUser int identity primary key,
Login nvarchar(max),
Password nvarchar(max))

insert into Users
values
('Svetik228','112233'),
('Polik77','445566'),
('Zn4ak','778899');

create table Categorys(--�������� ��������� ���������
idCategory int identity primary key,
Name nvarchar(max))

insert into Categorys
values
('�������'),
('������'),
('������� �����');

create table Product(--������� ���������
idProduct int identity primary key,
Name nvarchar(max),
id_Category int foreign key references Categorys(idCategory),
Price money)

insert into Product
values
('��� �������',1,13),
('������',2,45),
('���',3,68);

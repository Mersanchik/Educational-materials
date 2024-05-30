--������������ sa
use master
go
alter login sa with password='password'
go
alter login sa enable 
go



--�������� ��
create table Users(--������� ������������
idUser int identity primary key,
Name nvarchar(max),
Password nvarchar(max),
Email nvarchar(max),
Phone nvarchar(max),
Address nvarchar(max),
encryptEmail varbinary(max),
encryptPhone varbinary(max),
encryptAddress varbinary(max))

insert into Users
values
('������������1','1','�����1','89111','�����1',null,null,null),
('������������2','2','�����2','89222','�����2',null,null,null),
('������������3','3','�����3','89333','�����3',null,null,null),
('������������4','4','�����4','89444','�����4',null,null,null),
('������������5','5','�����5','89555','�����5',null,null,null);
 

create table Category(--������� ���������
idCategory int identity primary key,
Name nvarchar(max));

insert into Category
values
('�������� ��������'),
('����� � ������'), 
('���� � �����'), 
('���� � ������������');
 

create table Products(--������� ��������
idProduct int identity primary key,
Name nvarchar(max),
Price money,
Quantity int,
idCategory int foreign key references Category(idCategory));
 
insert into Products
values 
('��������', 43.99, 100, 1),
('���', 80.30, 50, 2),
('������', 30.00, 200, 3),
('������', 160.00, 30, 4),
('��������', 400.00, 20, 4);
 
--�������� ������������
CREATE LOGIN Ivanova
WITH PASSWORD = '123456',
DEFAULT_DATABASE = [iva]
 
--�������� ���� ��
create master key encryption by
password = 'password'
go

--�������� ���������� ����������
create certificate Test with subject = 'description'
 
--�������� ������������ ���� � ������� ���������� �����������
CREATE SYMMETRIC KEY KeyName WITH ALGORITHM = AES_256
encryption by certificate Test
 
--��������� �����
open symmetric key KeyName DECRYPTION BY CERTIFICATE Test;
UPDATE Users
SET encryptEmail = EncryptByKey(Key_GUID('KeyName')  
    , Email, 1, HASHBYTES('SHA2_256', CONVERT( varbinary  
    , idUser)));  
GO  

--��������� �������
open symmetric key KeyName DECRYPTION BY CERTIFICATE Test;
UPDATE Users
SET encryptPhone = EncryptByKey(Key_GUID('KeyName')  
    , Phone, 1, HASHBYTES('SHA2_256', CONVERT( varbinary  
    , idUser)));  
GO  

--��������� �����
open symmetric key KeyName DECRYPTION BY CERTIFICATE Test;
UPDATE Users
SET encryptAddress = EncryptByKey(Key_GUID('KeyName')  
    , Address, 1, HASHBYTES('SHA2_256', CONVERT( varbinary  
    , idUser)));  
GO  
 
--������� ���������
select *
from Users

--���������
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
SELECT encryptEmail   
    AS 'Encrypted logins', CONVERT(varchar,  
    DecryptByKey(encryptEmail, 1 ,   
    HASHBYTES('SHA2_256', CONVERT(nvarchar, encryptEmail))))  
    AS 'Decrypted logins' FROM  Users; 
GO
CLOSE SYMMETRIC KEY KeyName;  
 

--������ �����
--��������� �����
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
INSERT INTO Users(Email)
VALUES ( EncryptByKey( Key_GUID('KeyName'), '����� ������������'));  
GO
CLOSE SYMMETRIC KEY KeyName; 

--��������� �������
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
INSERT INTO Users(Phone)
VALUES ( EncryptByKey( Key_GUID('KeyName'), '�����'));  
GO
CLOSE SYMMETRIC KEY KeyName; 

--��������� �����
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
INSERT INTO Users(Address)
VALUES ( EncryptByKey( Key_GUID('KeyName'), '�����'));  
GO
CLOSE SYMMETRIC KEY KeyName; 


--���������
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
SELECT encryptEmail   
    AS '������������� ��������', CONVERT(nvarchar,  
    DecryptByKey(encryptEmail, 1 ,   
    HASHBYTES('SHA2_256', CONVERT(nvarchar, encryptEmail))))  
    AS '�������������� ��������' FROM  Users; 
GO
CLOSE SYMMETRIC KEY KeyName;   
 
 
SELECT * FROM sys.symmetric_keys
SELECT * FROM sys.certificates
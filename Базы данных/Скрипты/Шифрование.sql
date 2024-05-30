--пользователь sa
use master
go
alter login sa with password='password'
go
alter login sa enable 
go



--Создание БД
create table Users(--таблица Пользователи
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
('Пользователь1','1','почта1','89111','Адрес1',null,null,null),
('Пользователь2','2','почта2','89222','Адрес2',null,null,null),
('Пользователь3','3','почта3','89333','Адрес3',null,null,null),
('Пользователь4','4','почта4','89444','Адрес4',null,null,null),
('Пользователь5','5','почта5','89555','Адрес5',null,null,null);
 

create table Category(--таблица Категории
idCategory int identity primary key,
Name nvarchar(max));

insert into Category
values
('Молочные продукты'),
('Овощи и фрукты'), 
('Мясо и птица'), 
('Рыба и морепродукты');
 

create table Products(--таблица Продукты
idProduct int identity primary key,
Name nvarchar(max),
Price money,
Quantity int,
idCategory int foreign key references Category(idCategory));
 
insert into Products
values 
('Макароны', 43.99, 100, 1),
('Сыр', 80.30, 50, 2),
('Яблоки', 30.00, 200, 3),
('Курица', 160.00, 30, 4),
('Креветки', 400.00, 20, 4);
 
--Создадим пользователя
CREATE LOGIN Ivanova
WITH PASSWORD = '123456',
DEFAULT_DATABASE = [iva]
 
--Создадим ключ БД
create master key encryption by
password = 'password'
go

--Создадим сертификат шифрование
create certificate Test with subject = 'description'
 
--Создадим симметричный ключ с помощью созданного сертификата
CREATE SYMMETRIC KEY KeyName WITH ALGORITHM = AES_256
encryption by certificate Test
 
--Зашифруем почту
open symmetric key KeyName DECRYPTION BY CERTIFICATE Test;
UPDATE Users
SET encryptEmail = EncryptByKey(Key_GUID('KeyName')  
    , Email, 1, HASHBYTES('SHA2_256', CONVERT( varbinary  
    , idUser)));  
GO  

--Зашифруем телефон
open symmetric key KeyName DECRYPTION BY CERTIFICATE Test;
UPDATE Users
SET encryptPhone = EncryptByKey(Key_GUID('KeyName')  
    , Phone, 1, HASHBYTES('SHA2_256', CONVERT( varbinary  
    , idUser)));  
GO  

--Зашифруем адрес
open symmetric key KeyName DECRYPTION BY CERTIFICATE Test;
UPDATE Users
SET encryptAddress = EncryptByKey(Key_GUID('KeyName')  
    , Address, 1, HASHBYTES('SHA2_256', CONVERT( varbinary  
    , idUser)));  
GO  
 
--выведем результат
select *
from Users

--дешифруем
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
SELECT encryptEmail   
    AS 'Encrypted logins', CONVERT(varchar,  
    DecryptByKey(encryptEmail, 1 ,   
    HASHBYTES('SHA2_256', CONVERT(nvarchar, encryptEmail))))  
    AS 'Decrypted logins' FROM  Users; 
GO
CLOSE SYMMETRIC KEY KeyName;  
 

--второй метод
--зашифруем почту
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
INSERT INTO Users(Email)
VALUES ( EncryptByKey( Key_GUID('KeyName'), 'Почта пользователя'));  
GO
CLOSE SYMMETRIC KEY KeyName; 

--зашифруем телефон
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
INSERT INTO Users(Phone)
VALUES ( EncryptByKey( Key_GUID('KeyName'), 'Номер'));  
GO
CLOSE SYMMETRIC KEY KeyName; 

--зашифруем адрес
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
INSERT INTO Users(Address)
VALUES ( EncryptByKey( Key_GUID('KeyName'), 'Адрес'));  
GO
CLOSE SYMMETRIC KEY KeyName; 


--дешифруем
OPEN SYMMETRIC KEY KeyName  
   DECRYPTION BY CERTIFICATE Test;
SELECT encryptEmail   
    AS 'Зашифрованные продукты', CONVERT(nvarchar,  
    DecryptByKey(encryptEmail, 1 ,   
    HASHBYTES('SHA2_256', CONVERT(nvarchar, encryptEmail))))  
    AS 'Расшифрованные продукты' FROM  Users; 
GO
CLOSE SYMMETRIC KEY KeyName;   
 
 
SELECT * FROM sys.symmetric_keys
SELECT * FROM sys.certificates
sp_helpsrvrole

sp_srvrolepermission 'dbcreator'

sp_helplogins 'sa'

create table #NameRols(
ServerRole nvarchar(50), 
Permission nvarchar(50))

insert into #NameRols
exec sp_srvrolepermission

select *
from #NameRols
where Permission like 'GRANT%'

create login TestUsers 
with password = '123456'
sp_password '123456', 'password1', 'TestUsers'

create login Iva
with password = '123456',
default_database = [is1_ivanovavaTRBD]

grant alter any database to Iva

sp_helplogins


create user master 
for login Iva 
with default_schema = [dbo]

sp_addrolemember 'db_datareader', 'master'

sp_addrolemember 'db_denydatareader', 'master'

sp_helpsrvrolemember 'diskadmin'

use is1_ivanovavaTRBD;
exec sp_grantdbaccess 'Victoria', 'logIns'

sp_helpuser 'logIns'


sp_addrole 'managers', 'db_datareader'

use is1_ivanovavaTRBD;
grant select on Products to managers;

use is1_ivanovavaTRBD;
exec sp_addrolemember @rolename = 'managers',
					  @membername = 'logIns'


sp_addrole 'clerks', 'db_datareader'

use is1_ivanovavaTRBD;
grant select on Products(Name, Price) to clerks;

use is1_ivanovavaTRBD;
exec sp_adduser 'TestUsers', 'TestUsers', 'clerks'


exec sp_adduser 'Iva', 'Andy', 'clerks'

use is1_ivanovavaTRBD;
deny select on Category 
to clerks
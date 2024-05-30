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
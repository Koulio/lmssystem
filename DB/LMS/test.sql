use LMSDB;

Declare @Result int
set @Result = 0
exec sp_Add_Point '1234567812345678', '1', '150', '000000000000001','00000001','01', @Result
select * from JPOS_Customer
select * from JPOS_Log
select @Result Result
go 

select * from JPOS_Card
--test
Declare @Result int
set @Result = 0
exec sp_Sub_Point '1234567812345678', '1', '150', '000000000000001','00000001','01', @Result
select * from JPOS_Customer
select * from JPOS_Log
select @Result
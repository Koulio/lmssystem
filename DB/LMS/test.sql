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

go 
update JPOS_Customer set JPOS_CurrentPoint = 50 where JPOS_CardId = '8765432112345678';
select * from JPOS_Customer;

select * from JPOS_Card
update JPOS_Customer set JPOS_CurrentPoint='50' where JPOS_IDCustomer='41';
select * from JPOS_Card

Declare @Result int
set @Result = 0
exec sp_redemption '1234567812345678', '3', '1', '000000000000001','00000001','01', @Result
select * from JPOS_Customer
select * from JPOS_Log
select * from JPOS_Log_Exchange
select @Result

select * from JPOS_Gift


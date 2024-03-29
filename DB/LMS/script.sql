use MyTest
go

/*create table*/
create table JPOS_Customer
(
	JPOS_IDCustomer	int not null,
	JPOS_Barcode	varchar(16) not null,
	JPOS_CurrentPoint	int not null,
	primary key (JPOS_IDCustomer)
)

create table JPOS_Log
(
	JPOS_IDLog int not null IDENTITY,
	JPOS_Date	datetime not null,
	JPOS_Task	int not null,
	JPOS_Customer	int not null,
	JPOS_PointGain	int not null,
	JPOS_PointLoss	int not null,
	JPOS_Reasion	nvarchar(200) not null,
	primary key(JPOS_IDLog)
)

create table JPOS_Task
(
	JPOS_IDTask int not null IDENTITY,
	JPOS_TaskName nvarchar(200) not null,
	JPOS_TaskDetail nvarchar(400) not null,
	primary key(JPOS_IDTask)
)

create table JPOS_Log_Exchange
(
	JPOS_IDLog	int not null,
	JPOS_Gift	int not null,
	primary key (JPOS_IDLog)
)

create table JPOS_Gift
(
	JPOS_IDGift		int not null IDENTITY,
	JPOS_GiftName	nvarchar(200) not null,
	JPOS_GiftDetail	nvarchar(400) not null,
	JPOS_PointForGift	int not null,
	primary key (JPOS_IDGift)
)
go
/*create foreign key */

alter table JPOS_Customer
add constraint FK_JPOS_Customer_NOP_Customer foreign key(JPOS_IDCustomer) references NOP_Customer(CustomerID)
go
alter table JPOS_Log
add constraint FK_JPOS_Log_JPOS_Customer foreign key(JPOS_Customer) references JPOS_Customer(JPOS_IDCustomer),
	constraint FK_JPOS_Log_JPOS_Task foreign key (JPOS_Task) references JPOS_Task(JPOS_IDTask)
go
alter table JPOS_Log_Exchange
add constraint FK_JPOS_Log_Exchange_JPOS_Log foreign key(JPOS_IDLog) references JPOS_Log(JPOS_IDLog),
	constraint FK_JPOS_Log_Exchange_JPOS_Gift foreign key(JPOS_Gift) references JPOS_Gift(JPOS_IDGift)
go



/* for drop table and foreign key in database */
alter table JPOS_Customer
drop constraint FK_JPOS_Customer_NOP_Customer
alter table JPOS_Log
drop constraint FK_JPOS_Log_JPOS_Customer,
	constraint FK_JPOS_Log_JPOS_Task
alter table JPOS_Log_Exchange
drop constraint FK_JPOS_Log_Exchange_JPOS_Log,
	constraint FK_JPOS_Log_Exchange_JPOS_Gift
drop table JPOS_Gift,JPOS_Customer,JPOS_Log,JPOS_Task,JPOS_Log_Exchange

/* insert data */
insert into JPOS_Customer values ('38','1234567812345678','0')
insert into JPOS_Customer values ('39','1234567887654321','0')

insert into JPOS_Task(JPOS_TaskName,JPOS_TaskDetail) values('Add Point',N'Cộng điểm')
insert into JPOS_Task(JPOS_TaskName,JPOS_TaskDetail) values('Sub Point',N'trừ điểm')
insert into JPOS_Task(JPOS_TaskName,JPOS_TaskDetail) values('Exchange Point',N'đổi quà')

insert into JPOS_Gift(JPOS_GiftName,JPOS_GiftDetail,JPOS_PointForGift) values(N'Xà bông',N'Chai xà bông sunsilk','100')
insert into JPOS_Gift(JPOS_GiftName,JPOS_GiftDetail,JPOS_PointForGift) values(N'Gấu',N'Gấu bông','120')
insert into JPOS_Gift(JPOS_GiftName,JPOS_GiftDetail,JPOS_PointForGift) values(N'Rượu',N'Chai rượu heneski','240')
insert into JPOS_Gift(JPOS_GiftName,JPOS_GiftDetail,JPOS_PointForGift) values(N'Ly',N'Bộ ly tách bàn tiệc','300')


create procedure sp_Add_Point(@Barcode varchar(16),@Point int,@Reasion	nvarchar(200),@Result int)
as
begin	
	Declare @TaskID int
	Declare @Customer int
	Declare @C cursor
	set @C = cursor for select JPOS_IDTask from JPOS_Task where JPOS_TaskName = 'Add Point'
	
	open @C
	fetch next from @C into @TaskID
	while @@fetch_status = 0
	begin
		select @Customer = JPOS_IDCustomer from JPOS_Customer where JPOS_Barcode = @Barcode
		if  (@@rowcount = 0)
		begin
			set @Result = 0;
			return;
		end

		update JPOS_Customer set JPOS_CurrentPoint = JPOS_CurrentPoint + @Point where JPOS_Barcode = @Barcode					
		if  (@@rowcount = 0)
		begin
			set @Result = 0;
			return;
		end
		
		insert into JPOS_Log(JPOS_Date,JPOS_Task,JPOS_Customer,JPOS_PointGain,JPOS_PointLoss,JPOS_Reasion) 
		values (getdate(),@TaskID,@Customer,@Point,0,@Reasion)				
		if  (@@rowcount = 0)
		begin
			set @Result = 0;
			return;
		end
		fetch next from @C into @TaskID
	end
	close @C
	deallocate @C	
end

create procedure sp_Sub_Point(@Barcode varchar(16),@Point int,@Reasion	nvarchar(200),@Result int)
as
begin	
	Declare @TaskID int
	Declare @Customer int
	Declare @C cursor
	set @C = cursor for select JPOS_IDTask from JPOS_Task where JPOS_TaskName = 'Sub Point'
	
	open @C
	fetch next from @C into @TaskID
	while @@fetch_status = 0
	begin
		select @Customer = JPOS_IDCustomer from JPOS_Customer where JPOS_Barcode = @Barcode
		if  (@@rowcount = 0)
		begin
			set @Result = 0;
			return;
		end

		
		update JPOS_Customer set JPOS_CurrentPoint = JPOS_CurrentPoint - @Point where JPOS_Barcode = @Barcode					
		if  (@@rowcount = 0)
		begin
			set @Result = 0;
			return;
		end
		
		
		insert into JPOS_Log(JPOS_Date,JPOS_Task,JPOS_Customer,JPOS_PointGain,JPOS_PointLoss,JPOS_Reasion) 		
		values (getdate(),@TaskID,@Customer,0,@Point,@Reasion)				
		if  (@@rowcount = 0)
		begin
			set @Result = 0;
			return;
		end
		fetch next from @C into @TaskID
	end
	close @C
	deallocate @C	
end


drop procedure sp_Add_Point
drop procedure sp_Sub_Point


Declare @Result int
set @Result = 0
exec sp_Add_Point '1234567812345678', '150', N'Mua hàng của công ty', @Result
select * from JPOS_Customer
select * from JPOS_Log
select @Result

Declare @Result int
set @Result = 0
exec sp_Sub_Point '1234567812345678', '150', N'Vi phạm nội quy', @Result
select * from JPOS_Customer
select * from JPOS_Log
select @Result


drop table if exists restaurant.ELS9CY
create table restaurant.ELS9CY (id int identity primary key, name varchar (100))

create table restaurant.ELS9CY_eventlog 
(id int identity primary key, operation varchar(100) not null, old_value varchar(100), new_value varchar(100),
constraint chk_operation check (operation in ('insert', 'update', 'delete')))

select * from restaurant.ELS9CY_eventlog 
select * from restaurant.ELS9CY
select * from restaurant.ELS9CY_eventlogRecords

create or alter trigger restaurant.ELS9CY_eventlogRecords on restaurant.ELS9CY_eventlog 
for insert, update, delete
as 
begin
    print 'successful'
end

insert into restaurant.ELS9CY_eventlog (operation, old_value, new_value)
select 'insert', null, 'John'



insert into restaurant.ELS9CY_eventlog(operation, new_value) values ('yourname')
drop trigger restaurant.ELS9CY_eventlogRecords
insert into restaurant.ELS9CY (Name)
values ('John')


insert into restaurant.ELS9CY_eventlog (operation, old_value, new_value)
    select 'insert', null, concat('Customer_id: ', cast(i.ID as varchar(10)), 'Customer_name', i.name)
    from inserted i;
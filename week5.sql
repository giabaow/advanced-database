create table Hotel.sourcetable (id int identity primary key,
name varchar(100), ModifiedOn datetime not null default getdate())

select * from hotel.sourcetable
insert hotel.sourcetable(name) values ('Test1')
select * from hotel.sourcetable

create trigger sourceTablemod on Hotel.sourcetable
After UPDATE
as 
begin 
  update Hotel.sourceTable set modifiedon = getdate()
  from Hotel.sourceTable t join inserted i 
  on t.Id = i.Id 
  join deleted d on d.Id = i.Id 
  where i.name <> d.name
END

select * from hotel.sourceTable -- 2023-10-08 15:43:41.583
update hotel.sourceTable set name = 'Test2' where id = 1

select * from hotel.sourceTable -- 2023-10-08 15:48:11.983

--exerciese 1
create table  (id int identity primary key,
name varchar(100), timestamp datetime not null)

/*create table Hotel.dimdate1206(datekey date primary key, 
quarter int,
year int, 
month int, 
day int)*/



--lower boundary
--upper boundary

declare @mindate date 
declare @maxdate date 
select @mindate=min(invoicedate) from chinook.dbo.Invoice
select @maxdate=max(invoicedate) from chinook.dbo.Invoice
print @mindate
print @maxdate

while @mindate < @maxdate
begin
  insert hotel.dimdate1206 values (@mindate, year(@mindate), datepart(quarter, @mindate),
  month (@mindate), day(@mindate)
  @mindate = dateadd(day,1, @mindate)
end

select datekey, isnull (sum(invoice.total), 0)
from hotel.dimdate1206 hotel left join chinook.dbo.invoice invoice on hotel.datekey = invoice.InvoiceDate
group by datekey
order by datekey

select * from hotel.dimdate1206

select hotel.dimdate1206.datekey, sum(invoice.total)
from hotel.dimdate1206 join chinook.dbo.invoice invoice
group by hotel.dimdate1206.datekey
order hotel.dimdate1206.datekey

select * from
chinook.dbo.invoice

--exercise 2
create table #Dimdate (datekey date primary, year int, month int, day int)

--lower boundary, upper boundary: declare variables and set them to min and max value of orders.orderdate

--start a while loop
--every iteration insert a row into #dimdate
--AND increment @mindate by 1

select * from sys.table t join sys.columns c on t.object_id = c.object_id
where t.name = 'custimers'


/*• Create a table in your teams assigned schema with an ID, a Name and a Timestamp column.
• Create a trigger for this table which sets the timestamp column value to the system date when insert or
update happens.
• Test the triggers with updates and inserts*/

--table creation
create table restaurant.els9cytable
(id int identity primary key,
name varchar(100), time_stamp datetime not null)

--create trigger
create trigger restaurant.update_time
before insert or update on restaurant.els9cytable
for each row 
begin 
update restaurant.els9cytable
set time_stamp = current_timestamp
where id = new_id
end;

select * from restaurant.els9cytable
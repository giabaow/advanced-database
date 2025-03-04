
DROP TABLE IF EXISTS Restaurant.Supplier_els9cy
DROP TABLE IF EXISTS Restaurant.Product_els9cy
DROP TABLE IF EXISTS Restaurant.Warehouse_els9cy
DROP TABLE IF EXISTS Restaurant.Stock_els9cy

Create table Restaurant.Supplier_els9cy (Supplierid int not null identity primary key, Name varchar(100), Email varchar(100), City varchar(100), PostalCode varchar(100), Country varchar(100), Address varchar(100))

Create table Restaurant.Product_els9cy (Productid int not null identity primary key, Name varchar(100), Price Decimal(10,2),Supplierid int not null foreign key references Restaurant.supplier_els9cy(supplierid))

Create table Restaurant.Warehouse_els9cy (Warehouseid int not null identity primary key, Name varchar(100))

Create table Restaurant.Stock_els9cy(Warehouseid int not null foreign key references Restaurant.warehouse_els9cy(Warehouseid), Productid int not null foreign key references Restaurant.product_els9cy(productid), Quantity int, constraint pk_els9cy_stock primary key(warehouseid, productid))

select * from Restaurant.Supplier_els9cy
select * from Restaurant.Product_els9cy
select * from Restaurant.Warehouse_els9cy
select * from Restaurant.Stock_els9cy

select * from [Restaurant].[er_task_type_4_file]

insert into Restaurant.Supplier_els9cy(Name) 
select distinct Suppliername from [Restaurant].[er_task_type_4_file]

insert into Restaurant.Product_els9cy(Name, Price, Supplierid) select distinct ProductName, ProductPrice, Supplierid 
from [Restaurant].[er_task_type_4_file] f join Restaurant.Supplier_els9cy s on f.SupplierName = s.Name

insert into Restaurant.Warehouse_els9cy (Name) select distinct WareHousename from [Restaurant].[er_task_type_4_file]

insert into Restaurant.Stock_els9cy (Warehouseid, Productid, Quantity) select w.Warehouseid, p.Productid, f.StockQuantity
from [Restaurant].[er_task_type_4_file] f 
join Restaurant.Warehouse_els9cy w on f.WareHousename = w.Name 
join Restaurant.Product_els9cy p on f.ProductName = p.Name

drop table Restaurant.Warehouse_els9cy

select * from LibraryMan.Stock_anqscl
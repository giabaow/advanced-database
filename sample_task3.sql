Create table Product(Productid int not null identity primary key, ProductName nvarchar(100), Price int)

Create table Warehouse (Warehouseid int not null identity primary key, Name nvarchar(100))

Create table Supplier (SupplierId int not null identity primary key, Name nvarchar(100), Email nvarchar(100), City nvarchar(100))

Create table StockTransaction (StockTransactionId int identity not null primary key, Warehouseid int foreign key references Warehouse(Warehouseid))

--Create table StockTransactionLine (StockTransactionLineId int identity not null primary key, StockTransactionId int, ProductId int FOREIGN key references Product(Productid))

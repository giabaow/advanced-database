SELECT DISTINCT
    DENSE_RANK() OVER (
        ORDER BY Order_Date, Total_Cost, Table_Number, Special_Requests, 
                 Customer_Name, Customer_Email, Customer_Phone, Menu_Item, 
                 Menu_Item_Price, Menu_Category, Payment_Amount, Payment_Status, 
                 Staff_Name, Staff_Role, Reservation_Date, Reservation_Time, 
                 Reservation_Table_Number
    ) AS New_Order_ID,*
INTO Restaurant.NewRestaurant
FROM 
    Restaurant.restaurant
select * from Restaurant.NewRestaurant

create table restaurant.SpecialRequests
(
SpecialRequest_ID int identity primary key,
Special_Request varchar(100)
)

--drop table restaurant.Staff
create table restaurant.Staff(
Staff_ID int identity primary key,
Staff_Name varchar(100),
Staff_Role varchar(100)
)

create table restaurant.Customers
(
Customer_ID int identity primary key,
Customer_Name varchar(100),
Customer_Email varchar(100),
Customer_Phone varchar(100)
)

create table restaurant.PaymentStatus (
    Status_ID int identity primary key,
    Status_Description varchar(50)
)

create table restaurant.Orders
(
Order_ID int not null primary key,
Customer_ID int not null foreign key references restaurant.Customers(Customer_ID),
Order_date date,
Total_cost decimal(10,2),
Payment_Status int not null foreign key references restaurant.PaymentStatus(Status_ID),
Payment_Amount decimal(10,2),
Table_Number int
)

create table restaurant.reservation
(
Reservation_ID int identity primary key,
Customer_ID int not null foreign key references restaurant.Customers(Customer_ID),
Reservation_Date date,
Reservation_Time time,
TimeReservation_TableNumber int not null,
Staff_ID int not null foreign key references restaurant.Staff(Staff_ID)
)

create table restaurant.MenuCategory
(
MenuCategory_ID int identity primary key,
MenuCategory varchar(100)
)

create  table restaurant.Menu
(
Item_ID int identity primary key,
Menu_Item varchar(100),
Menu_Item_Price decimal(6,2),
MenuCategory_ID int null foreign key references restaurant.MenuCategory(MenuCategory_ID)
)

create table restaurant.CustomerSpecialRequests
(
Customer_ID int not null foreign key references restaurant.Customers(Customer_ID),
SpecialRequest_ID int not null foreign key references restaurant.SpecialRequests(SpecialRequest_ID),
constraint PK_CustomerSpecialRequests primary key(Customer_ID,SpecialRequest_ID)
)

create table restaurant.OrderItems
(
Order_ID int not null foreign key references restaurant.Orders(Order_ID),
Item_ID int not null foreign key references restaurant.Menu(Item_ID),
constraint PK_OrderItems primary key(Order_ID,Item_ID)
)



insert Restaurant.SpecialRequests(Special_Request)
select distinct Special_Requests
from Restaurant.restaurant
--select * from Restaurant.SpecialRequests

insert Restaurant.Staff(Staff_Name,Staff_role)
select distinct Staff_Name,Staff_Role
from Restaurant.restaurant
--select * from Restaurant.Staff

insert restaurant.Customers(Customer_Name,Customer_Email,Customer_Phone)
select distinct Customer_Name,Customer_Email,Customer_Phone 
from Restaurant.restaurant
--select * from restaurant.Customers

insert restaurant.PaymentStatus(Status_Description)
select distinct Payment_Status
from Restaurant.restaurant
--select * from restaurant.PaymentStatus

insert Restaurant.Orders(Order_ID,Customer_ID,Order_date,Total_cost,Payment_Status,Payment_Amount,Table_Number)
select distinct New_Order_ID,Customer_ID,Order_Date,sum(CONVERT(decimal(10, 2),Menu_Item_Price)),Status_ID,convert(decimal(10,2),Payment_Amount),Table_Number
from Restaurant.NewRestaurant nr join Restaurant.PaymentStatus rp on rp.Status_Description=nr.Payment_Status
join Restaurant.Customers c on c.Customer_Name=nr.Customer_Name
group by New_Order_ID,Customer_ID,Order_Date,Status_ID,convert(decimal(10,2),Payment_Amount),Table_Number
--select * from Restaurant.Orders

insert Restaurant.reservation(Customer_ID,Reservation_Date,Reservation_Time,TimeReservation_TableNumber,Staff_ID)
select distinct Customer_ID,Reservation_Date,Reservation_Time,Reservation_Table_Number,Staff_ID
from Restaurant.restaurant r join Restaurant.Customers c on r.Customer_Name=c.Customer_Name
join Restaurant.Staff s on s.Staff_Name=r.Staff_Name
order by Customer_ID
--select * from Restaurant.reservation

insert restaurant.MenuCategory(MenuCategory)
select  distinct Menu_Category
from Restaurant.restaurant

insert Restaurant.Menu(Menu_Item, Menu_Item_Price,MenuCategory_ID)
select distinct Menu_Item,Menu_Item_Price,MenuCategory_ID
from Restaurant.restaurant r join Restaurant.MenuCategory c on r.Menu_Category =c.MenuCategory
--select * from Restaurant.Menu

insert restaurant.CustomerSpecialRequests(Customer_ID,SpecialRequest_ID)
select distinct Customer_ID,SpecialRequest_ID
from Restaurant.restaurant r join Restaurant.Customers c on c.Customer_Name=r.Customer_Name
join Restaurant.SpecialRequests q on q.Special_Request=r.Special_Requests

insert  restaurant.OrderItems(Order_ID,Item_ID)
select o.Order_ID,Item_ID
from Restaurant.NewRestaurant nr 
join Restaurant.Orders o on o.Order_ID=nr.New_Order_ID
join Restaurant.Menu m on m.Menu_Item=nr.Menu_Item

use Datamodeling_practice_G2


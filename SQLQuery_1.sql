select * from employees
select left(firstname, 1) + left(lastname, 1) as [Monogram the employee], * from employees

select *, IIF (unitsinstock = 0, 'Shortage', 'OK') as Stockstatue,
CASE unitsinstock
when 0 then 'shortage'
else 'Ok'
end 
as stockstatue2
from products
order by 1

select * from Customers
where customerid not in (select customerid from orders)

select * from customers c 
where not exists (select * from orders where orders.customerid = c.customerid)


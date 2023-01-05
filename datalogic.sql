
GO
--Down
DROP view  if exists bills
DROP view if EXISTS doctor_prescription_count
DROP view if EXISTS customer_order_validation
DROP view if EXISTS prescription_list
DROP view if EXISTS medicine_stock
DROP view if EXISTS amount_spent
drop trigger if EXISTS t_medicine_available
drop trigger if EXISTS t_medicine_available_d
--Up
go
create view bills as SELECT order_id, customer_name, amount, taxes, amount + taxes as total_amount   
FROM(
SELECT a.order_id, a.customer_name,a.amount, a.amount*0.05 as taxes 
FROM  (SELECT o.order_id, c.customer_first_name + ' ' + c.customer_last_name as customer_name, o.order_quantity*m.medicine_price AS amount 
FROM orders o 
     JOIN customers c 
          ON o.order_customer_id = c.customer_id 
     JOIN medicines m 
          ON o.order_medicine_name = m.medicine_name
) a
)b

GO
/*CREATE TRIGGER t_medicine_available
ON orders
AFTER INSERT,UPDATE
as BEGIN
    update medicines SET
        medicines.medicine_available = medicines.medicine_available - inserted.order_quantity
    from inserted
    where medicines.medicine_name=inserted.order_medicine_name
end

GO
CREATE TRIGGER t_medicine_available_d
ON orders
AFTER DELETE
as BEGIN
    update medicines SET
        medicines.medicine_available = medicines.medicine_available + deleted.order_quantity
    from deleted
    where medicines.medicine_name=deleted.order_medicine_name
end
*/


GO
create view doctor_prescription_count as select d.doctor_first_name+' '+d.doctor_last_name as doctor_name,
SUM(prescription_medicine_quantity) AS 'Total Number medicine prescribed',count(DISTINCT prescription_customer_id )as 'Number of patient'
from prescriptions p join doctors d on p.prescription_doctor_licence_number=d.doctor_licence_number 
Group by p.prescription_doctor_licence_number,d.doctor_first_name,d.doctor_last_name;

GO
create view customer_order_validation as select customer_name,no_of_medicines_ordered,total_orders,sum(p.prescription_medicine_quantity) as total_no_of_medicines_prescribed,
count(p.prescription_customer_id) as no_distinct_medicine_prescribed  from 
(select c.customer_first_name+' '+c.customer_last_name as customer_name,sum(o.order_quantity) as no_of_medicines_ordered,
count(o.order_customer_id )as total_orders ,o.order_customer_id,c.customer_id
from  orders o join customers c on  o.order_customer_id = c.customer_id
group by c.customer_first_name,c.customer_last_name,order_customer_id,customer_id )a join prescriptions p on a.order_customer_id=p.prescription_customer_id
group by customer_name,no_of_medicines_ordered,total_orders;

GO
create view  prescription_list as select c.customer_first_name+' '+c.customer_last_name as customer_name,p.prescription_medicine_name,
p.prescription_medicine_quantity as prescription_quantity,d.doctor_first_name+' '+d.doctor_last_name as doctor_name,
p.prescription_date from prescriptions p join customers c on p.prescription_customer_id=c.customer_id
join doctors d on p.prescription_doctor_licence_number=d.doctor_licence_number;

GO
create view medicine_stock as select order_medicine_name,sum(order_quantity) as medicines_ordered,m.medicine_available 
from orders o join medicines m on o.order_medicine_name=m.medicine_name
group by order_medicine_name,m.medicine_available;

GO
create view amount_spent as select a.customer_name,a.total_medicine_ordered,sum(b.total_amount) as total_amount_spent from 
(select c.customer_first_name+' '+c.customer_last_name as customer_name,sum(o.order_quantity) as total_medicine_ordered
from customers c join orders o on c.customer_id=o.order_customer_id
group by c.customer_first_name,c.customer_last_name )a join bills b on b.customer_name=a.customer_name
group by a.customer_name,a.total_medicine_ordered;





/*select * from medicines
select * from orders

INSERT INTO orders(order_customer_id,order_medicine_name,order_quantity,order_date)
VALUES(1001,'Albuterol',3,'2022-10-13')

delete from orders where order_id=1117 and order_medicine_name='Albuterol'*/
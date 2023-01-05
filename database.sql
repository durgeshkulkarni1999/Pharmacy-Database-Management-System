--create database pharma
use pharma
GO
--- Down
if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_customers_customer_membership_id')
        alter table customers drop constraint fk_customers_customer_membership_id

GO
if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_customers_customer_insurance_id')
        alter table customers drop constraint fk_customers_customer_insurance_id

GO

if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_orders_order_customer_id')
        alter table orders drop constraint fk_orders_order_customer_id

GO

if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_payments_payment_customer_id')
        alter table payments drop constraint fk_payments_payment_customer_id

GO

if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_payments_payment_order_id')
        alter table payments drop constraint fk_payments_payment_order_id

GO

if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_orders_order_approved_employee_id')
        alter table orders drop constraint fk_orders_order_approved_employee_id

GO
if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_medicines_medicine_manufacturer_id')
        alter table medicines drop constraint  fk_medicines_medicine_manufacturer_id

GO
if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_precriptions_prescription_customer_id')
        alter table prescriptions drop constraint fk_precriptions_prescription_customer_id

GO
if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_precriptions_prescription_doctor_licence_number')
        alter table prescriptions drop constraint fk_precriptions_prescription_doctor_licence_number
GO
if exists(select * from information_schema.table_constraints
        where constraint_name = 'fk_precriptions_prescription_medicine_name')
        alter table prescriptions drop constraint fk_precriptions_prescription_medicine_name
GO
DROP table if exists customers
DROP table if exists insurances
DROP table if exists orders 
DROP table if exists payments
DROP table if exists employees
--DROP table if exists approved_orders 
DROP table if exists memberships
DROP table if exists medicines 
DROP table if exists manufacturers
DROP table if exists prescriptions
DROP table if exists doctors 

--UP
GO
create table customers(
    customer_id int identity(1001,1) not null,
    customer_first_name varchar(50) not null,
    customer_last_name varchar(50) not null,
    customer_email varchar(50) not null,
    customer_contact_no varchar(50),
    customer_gender varchar(50) not null,
    customer_date_of_birth DATE not null,
    customer_membership_id int,
    customer_insurance_id varchar(20),
    constraint pk_customers_customer_id primary key (customer_id),
    constraint u_customers_customer_email unique (customer_email)
)
GO
create table insurances(
    insurance_id varchar(20) not null,
    insurance_company varchar(50) not null,
    insurance_start_date date not null,
    insurance_end_date date
    constraint pk_insurances_insurance_id primary key (insurance_id)
)
GO
create table orders(
    order_id int IDENTITY(101,1) not null,
    order_customer_id int not null,
    order_medicine_name varchar(50) not null,
    order_quantity int  not null,
    order_date date not null,
    order_approved_employee_id int,
    order_approved_date date,
    order_status VARCHAR(30) DEFAULT 'Pending',
    constraint pk_orders_order_id primary key (order_id)
)
GO
create table payments(
    payment_customer_id int not null,
    payment_order_id int not null,
    payment_mode varchar(50) not null,
    payment_card_type varchar(50),
    payment_card_no varchar(30),
    payment_date date not null 
)
GO
create table employees(
    employee_id int identity(5001,1) not null,
    employee_first_name varchar(50) not null,
    employee_last_name varchar(50) not null,
    employee_role varchar(50),
    employee_address varchar(50) not null,
    employee_phone_no varchar(50),
    employee_email varchar(50) not null,
    constraint u_employees_employee_email unique (employee_email),
    constraint pk_employees_employee_id primary key (employee_id)
)
GO
create table memberships(
    membership_id int not null,
    membership_name varchar(40) not null,
    membership_perks varchar(50) not null,
    constraint pk_memberships_membership_id primary key (membership_id)   
)
GO
create table medicines(
    medicine_name varchar(50) not null,
    medicine_type varchar(50) not null,
    medicine_manufacturer_id int not null,
    medicine_weight int,
    medicine_expiry_date date not null,
    medicine_price decimal(5,2) not null,
    medicine_available int not null,
    constraint pk_medicines_medicine_name primary key (medicine_name)
)
GO
create table manufacturers(
    manufacturer_id int IDENTITY not null,
    manufacturer_name varchar(50) not null,
    manufacturer_address varchar(100) not null,
    manufacturer_contact_person varchar(50),
    manufacturer_contact_number varchar(50),
    constraint pk_manufacturers_manufacturer_id primary key (manufacturer_id)
)
GO
create table prescriptions(
    prescription_no int not null,
    prescription_customer_id int not null,
    prescription_date date not null,
    prescription_doctor_licence_number varchar(50) not null,
    prescription_medicine_name varchar(50) not null,
    prescription_medicine_quantity int not null,
    constraint pk_prescription_prescription_no primary key (prescription_no)
)
GO
create table doctors(
    doctor_licence_number varchar(50) not null,
    doctor_first_name varchar (30) not null,
    doctor_last_name varchar(30) not null,
    doctor_degree varchar(15) not null,
    doctor_address varchar(50) not null,
    doctor_city varchar(20) not null,
    constraint pk_doctors_doctor_licence_number primary key (doctor_licence_number)
)
GO
-- adding foreign keys
alter table customers
    add CONSTRAINT fk_customers_customer_membership_id FOREIGN key (customer_membership_id)
    REFERENCES memberships(membership_id),
    constraint fk_customers_customer_insurance_id FOREIGN key (customer_insurance_id)
    REFERENCES insurances(insurance_id)
GO
alter table orders
    add CONSTRAINT fk_orders_order_customer_id FOREIGN key (order_customer_id)
    REFERENCES customers(customer_id),
    CONSTRAINT fk_orders_order_approved_employee_id FOREIGN key (order_approved_employee_id)
    REFERENCES employees(employee_id)
GO
alter table payments
    add CONSTRAINT fk_payments_payment_customer_id FOREIGN key (payment_customer_id)
    REFERENCES customers(customer_id),
    CONSTRAINT fk_payments_payment_order_id FOREIGN key (payment_order_id)
    REFERENCES orders(order_id)
GO
alter table medicines
    add CONSTRAINT fk_medicines_medicine_manufacturer_id FOREIGN key (medicine_manufacturer_id)
    REFERENCES manufacturers(manufacturer_id)
GO
alter table prescriptions
    add CONSTRAINT fk_precriptions_prescription_customer_id FOREIGN key (prescription_customer_id)
    REFERENCES customers(customer_id),
    CONSTRAINT fk_precriptions_prescription_doctor_licence_number FOREIGN key (prescription_doctor_licence_number)
    REFERENCES doctors(doctor_licence_number),
    CONSTRAINT fk_precriptions_prescription_medicine_name FOREIGN key (prescription_medicine_name)
    REFERENCES medicines(medicine_name)

-- Inserting values in tables
INSERT INTO insurances(insurance_id,insurance_company,insurance_start_date,insurance_end_date)
VALUES('AT001','Aetna','2018-01-21',null),
('AT002','Aetna','2020-05-12','2025-05-12'),
('AT003','Aetna','2018-09-21','2021-09-20'),
('UTH001','United Health Group','2019-03-12','2023-03-11'),
('UTH002','United Health Group','2019-11-19','2023-11-18'),
('UTH003','United Health Group','2021-04-20',null),
('AN001','Anthem','2019-01-10','2024-01-09'),
('AN002','Anthem','2020-03-15','2025-03-14'),
('AN003','Anthem','2017-12-12','2021-12-11')

INSERT INTO memberships(membership_id,membership_name,membership_perks)
VALUES(1,'Basic','Free Delivery'),
(2,'Standard','10 Percent off'),
(3,'Premium','20 percent off')


INSERT INTO customers(customer_first_name,customer_last_name,customer_email,customer_contact_no,customer_gender,customer_date_of_birth,customer_membership_id,customer_insurance_id) 
VALUES('Tim','David','tim@gmail.com','3157397579','Male','1995-02-21',2,'AT001'),
('Jonny','Head','jon.head@gmail.com','3152019890','Male','1992-04-11',1,'AN003'),
('Amber','Green','ambergreen13@outlook.com','3151782430','Female','1989-09-02',null,'UTH002'),
('Monica','Geller','monica@hotmail.com','8573839871','Female','1990-02-02',1,null),
('Rachel','Jordan','rachjordan@gmail.com','6848639085','Female','1985-03-09',null,'AN001'),
('Ross','Drucker','rossd@gmail.com','6928769086','Male','1987-08-02',3,'AT002'),
('Jack','Lavine','jacklavine@gmail.com','8387377272','Male','1988-02-28',null,'UTH001'),
('Mike','Tyson','mikeytyson@gmail.com','3571227456','Male','1991-01-19',null,'AT003'),
('Jimmy','Tamblin','jimmytamb1987@gmail.com','3156724983','Male','1987-08-21',3,'UTH003'),
('Emma','Watson','emmawatson@gmail.com','8572234242','Female','1990-05-11',null,'AN003')

INSERT INTO manufacturers(manufacturer_name,manufacturer_address,manufacturer_contact_person,manufacturer_contact_number)
VALUES('Johnson & Johnson',' One Johnson & Johnson Plaza New Brunswick New Jersey','James Anderson','6874342331'),
('Pfizer','235 East 42nd Street NY','William Butcher','3158782350'),
('Novartis','One Health Plaza East Hanover NJ','Mark Wood','7879893331')

INSERT INTO medicines(medicine_name,medicine_type,medicine_manufacturer_id,medicine_weight,medicine_expiry_date,medicine_price,medicine_available)
VALUES('Metformin','Tablet',2,450,'2024-12-11',7,196),
('Hydrocodone','Liquid',3,null,'2024-09-24',6.95,194),
('Losartan','Tablet',1,550,'2024-01-21',3.21,189),
('Antihistamines','Capsule',1,650,'2024-02-03',3.99,198),
('Gabapentin','Injection',2,null,'2023-01-29',9.95,191),
('Atrovastatin','Capsule',1,650,'2023-11-30',1.50,192),
('Albuterol','Liquid',3,null,'2024-10-10',1.99,185),
('Omeprazole','Capsule',2,350,'2024-05-12',2.79,181),
('Metoprolol','Tablet',1,650,'2025-01-15',13.49,179),
('Simvastatin','Injection',2,null,'2024-05-12',10.99,190),
('Carvedilol','Liquid',3,null,'2025-10-09',6.75,184),
('Tramadol','Tablet',1,450,'2025-01-04',7.45,182),
('Aspirin','Capsule',2,650,'2025-03-15',2.50,195),
('Ibuprofen','Tablet',3,350,'2024-02-11',4.00,197),
('Insulin','Injection',1,null,'2024-05-06',6.75,193)

GO
INSERT INTO employees(employee_first_name,employee_last_name,employee_role,employee_address,employee_phone_no,employee_email)
VALUES('Alex','Stewart','Pharmacist','312 Livingstone Ave','3152904561','Alex.Stewart@jkpharma.com'),
('Ben','Stokes','Senior Pharmacist','214 Nottingham Ave','8571256121','Ben.Stokes@jkpharma.com'),
('Harry','Osborn','Pharmacist','198 E Genesse St',null,'Harry.Osborn@jkpharma.com'),
('Peter','Parker','CEO','112 Buckingham Ave','3571294780','Peter.Parker@jkpharma.com'),
('Oliviya','Johnson','Billing Specialist','1080 Walnut Pl','3129895630','Oliviya.Johnson@jkpharma.com'),
('Jack','Sparrow','Manager','156 Euclid Ave','3152347891','Jack.Sparrow@jkpharma.com'),
('Ross','Buttler','Senior Pharmacist','118 Westcott St', null,'Ross.Buttler@jkpharma.com')

INSERT INTO orders(order_customer_id,order_medicine_name,order_quantity,order_date,order_approved_employee_id,order_approved_date,order_status)
VALUES(1005,'Tramadol',2,'2022-10-10',5002,'2022-10-11','Approved'),
(1009,'Aspirin',3,'2022-10-15',5007,'2022-11-03','Approved'),
(1004,'Gabapentin',1,'2022-10-29',5007,'2022-11-03','Approved'),
(1002,'Ibuprofen',2,'2022-11-03',5001,'2022-09-12','Approved'),
(1008,'Omeprazole',3,'2022-11-02',5002,'2022-11-03','Approved'),
(1006,'Carvedilol',1,'2022-10-15',5002,'2022-10-17','Approved'),
(1010,'Simvastatin',3,'2022-10-19',5001,'2022-10-24','Declined for payment error'),
(1002,'Omeprazole',3,'2022-10-11',5002,'2022-10-16','Approved'),
(1004,'Insulin',4,'2022-10-29',5003,'2022-11-01','Approved')

GO
INSERT INTO orders(order_customer_id,order_medicine_name,order_quantity,order_date)
VALUES (1008,'Albuterol',2,'2022-11-02'),
(1001,'Atrovastatin',4,'2022-11-22'),
(1003,'Metformin',2,'2022-11-03'),
(1005,'Metoprolol',2,'2022-09-10'),
(1007,'Losartan',4,'2022-11-01'),
(1010,'Tramadol',2,'2022-10-04'),
(1010,'Hydrocodone',2,'2022-11-09')

GO

INSERT INTO payments(payment_customer_id,payment_order_id,payment_mode,payment_card_type,payment_card_no,payment_date)
VALUES(1005,101,'Card','Credit','602342104521','2022-10-10'),
(1005,109,'Card','Credit','602342104521','2022-09-10'),
(1009,102,'Card','Debit','424713445639','2022-10-15'),
(1008,103,'Bank Transfer',null,null,'2022-11-02'),
(1008,108,'Bank Transfer',null,null,'2022-11-02'),
(1004,104,'Card','Credit','452190562398','2022-10-29'),
(1004,116,'Card','Credit','452190562398','2022-10-29'),
(1002,105,'Insurance Claim',null,null,'2022-11-05'),
(1002,115,'Insurance Claim',null,null,'2022-10-15'),
(1001,106,'Card','Debit','421456132904','2022-11-22'),
(1003,107,'Bank Transfer',null,null,'2022-11-03'),
(1006,110,'Insurance Claim',null,null,'2022-10-15'),
(1007,111,'Card','Credit','901127813401','2022-11-01'),
(1010,112,'Crad','Credit','619023108924','2022-10-04'),
(1010,113,'Crad','Credit','619023108924','2022-10-19'),
(1010,114,'Crad','Credit','619023108924','2022-11-09')

INSERT INTO doctors(doctor_licence_number,doctor_first_name,doctor_last_name,doctor_degree,doctor_address,doctor_city)
VALUES('M1012905357','Chris','Ampersand','MBBS','190 Wavelry Ave','New Jersey'),
('M10128945678','George','Washington','MD','110 West Genesse st','New York'),
('L18083984390','Amy','Jackson','BHMS','901 Buckingham Ave','Boston'),
('H90234518930','Ravi','Roshan','MBBS','834 Livingstone St','San Fransico'),
('M14590248902','Josh','Hazelwood','MD','1011 Ostrom Ave','Chicago')

INSERT INTO prescriptions(prescription_no,prescription_customer_id,prescription_date,prescription_doctor_licence_number,prescription_medicine_name,prescription_medicine_quantity)
VALUES(101001,1005,'2022-10-09','M10128945678','Tramadol',2),
(101002,1009,'2022-10-14','M14590248902','Aspirin',3),
(101003,1008,'2022-11-01','M1012905357','Albuterol',2),
(101004,1004,'2022-10-29','H90234518930','Gabapentin',1),
(101005,1002,'2022-11-02','L18083984390','Ibuprofen',2),
(101006,1001,'2022-11-20','M14590248902','Atrovastatin',4),
(101007,1003,'2022-11-02','H90234518930','Metformin',2),
(101008,1008,'2022-11-02','L18083984390','Omeprazole',3),
(101009,1005,'2022-09-09','M10128945678','Metoprolol',2),
(101010,1006,'2022-10-14','M1012905357','Carvedilol',1),
(101011,1007,'2022-10-29','M14590248902','Losartan',4),
(101012,1010,'2022-10-03','M10128945678','Tramadol',2),
(101013,1010,'2022-10-18','M10128945678','Simvastatin',3),
(101014,1010,'2022-11-07','M10128945678','Hydrocodone',2),
(101015,1002,'2022-10-10','L18083984390','Omeprazole',3),
(101016,1004,'2022-10-29','H90234518930','Insulin',4)

/*
INSERT INTO approved_orders(approved_order_order_id,approved_order_employee_id,approved_order_date)
VALUES(105,5002,'2022-11-04'),
(108,5007,'2022-11-03'),
(103,5007,'2022-11-03'),
(109,5001,'2022-09-12'),
(115,5003,'2022-10-11'),
(112,5002,'2022-10-07'),
(113,5002,'2022-10-21'),
(114,5002,'2022-11-11'),
(115,5002,'2022-10-11'),
(101,5001,'2022-10-10')
*/



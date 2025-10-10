create database vishwasnew;
use vishwasnew;
create table person (driver_id varchar(10),
name varchar(20),
address varchar(30),
primary key(driver_id));
create table car(reg_num varchar(10),
model varchar(10),
year int,
primary key(reg_num));
create table accident(report_num int,
accident_date date,
location varchar(20),
primary key(report_num));
create table owns(driver_id varchar(10),
reg_num varchar(10),
primary key(driver_id, reg_num),
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num));
create table participated(driver_id varchar(10),
reg_num varchar(10),
report_num int,
damage_amount int,
primary key(driver_id, reg_num, report_num),
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num),
foreign key(report_num) references accident(report_num));
insert into person (driver_id, name, address) VALUES
('A01', 'Richard', 'Srinivas nagar'),
('A02', 'Pradeep', 'Rajaji nagar'),
('A03', 'Smith', 'Ashok nagar'),
('A04', 'Venu', 'N R Colony'),
('A05', 'Jhon', 'Hanumanth nagar');
select * from person;
insert into car (reg_num, model, year) VALUES
('KA052250', 'Indica', 1990),
('KA031181', 'Lancer', 1957),
('KA095477', 'Toyota', 1998),
('KA053408', 'Honda', 2008),
('KA041702', 'Audi', 2005);
select * from car;
insert into owns (driver_id, reg_num) VALUES
('A01', 'KA052250'),
('A02', 'KA053408'),
('A03', 'KA031181'),
('A04', 'KA095477'),
('A05', 'KA041702');
select * from owns;
insert into accident (report_num, accident_date, location) VALUES
(11, '2003-01-01', 'Mysore Road'),
(12, '2004-02-02', 'South end Circle'),
(13, '2003-01-21', 'Bull temple Road'),
(14, '2005-02-17', 'Mysore Road'),
(15, '2005-03-04', 'Kanakapura Road');
select * from accident;
insert into participated (driver_id, reg_num, report_num, damage_amount) VALUES
('A01', 'KA052250', 11, 10000),
('A02', 'KA053408', 12, 50000),
('A03', 'KA095477', 13, 25000),
('A04', 'KA031181', 14, 3000),
('A05', 'KA041702', 15, 5000);
select * from participated;
update participated set damage_amount=25000 where reg_num='KA053408' and report_num=12;
select * from participated;
insert into accident values(16,'2008-03-15','Domlur');
select * from accident;
select accident_date, location
from ACCIDENT;
select driver_id
from PARTICIPATED
where damage_amount >=25000;


-- Show all accidents (date and location)
select accident_date, location
from ACCIDENT;

-- Find drivers who caused damage ≥ 25000
select p.name NAME,part.damage_amount AMOUNT
from PARTICIPATED part, PERSON p
where part.damage_amount >=25000 && part.driver_id=p.driver_id;

-- List each driver with the cars they own (one row per ownership)
select person.name Owner, car.model
from person, car, owns
where person.driver_id = owns.driver_id && owns.reg_num = car.reg_num;

-- Show accidents and the drivers involved (including damage amount)
select participated.report_num,person.name, participated.damage_amount
from participated, person
where participated.driver_id= person.driver_id;

-- Total damage per accident report
select report_num , sum(damage_amount)
from participated
group by report_num;

-- Drivers who were involved in more than one accident
select name
from person
where driver_id in( select driver_id
from participated
                    group by driver_id
                    having count(driver_id)>1);
                                                   


-- Cars that never had an accident (owned but not in participated)
select reg_num
from owns
where driver_id not in (select driver_id
from participated);
                       
-- Latest accident (most recent accident_date)
select participated.reg_num
from participated,accident
where accident.accident_date = (select max(accident_date) from accident) && participated.report_num = accident.report_num;

-- Average damage amount per driver
select avg(damage_amount) , driver_id
from participated
group by driver_id;

-- Update: set damage_amount = 25000 for a specific car & report (example)
update participated
set damage_amount=25000
where reg_num='KA053408' and report_num=12;

-- Find drivers who caused the maximum damage in any single accident
select driver_id, damage_amount
from participated
where damage_amount = (select max(damage_amount) from participated);

-- Show cars (model) involved in accidents with total damage > 20000
select model
from car
where reg_num in (select reg_num
from owns
                where driver_id in ( select driver_id
from participated
                                    where damage_amount > 20000));

-- Create a view summarizing accidents with participants count and total damage
create view caraccidents as
select driver_id, count(driver_id), sum(damage_amount)
from participated
group by driver_id;

select * from caraccidents;

SELECT * FROM PARTICIPATED ORDER BY DAMAGE_AMOUNT DESC;

/*Problem week 2 doc*/

/*Display the entire CAR relation in the ascending order of manufacturing year.*/
select * from car order by year;

/*Find the number of accidents in which cars belonging to a specific model (example
&#39;Lancer&#39;) were involved.*/

select car.model, count(p.reg_num) as "Num of Accidents" from car, participated p where p.reg_num=car.reg_num group by(p.reg_num);

select count(reg_num) as count from car where year=2008 group by (reg_num);

/*select car.model, count(p.reg_num), a.accident_date from car, participated p,accident a where p.reg_num=car.reg_num and
a.report_num=p.report_num and a.accident_date like "2008%" group by(p.reg_num);*/

select c.model, count(p.reg_num) as count
from car c, participated p, accident a
where c.reg_num =p.reg_num
and a.report_num=p.report_num
and a.accident_date like "2008%" group by(c.model);

select * from participated order by damage_amount desc;

select avg(damage_amount) from participated;

DELETE p FROM participated p JOIN (SELECT AVG(damage_amount) AS avg_damage  FROM participated) avg_table WHERE p.damage_amount < avg_table.avg_damage;

select*from participated;

select name from person a , participated b where a.driver_id=b.driver_id and damage_amount>(select avg(damage_amount) from participated);

select max(damage_amount) from participated;

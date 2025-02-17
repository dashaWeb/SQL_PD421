create database UniversityPD_421

use UniversityPD_421

/*
	Типи зв'язків:
		- One to one (один до одного)
		- One to Many (один до багатьох)
		- Many to many (багато до багатьох)
*/
------------- Groups ---------------------
create table Groups
(
	Id int primary key identity(1,1),
	Name nvarchar(50) not null check(Name <> '')
)

insert Groups
values  ('Dublin'),
		('Delaware'),
		('New-York'),
		('Masachusets')

select* from Groups

--------------- Students --------------------
-- foreign key(column) references table(column)
create table Students
(
	Id int primary key identity(1,1),
	[Name] nvarchar(50) NOT NULL check([Name] <> ''),
	Surname nvarchar(50) NOT NULL check(Surname <>''),
	Email nvarchar(30) NULL unique,
	Birthdate date NOT NULL check(Birthdate <= GETDATE()), -- GETDATE() - повертає поточну дату
	AverageMark real NULL check(AverageMark between 1 and 12) default(1), -- AverageMark >= 1 AND AverageMark <= 12
	Lessons int not null default(0) check(Lessons >= 0),
	Fails int not null default(0),
	-- вказуємо зв'язок з групою в студента, студент має одну групу - група багато студентів
	GroupId int null references Groups(Id), -- в даному випадку foreign key вказувати не обов'язково
	check(Fails <= Lessons),
	--foreign key(GroupId) references Groups(Id)
)
select* from Students

--------- Teachers -----------
create table Teachers
(
	Id int primary key identity(1,1),
	Name nvarchar(50) not null,
	HireDate date,
	Phone varchar(20)
)
insert into Teachers ([Name], HireDate, Phone) values ('Pacorro Wenden', '2010-03-25', '+62 (176) 183-4778');
insert into Teachers ([Name], HireDate, Phone) values ('Emmalynn Noyce', '2021-04-12', '+86 (373) 494-3009');
insert into Teachers ([Name], HireDate, Phone) values ('Lethia Josum', '2010-02-28', '+33 (560) 525-2009');
insert into Teachers ([Name], HireDate, Phone) values ('Belia Face', '2010-10-22', '+62 (564) 318-5550');
insert into Teachers ([Name], HireDate, Phone) values ('Karoly Gerauld', '2020-06-02', '+81 (263) 298-5007');
select * from Teachers

-- проміжна таблиця для реалізації зв'язка many to many

create table TeachersGroups
(
	TeacherId int references Teachers(Id),
	GroupId int references Groups(Id)
	primary key(TeacherId, GroupId)
)

select * from Teachers
select * from Groups

-- встановлюємо зв'язки між Teachers та Groups
insert into TeachersGroups
values 
	(1,1),
	(1,2),
	(2,3),
	(3,3)

select* from TeachersGroups

-----------------
select* from Students
select * from Teachers
select * from Groups
select* from TeachersGroups

select s.Name, s.AverageMark, s.GroupId, g.Id, g.Name
from Groups as g, Students as s
where g.Id = s.GroupId and g.Name = 'Dublin' and s.AverageMark >=10
order by s.AverageMark desc

select t.Name, t.Phone, g.Name
from Teachers as t, Groups as g, TeachersGroups as tg
where tg.TeacherId = t.Id and tg.GroupId = g.Id and t.Name = 'Pacorro Wenden'


-- Join оператор використовується саме для звязування записів по зовнішньому ключу
-- from table_a join table_b on table-a_foreaignKey = table_b_primary key

select s.Name, s.AverageMark, g.Name
from Students as s join Groups as g on s.GroupId = g.Id
where s.AverageMark >= 7
order by g.Name


select top 3 s.Name, s.Email, s.AverageMark, g.Name
from Students as s join Groups as g on s.GroupId = g.Id
where g.Name = 'Dublin'
order by s.AverageMark desc

select t.Name, t.Phone, g.Name
from Teachers as t join TeachersGroups as tg on tg.TeacherId = t.Id
					join Groups as g on tg.GroupId = g.Id

select  s.Name, s.Surname, s.Email, g.Name, t.Name
from Students as s join Groups as g on g.Id = s.GroupId
					join TeachersGroups as tg on tg.GroupId = g.Id
					join Teachers as t on t.Id = tg.TeacherId
where s.Surname = 'Kondratenko'
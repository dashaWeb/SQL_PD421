-- one line comment
/* more line comment*/

/* DDL (DataDefinition Language)
		CREATE - створення об'єкта
		ALTER - зміна об'єкта
		DROP - видалення об'єкта
*/

create database ITStepAcademy
drop database ITStepAcademy

use ITStepAcademy
-- ім'я_колонки тип_даних обмеження1 обмеження2 
/*
-- обмеження для колонок:
		-- NOT NULL / NULL - дозволяє/забороняє колонці мати значення NULL
		-- UNIQUE - гарантує, що в колонці не буде дублікатів
		-- PRIMARY KEY - первинний ключ, який включає обмеження NOT NULL та UNIQUE
		-- IDENTITY(seed, increment) - встановлює автоінкремент. seed: початкове значення, increment: значення приросту (за замовчуванням 1,1)
		-- DEFAULT(value) - встановлює значення за замовчуванням для колонки, коли значення не вказано
		-- CHECK(condition) - гарантує, що всі значення в колонці будуть відповідати логічній умові
		-- FOREIGN KEY column REFERENCES table(column) - встановлює зовнішній ключ для зв'язку з таблицею
		-- AS - значення в колонці будуть розраховуватися

*/
-- логічні оператори : > < >= <= = <>(!= C#) !< !>
-- логічне і  (&&)  : AND  
-- логічне або (||) : OR
create table Students
(
	Id int primary key identity(1,1),
	[Name] nvarchar(50) NOT NULL check([Name] <> ''),
	Surname nvarchar(50) NOT NULL check(Surname <>''),
	Email nvarchar(30) NOT NULL unique,
	Birthdate date NOT NULL check(Birthdate <= GETDATE()), -- GETDATE() - повертає поточну дату
	AverageMark real NULL check(AverageMark between 1 and 12), -- AverageMark >= 1 AND AverageMark <= 12
	IsDebtor bit NOT NULL default(0),
	Lessons int not null default(0) check(Lessons >= 0),
	NonAttendances int not null default(0) check(NonAttendances >= 0),
	Visitings AS Lessons - NonAttendances,
	check(NonAttendances <= Lessons)
)

alter table Students
	add DegreeDate date not null default(getdate())

alter table Students
	alter Column Name nvarchar(100)

--execute sp_rename 'Students.Name', 'FirstName', 'COLUMN'

drop table Students

select * from Students

insert into Students
values
	('Semen','Lublin','semen@gmail.com', '2000/4/10',11,default, 122,17)



insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Franciskus', 'Heindrich', 'fheindrich0@cbc.ca', '2002/02/21', 4.8, 1, 157, 48);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Breena', 'Shelmardine', 'bshelmardine1@lulu.com', '2002/03/30', 2.5, 1, 192, 16);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Ariana', 'Worms', 'aworms2@loc.gov', '2006/05/24', 2.2, 0, 69, 40);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Reyna', 'Beswetherick', 'rbeswetherick3@cnbc.com', '2001/07/14', 7.1, 1, 73, 15);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Darrel', 'De Domenico', 'ddedomenico4@hugedomains.com', '2018/07/11', 2.3, 1, 71, 36);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Belia', 'Goodchild', 'bgoodchild5@sohu.com', '2010/06/20', 10.1, 1, 196, 13);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Rabbi', 'Wattam', 'rwattam6@vk.com', '2012/04/11', 3.2, 0, 132, 30);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Ina', 'Pinnere', 'ipinnere7@cbsnews.com', '2008/10/11', 6.9, 0, 196, 43);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Karlotte', 'Rois', 'krois8@google.de', '2007/12/25', 4.6, 1, 169, 33);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Maryellen', 'Tours', 'mtours9@1688.com', '2009/02/04', 8.5, 1, 143, 16);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Fitzgerald', 'Darracott', 'fdarracotta@stanford.edu', '2020/06/24', 2.7, 0, 69, 14);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Skye', 'Roxburch', 'sroxburchb@imageshack.us', '2017/08/16', 1.4, 1, 104, 18);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Dagmar', 'Denziloe', 'ddenziloec@tumblr.com', '2017/04/08', 2.6, 1, 155, 25);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Miles', 'Caudle', 'mcaudled@tmall.com', '2018/01/03', 8.2, 1, 199, 34);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Emery', 'McLardie', 'emclardiee@sina.com.cn', '2007/11/25', 7.0, 1, 63, 31);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Briant', 'MacWhirter', 'bmacwhirterf@discuz.net', '2015/09/02', 7.7, 0, 167, 38);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Donia', 'Schnitter', 'dschnitterg@sitemeter.com', '2015/08/01', 3.3, 1, 131, 25);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Valeda', 'Muzzall', 'vmuzzallh@epa.gov', '2010/08/29', 11.4, 1, 193, 23);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Killie', 'Naire', 'knairei@noaa.gov', '2019/11/28', 2.1, 0, 63, 26);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Mimi', 'Ovett', 'movettj@drupal.org', '2010/03/04', 7.8, 1, 188, 28);
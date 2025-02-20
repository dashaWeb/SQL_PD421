-- Aggregate Functions
/*
	COUNT() - обчислює кількість записів (працює з символьними та числовими типами)
	SUM()	- обчислює суму всіх значень (працює з числовими типами)
	AVG()	- обчислює середнє значення по всіх записах (працює з числовими типами)
	MIN()	- обчислює мінімальне значення (працює з символьними та числовими типами)
	MAX()	- обчислює максимальне значення (працює з символьними та числовими типами)
*/
insert into Students ([Name], Surname, Email, Birthdate) values ('Gabriele', 'Streater', 'gstreater0@businessinsider.com', '2012-03-24');
insert into Students ([Name], Surname, Email, Birthdate) values ('Reid', 'Rivenzon', 'rrivenzon1@istockphoto.com', '2004-06-02');
insert into Students ([Name], Surname, Email, Birthdate) values ('Dody', 'Brauns', 'dbrauns2@home.pl', '2007-01-13');
insert into Students ([Name], Surname, Email, Birthdate) values ('Melany', 'Brocklesby', 'mbrocklesby3@sfgate.com', '2003-06-26');
insert into Students ([Name], Surname, Email, Birthdate) values ('Elliot', 'Peron', 'eperon4@flickr.com', '2014-05-31');

-- COUNT
select Id from Students
select COUNT(Id) as 'Number of Students' from Students
-- при роботі з конкретною колонкою, NULL-значення ігноруються
select * from Students

select COUNT(GroupId) as 'Number of Students' from Students

select COUNT(Id) as 'Good Students' from Students
where AverageMark >= 10

-- MIN/MAX
select Min(AverageMark) as 'Result' from Students
where YEAR(Birthdate) <= 2002
select Max(AverageMark) as 'Result' from Students
-- ROUND() - rounds a number to a specified number of decimal places.
-- FLOOR() - returns the largest integer value that is smaller than or equal to a number.
-- CEILING() - returns the smallest integer value that is larger than or equal to a number.

-- SUM/AVG
select ROUND(AVG(AverageMark),2) as 'Result'
from Students

select COUNT(s.Id) as 'Count of Students',
		Sum(Fails) as 'Sum of Fails',
		Avg(AverageMark) as 'Average mark by Group'
from Students as s join Groups as g on s.GroupId = g.Id
where g.Name = 'Dublin'

select * from Groups


select g.Name, COUNT(s.Id)
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name

select GroupId, COUNT(Id)
from Students
group by GroupId

select AverageMark, COUNT(Id) as CountAsStudents
from Students
where YEAR(Birthdate) > 2003
group by AverageMark
having COUNT(Id) > 1
order by CountAsStudents

select g.Name,
		Avg(s.AverageMark) as 'Group Average Mark',
		Sum(s.AverageMark) as 'Group Total Mark',
		Count(s.Id) as 'Students Count'
from Groups as g join Students as s on s.GroupId = g.Id
group by g.Name
having AVG(AverageMark) >= 9


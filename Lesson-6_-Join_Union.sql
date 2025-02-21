insert into Students ([Name], Surname, Email, Birthdate) values ('Gabriele', 'Streater', 'gstreater0@businessinsider.com', '2012-03-24');
insert into Students ([Name], Surname, Email, Birthdate) values ('Reid', 'Rivenzon', 'rrivenzon1@istockphoto.com', '2004-06-02');
insert into Students ([Name], Surname, Email, Birthdate) values ('Dody', 'Brauns', 'dbrauns2@home.pl', '2007-01-13');
insert into Students ([Name], Surname, Email, Birthdate) values ('Melany', 'Brocklesby', 'mbrocklesby3@sfgate.com', '2003-06-26');
insert into Students ([Name], Surname, Email, Birthdate) values ('Elliot', 'Peron', 'eperon4@flickr.com', '2014-05-31');
select * from Students

select s.Name, s.Email, s.AverageMark, g.Name as [Groups]
from Students as s inner join Groups as g on g.Id = s.GroupId 

select s.Name, s.Email, s.AverageMark, g.Name as [Groups]
from Students as s left join Groups as g on g.Id = s.GroupId 

select s.Name, s.Email, s.AverageMark, g.Name as [Groups]
from Students as s left join Groups as g on g.Id = s.GroupId 
where s.GroupId is null


select s.Name, s.Email, s.AverageMark, g.Name as [Groups]
from Students as s right join Groups as  g on g.Id = s.GroupId

select * from Groups
insert into Groups
values ('Ukraine')

select s.Name, s.Email, s.AverageMark, g.Name as [Groups]
from Students as s right join Groups as  g on g.Id = s.GroupId
where s.GroupId is null

select s.Name, s.Email, s.AverageMark, g.Name as [Groups]
from Students as s full outer join Groups as  g on g.Id = s.GroupId

select s.Name, s.Email, s.AverageMark, g.Name as [Groups]
from Students as s full outer join Groups as  g on g.Id = s.GroupId
where s.GroupId is null

-- union - обєднує декілька запитів в одну результуючу таблицю при цьому видаляючи дублікати 

select 'Students Count', COUNT(Id)
from Students
union
select 'AverageMark', AVG(AverageMark)
from Students


select Id, Surname
from Students
union
select Id, Name
from Teachers

select Id, Name
from Students
where Name like 'S%'
--order by Name
union
select Id, Name
from Teachers
where Name like 'S%'
order  by Name


-- union all - обєднує декілька запитів в одну результуючу таблицю при цьому  дублікати не видаляючи

select Id, Surname
from Students
where AverageMark >= 10
union all
select Id, Surname
from Students
where AverageMark >= 7
order by Surname
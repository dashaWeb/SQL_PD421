use UniversityPD_421

select* from Students
select * from Teachers
select * from Groups
select* from TeachersGroups
select Name, Email, AverageMark
from Students
where AverageMark = (
				select Max(AverageMark)
				from Students)

select g.Name, Avg(AverageMark), COUNT(s.Id)
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name
having COUNT(s.Id) = (
	select top 1 COUNT(s.Id)
	from Students as s join Groups as g on s.GroupId = g.Id
	group by g.Name
	order by COUNT(s.Id) desc
)




select g.Name, Avg(AverageMark), COUNT(s.Id)
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name
having COUNT(s.Id) = (
	select top 1 COUNT(s.Id)
	from Students as s join Groups as g on s.GroupId = g.Id
	group by g.Name
	order by COUNT(s.Id) desc
)
or COUNT(s.Id) =(
		select top 1 COUNT(s.Id)
		from Students as s join Groups as g on s.GroupId = g.Id
		group by g.Name
		order by COUNT(s.Id) 
	)

	select Id, Name, Birthdate
	from Students
	where Id IN(select Id 
				from Students
				where Name like 'C%')

select t.Id, t.Name as [Teachers], AVG(s.AverageMark) as [Mark], Count(s.Id) as [Students]
from Teachers as t join TeachersGroups as tg on t.Id = tg.TeacherId
				join Groups as g on tg.GroupId = g.Id
				join Students as s on g.Id = s.GroupId
group by t.Name, t.Id
having COUNT(s.Id) / 2 < (
			select COUNT(s.Id)
				from Teachers as t2 join TeachersGroups as tg on t.Id = tg.TeacherId
				join Groups as g on tg.GroupId = g.Id
				join Students as s on g.Id = s.GroupId
				where s.AverageMark >= 5 and t.Id = t2.Id
) 


/*
	Subquery Operators
		- [NOT] EXISTS - повертає true якщо запит повернув хоча б один запис
		- [> < >= <= <> = ] ANY/SOME - повертає true якщо хоча б один запис відповідає умові
		- [> < >= <= <> = ] ALL - повертає true якщо всі записи відповідають умові
*/


select Name
from Groups
where EXISTS (
	select Id 
	from Students
	where AverageMark = 11.7 and GroupId = Groups.Id
)


select Name, Phone
from Teachers
where EXISTS (
	select s.Id
	from Students as s join Groups as g on s.GroupId = g.Id
						join TeachersGroups as tg on g.Id = tg.GroupId
						where tg.TeacherId = Teachers.Id and s.Name = 'Zorina'
)

select g.Name
from Groups as g
where EXISTS (
	select s.Id
		from Students as s
		where s.GroupId = g.Id and DATEDIFF(YEAR, s.Birthdate, GETDATE()) >= 20
)


select Name, Birthdate, Email
from Students
where Birthdate > ANY (select HireDate from Teachers)

select Name, Email, GroupID
from Students
where Name = ANY (select s.Name from Students as s
					where s.GroupId <> Students.GroupId)

select s.Name, s.Email, s.AverageMark, g.Name
from Groups as g join Students as s on s.GroupId = g.Id
where AverageMark > ALL (select AverageMark 
							from Groups as g join Students as s on s.GroupId = g.Id
							where g.Name = 'Delaware' and s.AverageMark is not null)

select Name, Phone, HireDate
from Teachers
where HireDate < ALL (
		select s.Birthdate
		from Students as s join Groups as g on s.GroupId = g.Id
				join TeachersGroups as tg on tg.GroupId = g.Id
				where tg.TeacherId = Teachers.Id				
)
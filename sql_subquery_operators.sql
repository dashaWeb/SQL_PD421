/* Subquery Operators
	- [NOT] EXISTS				  - повертає TRUE якщо запит повернув хоча б один запис
	- [> < >= <= <> =] ANY / SOME - повертає TRUE якщо хоча б одни запис відповідає умові
	- [> < >= <= <> =] ALL		  - повертає TRUE якщо всі записи відповідають умові
*/


use University;

/*
...
where/having [NOT] EXISTS (query)
...
*/
-- показати викладічів, які мають хоча б одну групу
select Id, Name, Phone
from Teachers as t
where EXISTS (select *
			  from TeachersGroups as tg
			  where tg.TeacherId = t.Id)

-- показати групи, які мають хоча б одного студента з оцінкою 12
select Name
from Groups
where EXISTS (select Id
			  from Students 
			  where AverageMark >= 11.3 AND GroupId = Groups.Id)

select * from Students where AverageMark = 12

-- показати викладачів, які мають хоча б одного студента з іменем 'Taras'
select Name, Phone
from Teachers
where EXISTS (select s.Id
			  from Students as s JOIN Groups as g ON s.GroupId = g.Id
								 JOIN TeachersGroups as tg ON tg.GroupId = g.Id
			  where tg.TeacherId = Teachers.Id AND s.Name = 'Igor')

-- показати групи, які мають хоча б одного випускника
select g.Name, COUNT(s.Id)
from Groups as g JOIN Students as s ON s.GroupId = g.Id
where EXISTS (select Id
			  from Students
			  where IsGraduate = 1 AND GroupId = g.Id)
group by g.Name

-- показати групи в яких є хоча б один студент старше 20-ти
select Name
from Groups as g
where EXISTS (select Id
			  from Students as s
			  where DATEDIFF(YEAR, s.BirthDate, GETDATE()) >= 20 AND s.GroupId = g.Id);


select Name, Phone
from Teachers
where EXISTS (select s.Id
				  from Students as s JOIN Groups as g ON s.GroupId = g.Id
									 JOIN TeachersGroups as tg ON tg.GroupId = g.Id
				  where s.AverageMark IS NULL AND tg.TeacherId = Teachers.Id)


/*
...
where/having [> < >= <= <> =] ANY/SOME / ALL (query)
...
*/
-- показати студентів, в яких ім'я співпадає з іменем якогось викладача
select Name, Email, AverageMark
from Students
where Name = SOME (select Name
			       from Teachers)

-- показати студентів, в яких дата народження більша за дату прийняття на роботу будь-якого викладача
select Name, BirthDate, Email
from Students
where BirthDate > ANY (select HireDate from Teachers)

-- показати студентів з ім'ям яке має хоча б одни студент іншої групи
select Name, Email, GroupId
from Students
where Name = ANY (select s.Name
				  from Students as s
				  where s.GroupId <> Students.GroupId)

select * from Students
order by Name

-- показати студентів в яких оцінка більша за оцінки всіх студентів групи 'New-York'
select s.Name, s.Email, s.AverageMark, g.Name
from Groups as g JOIN Students as s ON s.GroupId = g.Id 
where AverageMark > ALL (select AverageMark
						 from Groups as g JOIN Students as s ON s.GroupId = g.Id
						 where g.Name = 'New-York' AND s.AverageMark IS NOT NULL)

update Students
set AverageMark -= 1
where GroupId = 3 AND AverageMark IS NOT NULL

-- показати викладачів які були прийняті на роботу раніше дати народження всіх їхніх студентів
select Name, Phone, HireDate
from Teachers
where HireDate < ALL (select s.BirthDate
					  from Students as s JOIN Groups as g ON s.GroupId = g.Id
										 JOIN TeachersGroups as tg ON tg.GroupId = g.Id
					  where tg.TeacherId = Teachers.Id)

-- показати викладачів в яких всі студенти отримують відмінні оцінки
select Name
from Teachers
where 10 <= ALL (select s.AverageMark
				 from Students as s JOIN Groups as g ON s.GroupId = g.Id
				 					JOIN TeachersGroups as tg ON tg.GroupId = g.Id
				 where tg.TeacherId = Teachers.Id)

insert into Teachers(Name, Phone)
values ('Maks', '55-44-55')

-- фільтруємо викладачів, які не мають жодного студента
select t.Name
from Teachers as t JOIN TeachersGroups as tg ON tg.TeacherId = t.Id
				   JOIN Groups as g ON tg.GroupId = g.Id
				   JOIN Students as s ON s.GroupId = g.Id	
group by t.Id, t.Name
having 10 <= ALL (select s.AverageMark
				 from Students as s JOIN Groups as g ON s.GroupId = g.Id
				 					JOIN TeachersGroups as tg ON tg.GroupId = g.Id
				 where tg.TeacherId = t.Id)

-- перевірка
select t.Name, s.AverageMark
from Teachers as t JOIN TeachersGroups as tg ON tg.TeacherId = t.Id
				   JOIN Groups as g ON tg.GroupId = g.Id
				   JOIN Students as s ON s.GroupId = g.Id				
order by t.Name

--------------- Hospital (Lab 7)
use Hospital;

-- Task 1: Вывести названия и вместимости палат, расположенных в 5-м корпусе,
-- вместимостью 5 и более мест, если в этом корпусе есть хотя бы одна палата вместимостью более 15 мест.
select w.Name, w.Places
from Wards as w JOIN Departments as d ON w.DepartmentId = d.Id
where d.Building = 5 AND w.Places >= 5 AND EXISTS (select *
												   from Wards as w2 JOIN Departments as d2 ON w2.DepartmentId = d2.Id
												   where w2.Places > 15 AND d2.Id = d.Id)

-- Task 2: Вывести названия отделений в которых проводилось хотя бы одно обследование за последнюю неделю.
select Name
from Departments
where EXISTS (select *
			  from Departments as d JOIN Wards as w ON w.DepartmentId = d.Id
									JOIN DoctorsExaminations as de ON de.WardId = w.Id
			  where DATEDIFF(day, de.Date, GETDATE()) <= 7 AND d.Id = Departments.Id)
-----------------------------
-- Inner Queries (Subqueries)

use University;
select * from Students;
select * from Groups;

-- запит, який повертає максимальну оцінку по всіх студентах
select MAX(AverageMark)
from Students

-- отримуємо всіх студентів, які мають максимальну оцінку
select Name, Email, AverageMark
from Students
where AverageMark = (select MAX(AverageMark) from Students) -- використання вкладеного запиту

-- отримуємо всі групи, які мають максимальну кі-сть студентів
select g.Name, AVG(s.AverageMark), COUNT(s.Id)
from Students as s JOIN Groups as g ON s.GroupId = g.Id
group by g.Name
having COUNT(s.Id) = (
						select top 1 COUNT(s.Id)
						from Students as s JOIN Groups as g ON s.GroupId = g.Id
						group by g.Name
						order by COUNT(s.Id) DESC
					 )

-- отримуємо всі групи, які мають максимальну або мінімальну кі-сть студентів
select g.Name, COUNT(s.Id)
from Students as s JOIN Groups as g ON s.GroupId = g.Id
group by g.Name
having COUNT(s.Id) = (
						select top 1 COUNT(s.Id)
						from Students as s JOIN Groups as g ON s.GroupId = g.Id
						group by g.Name
						order by COUNT(s.Id) DESC
					 )
					 OR
	   COUNT(s.Id) = (
						select top 1 COUNT(s.Id)
						from Students as s JOIN Groups as g ON s.GroupId = g.Id
						group by g.Name
						order by COUNT(s.Id)
					 )

-- якщо запит повертає декілька значень, для перевірки можна використати оператор IN
select Id, Name, BirthDate
from Students
where Id IN (select Id
			 from Students 
			 where Name like 'V%')


-- показати всіх викладачів, в яких більша половина студентів мають відмінні оцінки
select t.Id, t.Name [Teacher], AVG(s.AverageMark) as [Mark], COUNT(s.Id) as [Students]
from Teachers as t JOIN TeachersGroups as tg ON t.Id = tg.TeacherId
	JOIN Groups as g ON g.Id = tg.GroupId
	JOIN Students as s ON s.GroupId = g.Id
group by t.Name, t.Id
having COUNT(s.Id) / 2 < (
							select COUNT(s2.Id)
							from Teachers as t2 JOIN TeachersGroups as tg2 ON t2.Id = tg2.TeacherId
								JOIN Groups as g2 ON g2.Id = tg2.GroupId
								JOIN Students as s2 ON s2.GroupId = g2.Id
							where s2.AverageMark >= 10 AND t2.Id = t.Id
						 );


------------------------ Hospital (DZ)
use Hospital_lab_6;

-- Завдання 1: вывести названия отделений, что находятся в том же корпусе, что и отделение “Cardiology”
select Name
from Departments
where Building IN (select Building
				   from Departments
				   where Name = 'Cardiology')


select d.*
from Departments as d JOIN Donations as don ON don.DepartmentId = d.Id
where don.Amount = (select MIN(Amount) from Donations)
-- SQL Functions
use Hospital_lab_6;
go

-- Створити функцію, яка повертає к-сть докторів
create function get_doctors_count()
returns int
as
begin
	return (select COUNT(Id) from Doctors);
end;

-- тестуємо функцію через print
print dbo.get_doctors_count();
-- або через select
select 'Doctors Count', dbo.get_doctors_count();

-- Функція повертає суму донатів для відділення 
create function get_donations(@dep_name nvarchar(100))
returns money
as
begin
	return (select SUM(Amount)
			from Donations as d JOIN Departments as dep ON dep.Id = d.DepartmentId
			where dep.Name = @dep_name)
end;

print dbo.get_donations('Nephrology');

-- Функція повертає ім'я спонсора, який зробив найбільше донатів
create or alter function get_sponsor_name()
returns nvarchar(100)
as
begin
	return (select top 1 s.Name
			from Sponsors as s JOIN Donations as d ON d.SponsorId = s.Id
			group by s.Id, s.Name
			order by SUM(d.Amount) desc)
end;

print dbo.get_sponsor_name();

-- Функція повертає список обстежень певного доктора по імені та прізвищу
create function get_examinations(@doc_name nvarchar(100), @doc_surname nvarchar(100))
returns table
return (select e.*
		from Examinations as e JOIN DoctorsExaminations as de ON de.ExaminationId = e.Id
							   JOIN Doctors as d ON d.Id = de.DoctorId
		where d.Name = @doc_name AND d.Surname = @doc_surname);

select * from dbo.get_examinations('Etti', 'Burgis');
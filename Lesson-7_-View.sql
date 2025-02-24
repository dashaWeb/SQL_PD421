-- View (представлення) - це обєкт БД, який має зовнішній вигляд таблиці, але на відміну від неї не має своїх власних даних. Представлення лише надає доступ до даних однієї або декількох таблиць, на яких вона базаються

use UniversityPD_421
select* from Students
---- Create View
create view GoodStudents
as
select Name, Email, AverageMark as [Mark]
from Students
where AverageMark >= 10;

select* from GoodStudents

---- Alter View
alter view GoodStudents(FirstName, LastName, Email, Mark, Birthdate)
as
select Name, Surname, Email, AverageMark, Birthdate
from Students
where AverageMark >= 7

alter view GoodStudents(FullName, Email, Mark)
as
select Name + ' ' + Surname, Email, AverageMark
from Students
where AverageMark >= 7

select FullName, Mark
from GoodStudents
where FullName like '[A-D]%'

--- для view можна вказати деякі параметри
		-- encryption - view буде зберігатися у зашифрованому вигляді
		-- schemabinding - забороняє видалення таблиць, представлень та функцій які використовують дане view
		-- view_metadata - вказує на те, що view в режимі перегладу буде повертати його метадані, тобто інформацію про його структуру, а не записи

create or alter view GoodStudentsWithParams(FullName, EmailAddress, Mark)
with encryption
as
select Name + ' ' + Surname, Email, AverageMark 
from Students
where AverageMark >= 10
--order by AverageMark -- забороняється використовувати всередині view

select* from GoodStudentsWithParams
order by Mark -- дозволяється використовувати при роботі з view


create or alter view Top3GoodStudents(Name, Email,Mark)
as
select top 3 Name, Email, AverageMark
from Students
where AverageMark >= 10
order by AverageMark desc

select * from Top3GoodStudents
order by Name

---- Drop view
drop view Top3GoodStudents

create view StudentFullInfo(StudentName, Email, Mark, GroupName)
as
select s.Name, s.Email, s.AverageMark, g.Name
from Students as s join Groups as g on s.GroupId = g.Id

select* from StudentFullInfo

select* from GoodStudents
insert into GoodStudents
values ('Pasha', 'Demchuk', 'maks22@gmail.com', 9.5, '2000/03/02')

----- Variables

declare @find varchar(10) = '[D-R]%'

declare @var int, @a char(5)
select @var = 5, @a = 'Hello'

declare @var int
set @var = 5

declare @var int, @a char(5)
select @var = 5, @a = 'Hello'
select  'Value variables @var = ' + CONVERT(char(10), @var)

declare @MyTable table(Id int not null, number int);
insert @MyTable
select top 5 Id, Lessons
from Students

select Id, number
from @MyTable


Print 'Hello World'

declare @msg nvarchar(50)
set @msg = 'Today ' + cast(GETDATE() as nvarchar(30));
print @msg

if(DATENAME(dw,GetDate()) = 'Monday')
begin 
	print 'Today is Monday'
end
else
	print 'Today not Monday'

if(select Count(Id) from Students where AverageMark >= 10) > 10
	begin
		print 'Good'
	end

if exists (select* from Students where Birthdate between '2006/01/01' and CURRENT_TIMESTAMP)
begin 
	print 'Info about Students'
	select * from Students
	where Birthdate between '2006/01/01' and CURRENT_TIMESTAMP
end

select 'Student Name ' = Name, AverageMark = case 
										when GroupId is not null then AverageMark + 2
										when email is not null then AverageMark + 5
										end
from Students
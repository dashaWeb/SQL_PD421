use UniversityPD_421
select * from Students

/*
	Command: DDL (create, alter, drop), DML (insert, update, delete)
	Invokation time : After, Inserted of
*/

create trigger tg_notify_remove_st
on Students
after delete -- command
as
	print 'Student was deleted'

-- test 
delete from Students
where Id in (10,20)

create table Archive
(
	Id int identity primary key,
	Message nvarchar(100) not null,
	Date datetime default(getdate()) not null
)

select * from Archive

/*
tables in triggers
[inserted] 
[deleted]
*/

create or alter trigger tg_new_st_record
on Students
after insert
as
	insert into Archive(Message)
		select 'Students ' + Name + ' ' + Surname + ' was registered'
		from inserted

insert into Students (Name, Surname, Email, Birthdate, AverageMark)
values
	('Vika','Lublin','vika@gmail.com','2000/4/10',10),
	('Taras','Demchuk','taras@gmail.com','1998/5/20',12)

create or alter trigger tg_archive_delete_st
on Students
after delete
as
	insert into Archive(Message)
		select 'Students ' + Name + ' ' + Surname + ' was deleted'
		from deleted

delete from Students
where Id in (2,3)

create or alter trigger tg_archive_update_st
on Students
after update
as
	insert into Archive(Message)
	select 'Students ' + i.Name + ' changed avg mark from ' + cast(d.AverageMark as varchar) + ' to ' + cast(i.AverageMark as varchar)
	from inserted as i join deleted as d on i.Id = d.Id

update Students
set AverageMark -= 1.8
where Id in (4,5)

create or alter trigger tg_deny_st
on Students
after insert
as
	if exists (select Id
				from inserted
				where DATEDIFF(YEAR, Birthdate, GETDATE()) < 7)
	begin
		raiserror('Deny insert young students',12,1)
		rollback transaction; 
	end;

insert into Students(Name, Surname, Email, Birthdate, AverageMark)
values
	('Danil', 'Bondar', 'qwer@gmail.com','2024/04/12',11),
	('Valera','Nemkovich','valera@gmail.com','1987/7/15',9)

create or alter trigger tg_deny_overflow_group
on Students
after insert
as
	if exists(select Id 
				from inserted
				where (select Count(s.Id)
						from Students as s --join Groups as g on s.GroupId = g.Id
						where s.GroupId = inserted.GroupId) > 10)
				begin
					raiserror('Deny overflow group!',12,1)
					rollback
				end

select g.Name, COUNT(s.Id)
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name

insert into Students(Name, Surname, Email, Birthdate, AverageMark, GroupId)
values
	('Pasha','PPPP', 'pasha222@gmail.com','2000/2/2',10,1),
	('Oleg','OOOOO', 'oleg222@gmail.com','2000/2/2',11,2)

create trigger tg_deny_modify_st
on Students
after update, delete
as
	begin
		raiserror('Cannot modify oe delete students',15,1)
		rollback
	end

-- check
delete from Students
where Id = 4

update Students
set AverageMark = 10
where Id=6

-- disable/enable
disable trigger tg_deny_modify_st on Students
enable trigger tg_deny_modify_st on Students

create trigger tg_deny_old_st
on Students
instead of insert
as
	insert into Students
		select Name,Surname,Email,Birthdate,AverageMark,Lessons,Fails,GroupId from inserted
		where DATEDIFF(year, Birthdate, GETDATE()) < 55
	insert into Archive(Message)
		select 'Student ' + Name + ' was ignored. Age must be < 55'
		from inserted
		where DATEDIFF(year, Birthdate, GETDATE()) >= 55

insert into Students (Name,Surname,Email,Birthdate,AverageMark)
values
	('Katrin','HHH','kat@gmail.com','1950/2/2',8),
	('Olia','HHH','olia@gmail.com','1998/2/2',8)

create trigger tg_deny_dublicate_group
on Groups
after insert,update
as
	if exists (select i.Id
				from inserted as i, Groups as g
				where g.Name = i.Name and g.Id <> i.Id)
	begin
		raiserror('Deny insert group with existing name',12,1)
		rollback
	end

insert into Groups
values ('New-York'),
		('Rivne')

select * from Groups

update Groups
set Name = 'Ukraine'
where Name = 'New-York'


--=-=-=-=-=-=-=-=-=-=-- Stored Procedures


/*	create proc[edure] name
	@param1 type,
	@param2 type
	as
		code...
*/
create procedure greeting
@username nvarchar(50)
as
	print 'Hello, dear ' + @username


-- invoke procedure: exec[ute] name parameter1, parameter2
execute greeting 'Denis'

-- процедура видаляє студента по email
select* from Students
create proc del__student
@email nvarchar(50)
as
	delete from Students
	where Email = @email
-- invoke procedure
exec del__student 'ffelstead4@opera.com'

-- процедура змінює оцінку для студента по email
create proc set__mark
@email nvarchar(50),
@new_mark real
as
	update Students
	set AverageMark = @new_mark
	where Email = @email
-- invoke procedure
exec set__mark 'jcaulder5@edublogs.org', 11.9

-- процедура повертає середню оцінку студентів групи по імені
create proc get_student_avg_mark
@group_name nvarchar(50),
@avg_mark real output
as
	select @avg_mark = AVG(AverageMark)
		from Students as s join Groups as g on s.GroupId = g.Id
		where g.Name = @group_name
	set @avg_mark = ROUND(@avg_mark,1)

-- invoke procedure with OUTPUT parameters
select * from Groups
declare @result real;
exec get_student_avg_mark 'New-York', @result output
print @result

-- процедура повертає дату народження найстаршого та наймолодшого студента
create proc get__max__min_date
@max_date date output,
@min_date date output
as
	select @max_date = Max(Birthdate), @min_date = Min(Birthdate)
	from Students


-- invoke procedure
declare @date_max date, @date_min date
exec get__max__min_date @date_max output, @date_min output
select @date_max as 'The oldest Student Birthdate', @date_min as 'The Youngest Student'


----------------------------
-- процедура, яка повертає студентів які мають середній бал в переданому діапазоні
create proc sp_students_by_mark
@mark_from int,
@mark_to int = @mark_from
as
	select Name + ' ' + Surname as [Full Name], Email, AverageMark
	from Students
	where AverageMark between @mark_from and @mark_to
	order by AverageMark desc

exec sp_students_by_mark 7,8
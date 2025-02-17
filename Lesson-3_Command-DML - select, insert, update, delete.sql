
use ITStepAcademy




/*
	select що саме
	from звідки
	додаткові параметри запиту (сортування, фільтрація)

	select колонка1, колонка2
	from таблиця1, таблиця 2
	where умова фільтрації
	order by ключ сортування
*/
-- * визначає всі колонки
select * from Students

select [Name], Surname, AverageMark
from Students

-- as - псевдонім для колонки або таблиці

select [Name] + ' ' + Surname as 'Full Name', AverageMark * 100 as Mark
from Students

-- Cast, Convert - функції перетворення типів 
select 'Student ' + Surname + ' has ' + Cast(AverageMark as nvarchar)
from Students

select 'Student ' + Surname + ' has ' + CONVERT(nvarchar, AverageMark)
from Students

-- Top(count) - читає певну кількість елементів
select TOP 10 [Name] + ' ' + Surname as 'Full Name', AverageMark * 100 as Mark
from Students

-- PERCENT(count) - читає певну відносну кількість елементів
select top 50 PERCENT [Name] + ' ' + Surname as 'Full Name', AverageMark * 100 as Mark
from Students

-- DISTINCT - фільтрує дублікати
select DISTINCT IsDebtor, Name
from Students

-- логічні оператори : > < >= <= = <>(!= C#) !< !>
-- логічне і  (&&)  : AND  
-- логічне або (||) : OR

/* Функції для отримання значення дати 
		YEAR(date)
		MONTH(date)
		Day(date)
*/

select *
from Students
where MONTH(Birthdate) >= 6 and MONTH(Birthdate) <= 8

select *
from Students
where MONTH(Birthdate) between 6 and 8

select *
from Students
where YEAR(Birthdate) = 2002 or YEAR(Birthdate) = 2017 or YEAR(Birthdate) = 2015

select *
from Students
where YEAR(Birthdate) in (2002,2017,2015)

select *
from Students
where MONTH(Birthdate) in (1,2,12) and AverageMark >= 5

/******** [value] LIKE 'pattern' - перевіряє значення [value] на відповідність шаблону
	%	- будь-яка кількість символів
	_	- будь-який один символ
	[]	- будь-який символ, який наявний в дужках
	[^]	- будь-який символ, який НЕ наявний в дужках
*/

select* 
from Students
where Name like 'A%a'

select* 
from Students
where Email like '%@gmail.com'

select* 
from Students
where Name like '%a_'

select* 
from Students
where Name like '[aoiueAOIUE]%'

select* 
from Students
where Name COLLATE Latin1_General_BIN like '[A-D]%'

select* 
from Students
where Name like '[^AO]%'

select* 
from Students
where Name like '[^aoiueyAOIUE]%[aoiueyAOIUE]'

-- ORDER BY
-- ASC | DESC
select * 
from Students
where AverageMark >= 5
order by AverageMark ASC

select Name
from Students
order by Name DESC

-- UPDATE 
/*
update name_table
set column1 = value1
	column2 = value2
where condition
*/

update Students
set AverageMark += 1
where AverageMark between 5 and 11

--DELETE
/*
delete from table_name
where condition
*/

delete from Students
where Name = 'Ariana'

delete from Students
where IsDebtor = 1


--select g.Name
--from Students, Groups as g

select s.Name, s.Surname
from Students as s

-- отримати к-сть пісень кожного стилю
select st.Name, COUNT(s.Id)
from Songs as s JOIN MusicDiscs as md ON md.Id = s.MusicDiscId
				JOIN Styles as st ON md.StyleId = st.Id
group by st.Name
having COUNT(s.Id) > 1 -- лише ті стилі, які мають більше 1-ї пісні

-- к-сть дисків та найстаріший диск кожного виконавця
select p.Name, COUNT(md.Id), MIN(md.ReleaseDate) 'Oldest'
from Performers as p JOIN MusicDiscs as md ON md.PerformerId = p.Id
group by p.Id, p.Name

-- диск який містить пісню з найменшою тривалістю
select top 1 md.Name, MIN(s.Duration) as 'Shortest'
from Songs as s JOIN MusicDiscs as md ON s.MusicDiscId = md.Id
group by md.Id, md.Name
order by 'Shortest'--MIN(s.Duration) asc

-- -=-=-=-=-=-=-=-=- Subqueries -=-=-=-=-=-=-=-=-
-- диски з найновішою піснею
declare @latest date = (select MAX(ReleaseDate) from MusicDiscs)

select Name
from MusicDiscs 
where ReleaseDate = (select MAX(ReleaseDate) from MusicDiscs)

-- виконавці які не містять жодного диска в стилі 'White...'
select p.Id, p.Name
from Performers as p
where not exists (  select d.Id
					from MusicDiscs as d JOIN Styles as s ON d.StyleId = s.Id
					where PerformerId = p.Id AND s.Name = 'White-fronted bee-eater'
			     );

-- Test: PerformerId = 5
select COUNT(d.Id)
from MusicDiscs as d JOIN Styles as s ON d.StyleId = s.Id
where PerformerId = 5 AND s.Name = 'White-fronted bee-eater'

select * from Styles -- White-fronted bee-eater

-- всі диски які містять пісню з найменшою тривалістю
--declare @min int;

--select top 1 @min = COUNT(s.Id)
--from Songs as s JOIN MusicDiscs as md ON md.Id = s.MusicDiscId
--group by md.Id
--order by COUNT(s.Id) asc

select md.Name, COUNT(s.Id)
from Songs as s JOIN MusicDiscs as md ON md.Id = s.MusicDiscId
group by md.Id, md.Name
having COUNT(s.Id) = (
						select top 1 COUNT(s.Id)
						from Songs as s JOIN MusicDiscs as md ON md.Id = s.MusicDiscId
						group by md.Id
						order by COUNT(s.Id) asc
					 );
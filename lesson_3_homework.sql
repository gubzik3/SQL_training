--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. 
--Вывести: класс и число потопленных кораблей.
select class, 
	   count(*) as "Количество потопленных кораблей"
	FROM ships s
	left join outcomes o on s."name" = o.ship 
	where o."result" = 'sunk'
	group by class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. 
--Вывести: класс, год.
select class,
	   min(launched)
	from ships s 
	group by class


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, 
--вывести имя класса и число потопленных кораблей.
with t1 as (
	select class 
	from ships 
	group by class 
	having count(*) >= 3
),
t2 as (
	select class, count(*) as sunk
	from outcomes o 
	left join ships s on o.ship = s."name" 
	where result = 'sunk' and class is not null
	group by class
)

select t1.class, t2.sunk 
	from t1
	join t2 on t1.class = t2.class

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей 
--такого же водоизмещения (учесть корабли из таблицы Outcomes).
with t1 as (
	select name,
		   numguns,
		   displacement
		from ships s
		left join classes c on s.class = c.class
	union 
	select ship,
		   numguns,
		   displacement
		from outcomes o 
		join classes c2 on o.ship = c2.class
),
t2 as (
	select max(numguns) as numguns, displacement
		from t1
		group by displacement
)
select name
from t1
left join t2 on t1.numguns = t2.numguns and t1.displacement = t2.displacement
where t2.numguns is not null



--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом 
--RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

	
select maker 
	from product
	where type='Printer'
intersect
	select maker 
	from product
	where type='PC' and model in (select model from PC order by ram, speed desc limit 1)







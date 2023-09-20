--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3

select *, 
case when rn % 2 = 0 then rn / 2 else rn / 2 + 1 end  as page_num, 
case when rn % 2 = 0 then 2 else 1 end as position
from (
  select *, row_number(*) over (order by price desc) as rn
  from laptop 
) a

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)
create view distribution_by_type as
select maker, 
	   type, 
	   count(*) * 100.0 / (select count(*) from product) as percent
	from product
	group by maker, type
	order by maker


--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
create table ships_two_words as
select *
	from ships
	where name like '% %'
	order by name

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
select *
	from ships
	where class is null 
	and name like 'S%'

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model
select pr.model
	from product p
	join printer pr on p.model = pr.model
	where maker = 'A'
		  and price > (
					   select avg(price) 
					   	from product p
					   	join printer pron p.model = pr.model
						where maker = 'D'
						) 
union all
select model
from 
	(
	select p.model, row_number(*) over(partition by p.type order by price desc) as money
		from product p
		join printer pr
		on p.model = pr.model
	) a
	where money <= 3)
	
	
	
	
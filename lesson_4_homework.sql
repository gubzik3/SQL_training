--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
SELECT model, maker, TYPE FROM product

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
select *,
	   case when price > (select avg(price) from pc) then 1 else 0 
	   end as "additional conditions"
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select name 
	from ships 
	where class is null
	
--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
with t1 as(
	select name, date_part('year', date) as date 
	from battles
)
select name 
	from t1
	where date not in (select distinct launched from ships)
	
--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select name from ships where class = 'Kongo'
intersect 
select ship from outcomes
	
--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag
create view all_products_flag_300 as
with t1 as (
	select model, price from pc
union all
	select model, price from printer
union all
	select model, price from laptop
)
select * 
	 ,case when price > 300 then 1 else 0 
	  end as "flag"
	from t1;

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag
create view all_products_flag_avg_price as
with t1 as (
	select model, price from pc
union all
	select model, price from printer
union all
	select model, price from laptop
)
select * 
	 ,case when price > (select avg(price) from t1) then 1 else 0 
	  end as "flag"
	from t1;

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with t1 as (
select p.*
	  ,p2.maker
	from printer p 
	left join product p2 on p.model = p2.model 
)
select model 
	from t1 
	where maker = 'A' 
		and price > (select avg(price) from t1 where maker in('D', 'C'))

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
with t1 as (
	select model, price from pc
union all
	select model, price from printer
union all
	select model, price from laptop
),
t2 as (
select distinct * 
	from t1
	left join product p on t1.model = p.model
	where maker = 'A'
)
select avg(price) from t2

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
create view count_products_by_makers as
with t1 as (
	select model, price from pc
union all
	select model, price from printer
union all
	select model, price from laptop
)
select maker, count(*)
	from t1
	left join product p on t1.model = p.model
	group by maker;

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
--https://colab.research.google.com/drive/10NcEUmLIG-Im-gufPd3S68nHT-hsAPyK?usp=sharing

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
select p1.*
	into printer_updated
	from printer p1
	left join product p on p1.model = p.model 
	where maker != 'D'

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
create view printer_updated_with_makers as
select pu.*, p.maker
	from printer_updated pu
	left join product p on pu.model = p.model;

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
create view sunk_ships_by_classes as
with t1 as (
select class, count(*) 
	from outcomes o 
	left join ships s on o.ship = s."name" 
	where result = 'sunk' and class is not null
	group by class
	union 
select class, count(*)
	from outcomes o 
	left join classes s on o.ship = s.class 
	where result = 'sunk' and class is not null
	group by class
)
select c.class,
	   case when count is null then 0 else count end count
	from classes c
	left join t1 on c."class" = t1.class;

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
--https://colab.research.google.com/drive/10NcEUmLIG-Im-gufPd3S68nHT-hsAPyK?usp=sharing

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0
select *
	  ,case when numguns >= 9 then 1 else 0 
	   end "flag"
	into classes_with_flag
	from classes
	
--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)
--https://colab.research.google.com/drive/10NcEUmLIG-Im-gufPd3S68nHT-hsAPyK?usp=sharing
	
--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select count(*)
	from ships s 
	where "name" like 'O%' or "name" like 'M%'
union
select count(*)
	from outcomes s 
	where ship like 'O%' or ship like 'M%'	
--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select count(*)
	from ships s 
	where "name" like '% %' and "name" not like '% % %'
union all
select count(*)
	from outcomes s 
	where ship like '% %' and ship not like '% % %'
--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)


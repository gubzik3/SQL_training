--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
with agg as (
select DepartmentId, Name, Salary, dense_rank() over (partition by DepartmentId order by Salary desc) as rank
from Employee)

select d.Name as "Department", a.Name as "Employee", a.Salary as "Salary"
from agg a 
join Department d on a.DepartmentId = d.Id
where a.rank < 4

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
SELECT fm.member_name, fm.status, SUM(p.amount*p.unit_price) as costs
FROM FamilyMembers as fm
JOIN Payments as p ON p.family_member = fm.member_id
WHERE YEAR(p.date) = 2005
GROUP BY fm.member_id, fm.member_name, fm.status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select name from passenger GROUP BY name HAVING  COUNT(name) > 1;

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select COUNT(first_name) as Count
from student 
where first_name ='Anna';

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
SELECT DISTINCT COUNT(classroom) AS count FROM Schedule WHERE date LIKE '2019-09-02%';

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select COUNT(first_name) as Count
from student 
where first_name ='Anna';

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
SELECT FLOOR(AVG(FLOOR(DATEDIFF(NOW(), birthday)/365))) AS age FROM FamilyMembers;

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
SELECT good_type_name, SUM(amount*unit_price) AS costs 
FROM GoodTypes 
JOIN Goods ON good_type_id = type 
JOIN Payments ON good = good_id AND YEAR(date) = 2005 
GROUP BY good_type_name;

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
SELECT FLOOR(MIN(DATEDIFF(NOW(), birthday)/365)) AS year FROM Student;

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
SELECT FLOOR(MAX((DATEDIFF(NOW(), birthday)/365))) AS max_year 
FROM Student 
JOIN Student_in_class ON Student.id=Student_in_class.student 
JOIN Class ON Class.id=Student_in_class.class 
WHERE Class.name LIKE '10%';

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
SELECT status, member_name, SUM(unit_price*amount) AS costs 
FROM FamilyMembers AS fm 
JOIN Payments AS p ON fm.member_id = p.family_member 
JOIN Goods AS g ON p.good = g.good_id 
JOIN GoodTypes as gp ON g.type = gp.good_type_id 
WHERE good_type_name = 'entertainment' 
GROUP BY family_member;

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
SELECT name, COUNT(company) as company 
FROM Trip 
JOIN Company ON Company.id=Trip.company 
GROUP BY name; 
DELETE FROM Company WHERE id in (2,3,4);

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
SELECT classroom 
FROM Schedule
GROUP BY classroom 
HAVING COUNT(classroom) = (SELECT COUNT(classroom)
FROM Schedule
GROUP BY classroom 
ORDER BY COUNT(classroom) DESC
LIMIT 1)

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
select last_name 
from teacher 
join Schedule
    on teacher.id=Schedule.teacher 
join subject 
    on Schedule.subject=subject.id
where subject.name='Physical Culture'
order by teacher.last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
SELECT CONCAT(last_name, '.', LEFT(first_name, 1), '.', LEFT(middle_name, 1), '.') AS name 
FROM Student 
ORDER BY last_name, first_name ASC;

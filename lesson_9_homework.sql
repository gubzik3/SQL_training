--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
SELECT CASE WHEN (STUDENTS.MARKS < 70) THEN 'NULL' ELSE STUDENTS.NAME END,
        GRADES.GRADE, STUDENTS.MARKS
FROM STUDENTS, GRADES
WHERE STUDENTS.MARKS BETWEEN GRADES.MIN_MARK AND GRADES.MAX_MARK
ORDER BY GRADES.GRADE DESC, STUDENTS.NAME ASC;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem
select doc,prof,singer,act
from ( select row_number() over(partition by Occupation order by Name) ron,Name as n,Occupation as o
from OCCUPATIONS ) pro
pivot
(max(n)
 for o in ('Doctor' as doc,'Actor' as act,'Professor' as prof,'Singer' as singer))
 order by ron asc;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct city from station where city not like '[aeiouAEIOU]%';

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
SELECT DISTINCT city
FROM station
WHERE regexp_like (city, '.*[^aeiouAEIOU]$');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
SELECT DISTINCT city
FROM station
WHERE regexp_like (city, '^[^aeiouAEIOU].*') 
OR regexp_like (city, '.*[^aeiouAEIOU]$');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem
SELECT DISTINCT city
FROM station
WHERE regexp_like (city, '^[^aeiouAEIOU].*') 
and regexp_like (city, '.*[^aeiouAEIOU]$');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
SELECT name FROM Employee WHERE Salary > 2000 AND months < 10 ORDER BY employee_id ASC;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
SELECT CASE WHEN (STUDENTS.MARKS < 70) THEN 'NULL' ELSE STUDENTS.NAME END,
        GRADES.GRADE, STUDENTS.MARKS
FROM STUDENTS, GRADES
WHERE STUDENTS.MARKS >= GRADES.MIN_MARK AND STUDENTS.MARKS <= GRADES.MAX_MARK
ORDER BY GRADES.GRADE DESC, STUDENTS.NAME ASC;

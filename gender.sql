use project;

SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN   ï»¿id emp_id VARCHAR(20);

describe hr;

select birthdate FROM hr;

SET sql_safe_updates=0;

UPDATE hr

SET birthdate=CASE
  WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,"%m/%d/%Y"),'%Y-%m-%d') 
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,"%m-%d-%Y"),'%Y-%m-%d') 
  ELSE NULL
  END;
  
  ALTER TABLE hr
  MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date=CASE
  WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,"%m/%d/%Y"),'%Y-%m-%d') 
  WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,"%m-%d-%Y"),'%Y-%m-%d') 
  ELSE NULL
  END;
  
  
#converting of string to date format of the following termdate

UPDATE hr
SET termdate=date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
   WHERE termdate IS NOT NULL AND termdate!='';
--    SET termdate = IF(termdate = '',0000-00-00, str_to_date(termdate, "%Y-%m-%d %H:%i:%s UTC"))
--    WHERE termdate IS NOT NULL;   
ALTER table hr
MODIFY COLUMN termdate DATE;
          
     SELECT termdate FROM hr; 
     
    #creating a new column named age in hr 
     ALTER TABLE hr ADD COLUMN age INT;
   
   #givng value add with using difference function which genrate age 
  UPDATE hr
  SET age=timestampdiff(YEAR,birthdate,CURDATE());
  
  
SELECT 
  min(age) AS youngest,
  max(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age<18;
  SELECT birthdate,age from hr;
  
  
  
  -- Q1 What is the gender breakdown of employes in the company
  
  SELECT gender,count(*) AS count
  FROM hr
  WHERE age>=18 
  GROUP BY gender;
  
  
  #Race ethinicty breakdown of employe in the company
  
  SELECT race,COUNT(*) AS count
  FROM hr
  WHERE age>=18 
  GROUP BY race
  ORDER BY COUNT(*)DESC;  -- REPRESETING EACH --
  
  
  #WHAT IS THE AGE DISTRIBUTION OF EMPLOYES IN THE COMPANY
  SELECT
  min(age) AS youngest,
  max(age) AS oldest
  FROM hr
  WHERE age>=18 ;
  
 SELECT 
    CASE
	   WHEN age>=18 AND age<=24 THEN '18-24'
	   WHEN age>=25 AND age<=34 THEN '25-34'
	   WHEN age>=35 AND age<=44 THEN  '35-44'
	   WHEN age>=45 AND age<=54 THEN '45-54'
       WHEN age>=55 AND age<=66 THEN '55-64'
	   ELSE '65+'
	 END AS age_group,gender,
     count(*)AS count
		
	  FROM hr
      WHERE age>=18 
      GROUP BY age_group,gender
      ORDER BY age_group,gender;
     
     #how many employess work at headquaters versus remote locations
     
     SELECT location, count(*) AS count
     FROM hr
     WHERE age>=18
     GROUP BY location;
     
     #5.)What is the average length of employment for employees who been terminated
     
     SELECT
      round(avg(datediff(termdate,hire_date))/365,0) AS avg_length_employment
      FROM hr
      WHERE termdate<=curdate() AND age>=18;
      
-- 6 How does the gender distribution vary across departments and job titles?
SELECT department,gender,COUNT(*) AS  count
FROM hr
WHERE age>=18 
GROUP BY department,gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT  jobtitle,count(*) AS count
FROM hr
WHERE age>=18 
GROUP BY jobtitle
ORDER BY jobtitle DESC ; -- sorting out the following


-- 8 Which department has the highest turn over rate?

SELECT department,total_count,terminated_count,
terminated_count/total_count AS termination_rate

FROM (
   SELECT department,
   count(*) AS total_count,
   SUM(CASE WHEN termdate<=curdate() THEN 1 ELSE 0 END) AS terminated_count
   FROM hr 
   WHERE age>=18 
   GROUP BY department
   )AS subquery 
   ORDER BY termination_rate DESC;
     
     
     
-- 9 What is the distribution of employes across locatoin by city and statet-- 
 SELECT location_state, count(*) AS count
 FROM hr
 WHERE age>=18 
 GROUP BY location_state
 ORDER BY count DESC;
 
 # company changes after employe joined
 SELECT 
  year,
  hires,
  terminations,
  hires -terminations AS net_change, 
  round((hires-terminations)/hires*100,2) AS net_change_percent
  
FROM(
 SELECT 
    YEAR(hire_date)AS year,
    count(*) AS hires,
    SUM(CASE WHEN termdate<=curdate() THEN 1 ELSE 0 END ) AS terminations
    FROM hr
    WHERE age>=18	
    GROUP BY YEAR(hire_date)
    ) AS subquery
  ORDER BY year ASC;  
  
  
  #What is the tenure distribution of each department

 SELECT department,
 round(avg(datediff(termdate,hire_date))/365,0) AS avg_tenure
 FROM hr
 WHERE termdate<=curdate() AND age>=18
 GROUP BY department
 
 
      


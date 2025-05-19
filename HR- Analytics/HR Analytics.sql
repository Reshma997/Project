Create Database PRT_JAN
 use PRT_JAN

 select * from hr_and_payroll_dataset_cheat_resistant

--1.A company is concerned that some departments are taking too long to hire employees. 
--They suspect this might affect salary allocation. They want a report showing average salaries and bonus percentages for departments that generally hire faster than others.
--Departments hiring slower than 40 days should be excluded.
 create view Reports as 
 (select avg(salary)as average_salary,avg(bonus_pct)as average_bonus,depart_ment from hr_and_payroll_dataset_cheat_resistant where time2hire_dayz>40 group by depart_ment)
 
 select * from dbo.Reports

--2) The HR department wants to create a system where job titles can be represented by a unique code derived from the job titles themselves. They have requested a report showing a shortened version (first three letters) of each job title. Additionally, only employees earning above their department’s average salary should be included.
  select SUBSTRING(job_t1tle,1,3) as job_code,job_t1tle,depart_ment,empl0yee_id,salary from hr_and_payroll_dataset_cheat_resistant a where salary > (select Avg(salary)from hr_and_payroll_dataset_cheat_resistant b where b.depart_ment=a.depart_ment group by depart_ment)

--3) Some employees’ leave balances are missing, and the company wants to know how big the issue is in each department. Can you find out how many employees in each department have no recorded leave balance? Also, the HR team is curious about the roles of these employees.

select job_t1tle,depart_ment,count(empl0yee_id)as missing from hr_and_payroll_dataset_cheat_resistant where leave_bal_days is null group by depart_ment,job_t1tle

--4) Employees who haven’t received a salary bump in the last two years might need attention. Similarly, they want to know how long it’s been since each employee’s last performance review. The goal is to identify employees potentially overdue for an appraisal. 

select empl0yee_id ,last_salary_bump,last_perf_review, (year(current_timestamp)-year(last_perf_review)) as delayed_review from hr_and_payroll_dataset_cheat_resistant where (year(current_timestamp)-year(last_salary_bump))>2
select empl0yee_id ,last_salary_bump,last_perf_review, (year(current_timestamp)-year(last_perf_review)) as reviewed_duartion from  hr_and_payroll_dataset_cheat_resistant

--5) Management wants to reward the highest-paid employees in departments that contribute significantly to the payroll. For each department with a total payroll above $500,000, find the top 3 earners and include their details.

select Top 3 * from hr_and_payroll_dataset_cheat_resistant  where salary in (select max(salary) from hr_and_payroll_dataset_cheat_resistant group by depart_ment having avg(salary)>50000)

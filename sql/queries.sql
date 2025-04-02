-- 1. How many employees work outside of the US?
    select count(employee_id)
    from hr.employees
    where department_id not in (
    	select department_id
    	from hr.departments
    	where location_id in (
    		select location_id
    		from hr.locations
    		where country_id in ('US')
    	)
	)
	;
    
    
    -- 2. Who is getting the highest commission?
    select last_name, first_name
    from hr.employees
    where commission_pct in (select max(commission_pct) from hr.employees)
    ;
    

    -- dalsi zpusob by mohlo byt treba seradit zestupne dle commission_pct
    -- a vratit nejvyssi (limit, top 1) zaznam
    select top 1 last_name, first_name
    from hr.employees
    order by commission_pct desc

    
    -- 3. Get list of employees hired between 2004 and 2006.
    select *
    from hr.employees
    where hire_date between '2004-01-01' and '2006-12-31'
    ;
    
    
    -- 4. Find number of employees and total and average salary for each job_id.
    select count(employee_id), sum(salary), avg(salary) 
    from hr.employees
    group by job_id
    ;

    -- 5. Create list of employees – first name, last name, job title – and their manager’s fist name and last name.
    select e.first_name, 
    	   e.last_name,
    	   j.job_title,
    	   m.first_name,
    	   m.last_name
    from hr.employees e
    join hr.jobs j on j.job_id = e.job_id
    join hr.employees m on e.employee_id = m.manager_id
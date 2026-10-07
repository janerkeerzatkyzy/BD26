CREATE TABLE employees (
 employee_id SERIAL PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 department VARCHAR(50),
 salary NUMERIC(10,2),
 hire_date DATE,
 manager_id INTEGER,
 email VARCHAR(100)
);

CREATE TABLE projects (
 project_id SERIAL PRIMARY KEY,
 project_name VARCHAR(100),
 budget NUMERIC(12,2),
 start_date DATE,
 end_date DATE,
 status VARCHAR(20)
);

CREATE TABLE assignments (
 assignment_id SERIAL PRIMARY KEY,
 employee_id INTEGER REFERENCES employees(employee_id),
 project_id INTEGER REFERENCES projects(project_id),
 hours_worked NUMERIC(5,1),
 assignment_date DATE
);

-- Insert sample data
INSERT INTO employees (first_name, last_name, department,
salary, hire_date, manager_id, email) VALUES
('John', 'Smith', 'IT', 75000, '2020-01-15', NULL,
'john.smith@company.com'),
('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1,
'sarah.j@company.com'),
('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL,
'mbrown@company.com'),
('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL,
'emily.davis@company.com'),
('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,
'lisa.a@company.com');
INSERT INTO projects (project_name, budget, start_date,
end_date, status) VALUES
('Website Redesign', 150000, '2024-01-01', '2024-06-30',
'Active'),
('CRM Implementation', 200000, '2024-02-15', '2024-12-31',
'Active'),
('Marketing Campaign', 80000, '2024-03-01', '2024-05-31',
'Completed'),
('Database Migration', 120000, '2024-01-10', NULL, 'Active');

INSERT INTO assignments (employee_id, project_id,
hours_worked, assignment_date) VALUES
(1, 1, 120.5, '2024-01-15'),
(2, 1, 95.0, '2024-01-20'),
(1, 4, 80.0, '2024-02-01'),
(3, 3, 60.0, '2024-03-05'),
(5, 2, 110.0, '2024-02-20'),
(6, 3, 75.5, '2024-03-10');

-- Part 1: Basic SELECT Queries
-- task 1.1
SELECT first_name || ' ' || last_name AS full_name, department, salary  FROM employees;
-- task 1.2
SELECT DISTINCT department FROM employees;
-- task 1.3
SELECT project_name, budget,
CASE
WHEN budget > 150000 THEN 'Large'
WHEN budget BETWEEN 100000 AND 150000 THEN 'Medium'
ELSE 'Small'
END AS budget_category
FROM projects;
-- task 1.4
SELECT employees.first_name,
       COALESCE(email, 'No email provided')
FROM employees;
--Part 2: WHERE Clause and Comparison Operators
-- task 2.1
SELECT * FROM employees WHERE hire_date>01-01-2020;
-- task 2.2
SELECT * FROM employees WHERE salary BETWEEN 60000 AND 70000;
-- task 2.3
SELECT * FROM employees WHERE last_name LIKE 'S%' OR 'J%';
-- task 2.4
SELECT * FROM employees WHERE manager_id IS NOT NULL AND department = 'IT';
--Part 3: String and Mathematical Functions
-- task 3.1
SELECT
    UPPER(first_name) AS upper_mame,
    LENGTH(last_name) AS surenames_length,
    SUBSTRING(email, 1 , 3) AS substring
FROM employees;
-- task 3.2
SELECT
    salary AS annual_salary,
    (salary/12, 2) AS monthly_salary,
    salary * 0.10 AS raise_amount
FROM employees;
-- task 3.3
SELECT
    format('Project: %s Budget $%s Status: %s', project_name, budget, status)
FROM projects;
-- task 3.4
SELECT
    EXTRACT(YEAR FROM current_date)-EXTRACT(YEAR FROM hire_date) AS years_worked
FROM employees;
--Part 4: Aggregate Functions and GROUP BY
-- task 4.1
SELECT
    AVG(salary) AS avg_salary,
    department
FROM employees
GROUP BY department;
-- task 4.2
SELECT
    p.project_name, SUM(a.hours_worked) AS worked_hours,
FROM
    projects
JOIN assignments a on projects.project_id = a.project_id
GROUP BY p.project_name, p.project_id;
-- task 4.3
SELECT
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;
--task 4.4
SELECT
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary,
    SUM(salary) AS total_payroll
FROM employees;
-- Part 5: Set Operations
-- task 5.1
SELECT employee_id, first_name || ' ' || last_name AS full_name, salary
FROM employees
WHERE salary > 65000
UNION
SELECT employee_id, first_name || ' ' || last_name AS full_name, salary
FROM employees
WHERE hire_date > '2020-01-01';
-- task 5.2
SELECT employee_id, first_name || ' ' || last_name AS full_name, salary
FROM employees
WHERE department = 'IT'
INTERSECT
SELECT employee_id, first_name || ' ' || last_name AS full_name, salary
FROM employees
WHERE salary > 65000;
-- task 5.3
SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM employees
EXCEPT
SELECT employees.employee_id, employees.first_name || ' ' || employees.last_name AS full_name
FROM employees
JOIN assignments ON employees.employee_id = assignments.employee_id;
--Part 6: Subqueries
-- task 6.1
SELECT employees.employee_id, employees.last_name, employees.first_name
FROM employees
WHERE EXISTS(
    SELECT 1
    FROM assignments
    WHERE employees.employee_id = assignments.employee_id
);
-- task 6.2
SELECT *
FROM employees
WHERE employee_id IN (
    SELECT assignments.employee_id
    FROM assignments
    JOIN projects ON assignments.project_id = projects.project_id
    WHERE projects.status = 'Active'
);
-- task 6.3
SELECT *
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'Sales'
);
-- Part 7: Complex Queries
-- task 7.1
SELECT
    e.first_name || ' ' || e.last_name AS full_name,
    e.department,
    AVG(a.hours_worked) AS avg_hours_worked,
    DENSE_RANK() OVER (PARTITION BY e.department ORDER BY e.salary DESC) AS salary_rank
FROM employees e
LEFT JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.department, e.salary;
-- task 7.2
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours,
    COUNT(DISTINCT a.employee_id) AS assigned_employees_count
FROM projects p -- p это наш удобный алиас
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name
HAVING SUM(a.hours_worked) > 150;
-- task 7.3
WITH highest_paid AS (
    SELECT DISTINCT ON (department)
        department,
        first_name || ' ' || last_name AS highest_paid_employee
    FROM employees
    ORDER BY department, salary DESC, employee_id
)
SELECT
    e.department,
    COUNT(*) AS total_employees,
    AVG(e.salary) AS avg_salary, 
    hp.highest_paid_employee,
    GREATEST(ROUND(AVG(e.salary), 2), 50000) AS salary_floor_check, 
    LEAST(MAX(e.salary), 100000) AS capped_max_salary 
FROM employees e
JOIN highest_paid hp ON e.department = hp.department
GROUP BY e.department, hp.highest_paid_employee;
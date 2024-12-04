-- Data Engineering/Modeling ---------------------------------
-- I made the tables first then saved my code and imported it to QuickDBD 
-- I attached the png image in the EmployeeSQL folder 

-- Table for departments.csv
CREATE TABLE departments (
    dept_no VARCHAR(10) PRIMARY KEY,
    dept_name VARCHAR NOT NULL
);
select * from departments

-- Table for dept_emp.csv (linking departments to employees)
CREATE TABLE dept_emp (
    emp_no INTEGER,
    dept_no VARCHAR(10),
    PRIMARY KEY (emp_no, dept_no),  -- Composite primary key
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);
select * from dept_emp

-- Table for dept_manager.csv (linking managers to departments)
CREATE TABLE dept_manager (
    dept_no VARCHAR(10),
    emp_no INTEGER,
    PRIMARY KEY (dept_no, emp_no),  -- Composite primary key
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);
select * from dept_manager

-- Table for titles.csv
CREATE TABLE titles (
    title_id VARCHAR PRIMARY KEY,
    title VARCHAR NOT NULL
);
select * from titles 

-- Table for employees.csv
CREATE TABLE employees (
    emp_no INTEGER PRIMARY KEY,
    emp_title_id VARCHAR,
    birth_date DATE,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    sex VARCHAR NOT NULL,
    hire_date DATE,
    FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);
select * from employees

-- Table for salaries.csv
CREATE TABLE salaries (
    emp_no INTEGER PRIMARY KEY,
    salary INTEGER,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);
select * from salaries 

-- Data Analysis ------------------------------------------------------
-- 1.List the employee number, last name, first name, sex, and salary of each employee.
SELECT 
    employees.emp_no, 
    employees.last_name, 
    employees.first_name, 
    employees.sex, 
    salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no;

-- 2.List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT 
    first_name, 
    last_name, 
    hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

-- 3.List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT 
    dept_manager.dept_no, 
    departments.dept_name, 
    dept_manager.emp_no AS manager_emp_no, 
    employees.last_name, 
    employees.first_name
FROM dept_manager
JOIN departments ON dept_manager.dept_no = departments.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no;

-- 4.List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT 
    dept_emp.dept_no, 
    employees.emp_no, 
    employees.last_name, 
    employees.first_name, 
    departments.dept_name
FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no;

-- 5.List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT 
    first_name, 
    last_name, 
    sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6.List each employee in the Sales department, including their employee number, last name, and first name.
SELECT 
    employees.emp_no, 
    employees.last_name, 
    employees.first_name
FROM dept_emp
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN employees ON dept_emp.emp_no = employees.emp_no
WHERE departments.dept_name = 'Sales';

-- 7.List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT 
    employees.emp_no, 
    employees.last_name, 
    employees.first_name, 
    departments.dept_name
FROM dept_emp
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN employees ON dept_emp.emp_no = employees.emp_no
WHERE departments.dept_name IN ('Sales', 'Development');

-- 8.List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
SELECT 
    last_name, 
    COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;
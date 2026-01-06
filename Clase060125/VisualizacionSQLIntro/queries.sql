-- Query 1: Mostrar todos los empleados con el nombre de su departamento
SELECT 
    e.first_name,
    e.last_name,
    e.email,
    e.position,
    d.name AS department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
ORDER BY e.last_name, e.first_name;

-- Query 2: Calcular el salario promedio por departamento
SELECT 
    d.name AS department_name,
    COUNT(e.id) AS employee_count,
    ROUND(AVG(e.salary), 2) AS average_salary,
    ROUND(MAX(e.salary), 2) AS max_salary,
    ROUND(MIN(e.salary), 2) AS min_salary
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name
ORDER BY average_salary DESC;

-- Query 3: Mostrar empleados con salario superior al promedio de la empresa
SELECT 
    first_name,
    last_name,
    email,
    salary,
    position
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- Query 4: Mostrar proyectos activos con la cantidad de empleados asignados
SELECT 
    p.name AS project_name,
    p.status,
    p.budget,
    COUNT(pa.employee_id) AS assigned_employees,
    SUM(pa.hours_worked) AS total_hours_worked
FROM projects p
LEFT JOIN project_assignments pa ON p.id = pa.project_id
WHERE p.status = 'active'
GROUP BY p.id, p.name, p.status, p.budget
ORDER BY assigned_employees DESC;

-- Query 5: Mostrar los 3 empleados que más horas trabajan en proyectos
SELECT 
    e.first_name,
    e.last_name,
    e.position,
    COUNT(pa.id) AS project_count,
    SUM(pa.hours_worked) AS total_hours
FROM employees e
JOIN project_assignments pa ON e.id = pa.employee_id
GROUP BY e.id, e.first_name, e.last_name, e.position
ORDER BY total_hours DESC
LIMIT 3;

-- Query 6: Mostrar departamentos con su presupuesto y el gasto total en salarios
SELECT 
    d.name AS department_name,
    d.budget AS department_budget,
    COALESCE(SUM(e.salary), 0) AS total_salaries,
    d.budget - COALESCE(SUM(e.salary), 0) AS remaining_budget
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name, d.budget
ORDER BY remaining_budget DESC;

-- Query 7: Mostrar proyectos que vencen en los próximos 30 días
SELECT 
    p.name AS project_name,
    p.end_date,
    p.status,
    p.budget,
    d.name AS department_name,
    CASE 
        WHEN p.end_date < CURRENT_DATE THEN 'Vencido'
        WHEN p.end_date = CURRENT_DATE THEN 'Vence hoy'
        ELSE 'Activo'
    END AS status_label
FROM projects p
JOIN departments d ON p.department_id = d.id
WHERE p.end_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '30 days')
   OR p.end_date < CURRENT_DATE
ORDER BY p.end_date;

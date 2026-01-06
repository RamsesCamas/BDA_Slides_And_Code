-- Datos de prueba para el laboratorio de Base de Datos Avanzada

INSERT INTO departments (id, name, location, budget) VALUES
(1, 'Ingeniería de Software', 'Madrid', 500000.00),
(2, 'Recursos Humanos', 'Barcelona', 150000.00),
(3, 'Marketing', 'Valencia', 200000.00),
(4, 'Finanzas', 'Madrid', 300000.00),
(5, 'Investigación y Desarrollo', 'Bilbao', 750000.00);

INSERT INTO employees (id, first_name, last_name, email, department_id, hire_date, salary, position, is_active) VALUES
(1, 'Carlos', 'García', 'carlos.garcia@company.com', 1, '2020-03-15', 65000.00, 'Senior Developer', true),
(2, 'María', 'Rodríguez', 'maria.rodriguez@company.com', 1, '2019-07-20', 70000.00, 'Tech Lead', true),
(3, 'Juan', 'Martínez', 'juan.martinez@company.com', 1, '2021-01-10', 55000.00, 'Junior Developer', true),
(4, 'Ana', 'López', 'ana.lopez@company.com', 1, '2020-09-05', 60000.00, 'QA Engineer', true),
(5, 'Pedro', 'Sánchez', 'pedro.sanchez@company.com', 2, '2018-04-12', 45000.00, 'HR Specialist', true),
(6, 'Laura', 'Fernández', 'laura.fernandez@company.com', 2, '2019-11-30', 48000.00, 'Recruiter', true),
(7, 'Miguel', 'Gómez', 'miguel.gomez@company.com', 3, '2020-02-28', 52000.00, 'Marketing Manager', true),
(8, 'Carmen', 'Díaz', 'carmen.diaz@company.com', 3, '2021-06-15', 47000.00, 'Social Media Specialist', true),
(9, 'Roberto', 'Ruiz', 'roberto.ruiz@company.com', 4, '2017-08-22', 75000.00, 'Financial Analyst', true),
(10, 'Isabel', 'Morales', 'isabel.morales@company.com', 4, '2018-12-01', 68000.00, 'Accountant', true),
(11, 'Antonio', 'Ortega', 'antonio.ortega@company.com', 5, '2019-03-18', 80000.00, 'Research Scientist', true),
(12, 'Teresa', 'Castro', 'teresa.castro@company.com', 5, '2020-05-10', 77000.00, 'Data Scientist', true);

INSERT INTO projects (id, name, description, start_date, end_date, status, budget, department_id) VALUES
(1, 'Plataforma E-commerce', 'Desarrollo de plataforma de comercio electrónico', '2023-01-01', '2023-06-30', 'completed', 250000.00, 1),
(2, 'Sistema de Gestión RRHH', 'Actualización del sistema de gestión de recursos humanos', '2023-03-15', '2023-09-30', 'completed', 100000.00, 1),
(3, 'Campaña Navidad 2023', 'Campaña de marketing para temporada navideña', '2023-10-01', '2023-12-31', 'completed', 150000.00, 3),
(4, 'Dashboard Financiero', 'Desarrollo de dashboard de análisis financiero', '2023-07-01', '2024-01-31', 'active', 180000.00, 4),
(5, 'IA para Predicción de Ventas', 'Implementación de modelos de IA para predecir ventas', '2023-09-01', '2024-06-30', 'active', 350000.00, 5);

INSERT INTO project_assignments (employee_id, project_id, role, assigned_at, hours_worked) VALUES
(1, 1, 'Backend Developer', '2023-01-01', 480.00),
(2, 1, 'Project Lead', '2023-01-01', 120.00),
(3, 1, 'Junior Developer', '2023-02-01', 360.00),
(4, 1, 'QA Engineer', '2023-01-15', 240.00),
(1, 2, 'Backend Developer', '2023-03-15', 320.00),
(2, 2, 'Project Lead', '2023-03-15', 80.00),
(3, 2, 'Junior Developer', '2023-04-01', 280.00),
(7, 3, 'Campaign Manager', '2023-10-01', 200.00),
(8, 3, 'Content Creator', '2023-10-01', 350.00),
(9, 4, 'Financial Analyst', '2023-07-01', 280.00),
(10, 4, 'Data Analyst', '2023-07-15', 320.00),
(11, 5, 'Lead Scientist', '2023-09-01', 150.00),
(12, 5, 'Data Scientist', '2023-09-01', 400.00);

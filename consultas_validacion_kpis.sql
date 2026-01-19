/*
PROYECTO: Validación de Datos de Ventas (Retail)
AUTOR: Johnny Morales
FECHA: Enero 2026
DESCRIPCIÓN: Script para validar los KPIs calculados en el Dashboard de Excel.
*/

-- 1. CONSULTA DE KPIS PRINCIPALES (Ventas, Pedidos, Ticket Promedio)
-- Objetivo: Obtener el volumen total de negocio excluyendo órdenes canceladas.
SELECT 
    YEAR(orderdate) as Anio,
    SUM(sales) as Ventas_Totales,
    COUNT(DISTINCT ordernumber) as Total_Pedidos,
    (SUM(sales) / COUNT(DISTINCT ordernumber)) as Ticket_Promedio
FROM sales_data
WHERE status NOT IN ('Cancelled', 'Disputed') -- Excluímos cancelaciones para ver ingreso real
GROUP BY YEAR(orderdate)
ORDER BY Anio DESC;

-- 2. ANÁLISIS DE CANCELACIONES POR PAÍS (Causa Raíz)
-- Objetivo: Identificar qué regiones tienen problemas logísticos (Insight de España/Suecia).
SELECT 
    country as Pais,
    COUNT(ordernumber) as Cantidad_Cancelaciones,
    -- Calculamos el % sobre el total de cancelaciones (60)
    (COUNT(ordernumber) * 100.0 / (SELECT COUNT(*) FROM sales_data WHERE status = 'Cancelled')) as Porcentaje_Del_Problema
FROM sales_data
WHERE status = 'Cancelled'
GROUP BY country
ORDER BY Cantidad_Cancelaciones DESC;

-- 3. TOP 10 CLIENTES (Principio de Pareto)
-- Objetivo: Identificar a los clientes que generan la mayor facturación.
SELECT TOP 10
    customername as Cliente,
    SUM(sales) as Facturacion_Total,
    COUNT(ordernumber) as Frecuencia_Compra
FROM sales_data
GROUP BY customername
ORDER BY Facturacion_Total DESC;

-- 4. VALIDACIÓN DE INTEGRIDAD DE DATOS (El caso 2005)
-- Objetivo: Demostrar por qué el año 2005 parece tener ventas bajas (Corte de data).
SELECT 
    YEAR(orderdate) as Anio,
    MAX(orderdate) as Ultima_Fecha_Registrada,
    MIN(orderdate) as Primera_Fecha_Registrada
FROM sales_data
GROUP BY YEAR(orderdate)
ORDER BY Anio DESC;
--first
SELECT 
    L.Country,(
        SELECT TOP 1
            SH.CompanyName
        FROM 
            [Northwind].[DWH].[F_Shipper] FS
        INNER JOIN 
            [Northwind].[DWH].[D_Location] L2 ON FS.LocationID = L2.LocationID
        INNER JOIN 
            [Northwind].[DWH].[D_Shipper] SH ON FS.Shipper_Key = SH.Shipper_Key
        WHERE 
            L2.Country = L.Country
            AND FS.CreateTimestamp >= '2024-05-01' 
            AND FS.CreateTimestamp <= '2024-06-01'
        GROUP BY 
            SH.CompanyName
        ORDER BY 
            AVG(FS.AvgShipmentTime) ASC) AS FastestShipper,
    (
        SELECT TOP 1
            CAST(AVG(FS.AvgShipmentTime) AS DECIMAL(10,2))
        FROM 
            [Northwind].[DWH].[F_Shipper] FS
        INNER JOIN 
            [Northwind].[DWH].[D_Location] L2 ON FS.LocationID = L2.LocationID
        WHERE 
            L2.Country = L.Country
            AND FS.CreateTimestamp >= '2024-05-01' 
            AND FS.CreateTimestamp <= '2024-06-01'
        GROUP BY 
            FS.Shipper_Key
        ORDER BY 
            AVG(FS.AvgShipmentTime) ASC
    ) AS AvgShipmentTime
FROM 
    [Northwind].[DWH].[D_Location] L
GROUP BY 
    L.Country;



--second
SELECT L.Country,
    (
        SELECT TOP 1
            S.CompanyName
        FROM 
            [Northwind].[DWH].[F_Product] FP
        INNER JOIN 
            [Northwind].[DWH].[D_Location] L2 ON FP.LocationID = L2.LocationID
        INNER JOIN 
            [Northwind].[DWH].[D_Supplier] S ON FP.Supplier_Key = S.Supplier_Key
        WHERE 
            L2.Country = L.Country
            AND FP.CreateTimestamp >= '2024-05-14' 
            AND FP.CreateTimestamp <= '2024-06-14'
        GROUP BY 
            S.Supplier_Key, S.CompanyName
        ORDER BY 
            SUM(FP.Total_Revenue) DESC
    ) AS TopSupplier,(
        SELECT TOP 1
            SUM(FP.Total_Revenue)
        FROM 
            [Northwind].[DWH].[F_Product] FP
        INNER JOIN 
            [Northwind].[DWH].[D_Location] L2 ON FP.LocationID = L2.LocationID
        INNER JOIN 
            [Northwind].[DWH].[D_Supplier] S ON FP.Supplier_Key = S.Supplier_Key
        WHERE 
            L2.Country = L.Country
            AND FP.CreateTimestamp >= '2024-05-01' 
            AND FP.CreateTimestamp <= '2024-06-01'
        GROUP BY S.Supplier_Key
        ORDER BY 
            SUM(FP.Total_Revenue) DESC ) AS TotalRevenue FROM 
    [Northwind].[DWH].[D_Location] L
GROUP BY 
    L.Country;


--third
SELECT sp.CompanyName, SUM(p.Num_of_Sold_Units) AS NoSoldUnits
FROM [Northwind].[DWH].[F_Product] p
INNER JOIN
	[Northwind].[DWH].[D_Supplier] sp
	ON P.Supplier_Key = SP.Supplier_Key
INNER JOIN 
    [Northwind].[DWH].[D_Date] D ON P.DateKey = D.DateKey
WHERE 
    D.Date >= '2024-05-01' AND D.Date <= '2024-06-01'
GROUP BY  sp.CompanyName
ORDER BY NoSoldUnits;

--forth
SELECT L.Country, 
	CAST(AVG(sh.AvgShipmentCost)AS DECIMAL(10,2)) AS AverageShipmentCost
FROM [Northwind].[DWH].[F_Shipper] sh
INNER JOIN 
    [Northwind].[DWH].[D_Location] L ON sh.LocationID = L.LocationID
GROUP BY L.Country
ORDER BY AverageShipmentCost;


--fifth
SELECT 
    (Emp.FirstName+' ' + Emp.LastName) as EmpName,
    SUM(SP.Total_Number_Of_Orders) AS Total_orders
FROM 
    [Northwind].[DWH].[F_Sales] SP
INNER JOIN 
    [Northwind].[DWH].[D_Employee] Emp ON SP.Employee_Key = Emp.src_id
INNER JOIN 
    [Northwind].[DWH].[D_Date] D ON SP.DateKey = D.DateKey
WHERE 
	D.Date >= '2024-05-01' AND D.Date < '2024-06-01'
GROUP BY 
    (Emp.FirstName+' ' + Emp.LastName)
ORDER BY 
    Total_orders;


--sixth
SELECT stgSh.CompanyName , sum(fSh.NumberOfOrders) as Number_of_orders 
From [Northwind].[DWH].[F_Shipper] fSh 
Inner join  
[Northwind].[DWH].[D_Shipper] stgSh on fSh.Shipper_Key = stgSh.shipper_key
INNER JOIN 
    [Northwind].[DWH].[D_Date] D ON fSh.DateKey = D.DateKey
WHERE 
    D.Date >= '2024-05-13' AND D.Date <= '2024-06-13'
Group by stgSh.CompanyName;


--seventh
SELECT 
    L.Country,
    CAST(SUM(FP.Total_Revenue) AS DECIMAL(10,2)) AS Total_Revenue
FROM 
    [Northwind].[DWH].[F_Product] FP
INNER JOIN 
    [Northwind].[DWH].[D_Location] L ON FP.LocationID = L.LocationID
INNER JOIN 
    [Northwind].[DWH].[D_Date] D ON FP.DateKey = D.DateKey
WHERE 
    D.Date >= '2024-05-14' AND D.Date <= '2024-06-14'
GROUP BY 
    L.Country
order by Total_Revenue; 



SELECT * FROM DWH.F_Product 

SELECT D.Date ,dp.CategoryName, 
Cast(SUM(p.Total_Revenue) As decimal(10,2)) AS TotalRevenueByCategory
FROM [Northwind].[DWH].[F_Product] p
INNER JOIN
    [Northwind].[DWH].[D_Product] dp
    ON P.Product_Key = dP.Product_Key
INNER JOIN 
    [Northwind].[DWH].[D_Date] D ON P.DateKey = D.DateKey

GROUP BY D.Date ,dp.CategoryName
ORDER BY TotalRevenueByCategory;
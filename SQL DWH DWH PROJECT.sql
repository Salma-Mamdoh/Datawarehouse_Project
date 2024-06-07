use Northwind
GO

Create Schema DWH
GO

CREATE TABLE DWH.D_Date (
   [DateKey] [int] NOT NULL,
   [Date] [date] NOT NULL,
   [Day] [tinyint] NOT NULL,
   [DaySuffix] [char](2) NOT NULL,
   [Weekday] [tinyint] NOT NULL,
   [WeekDayName] [varchar](10) NOT NULL,
   [WeekDayName_Short] [char](3) NOT NULL,
   [WeekDayName_FirstLetter] [char](1) NOT NULL,
   [DOWInMonth] [tinyint] NOT NULL,
   [DayOfYear] [smallint] NOT NULL,
   [WeekOfMonth] [tinyint] NOT NULL,
   [WeekOfYear] [tinyint] NOT NULL,
   [Month] [tinyint] NOT NULL,
   [MonthName] [varchar](10) NOT NULL,
   [MonthName_Short] [char](3) NOT NULL,
   [MonthName_FirstLetter] [char](1) NOT NULL,
   [Quarter] [tinyint] NOT NULL,
   [QuarterName] [varchar](6) NOT NULL,
   [Year] [int] NOT NULL,
   [MMYYYY] [char](6) NOT NULL,
   [MonthYear] [char](7) NOT NULL,
   [IsWeekend] BIT NOT NULL,
   [IsHoliday] BIT NOT NULL,
   [HolidayName] VARCHAR(20) NULL,
   [SpecialDays] VARCHAR(20) NULL,
   [FinancialYear] [int] NULL,
   [FinancialQuater] [int] NULL,
   [FinancialMonth] [int] NULL,
   [FirstDateofYear] DATE NULL,
   [LastDateofYear] DATE NULL,
   [FirstDateofQuater] DATE NULL,
   [LastDateofQuater] DATE NULL,
   [FirstDateofMonth] DATE NULL,
   [LastDateofMonth] DATE NULL,
   [FirstDateofWeek] DATE NULL,
   [LastDateofWeek] DATE NULL,
   [CurrentYear] SMALLINT NULL,
   [CurrentQuater] SMALLINT NULL,
   [CurrentMonth] SMALLINT NULL,
   [CurrentWeek] SMALLINT NULL,
   [CurrentDay] SMALLINT NULL,
   PRIMARY KEY CLUSTERED ([DateKey] ASC)
);


SET NOCOUNT ON

DECLARE @CurrentDate DATE = '2010-01-01'
DECLARE @EndDate DATE = '2030-12-31'

WHILE @CurrentDate < @EndDate
BEGIN
   INSERT INTO DWH.D_Date (
      [DateKey],
      [Date],
      [Day],
      [DaySuffix],
      [Weekday],
      [WeekDayName],
      [WeekDayName_Short],
      [WeekDayName_FirstLetter],
      [DOWInMonth],
      [DayOfYear],
      [WeekOfMonth],
      [WeekOfYear],
      [Month],
      [MonthName],
      [MonthName_Short],
      [MonthName_FirstLetter],
      [Quarter],
      [QuarterName],
      [Year],
      [MMYYYY],
      [MonthYear],
      [IsWeekend],
      [IsHoliday],
      [FirstDateofYear],
      [LastDateofYear],
      [FirstDateofQuater],
      [LastDateofQuater],
      [FirstDateofMonth],
      [LastDateofMonth],
      [FirstDateofWeek],
      [LastDateofWeek]
      )
   SELECT DateKey = YEAR(@CurrentDate) * 10000 + MONTH(@CurrentDate) * 100 + DAY(@CurrentDate),
      DATE = @CurrentDate,
      Day = DAY(@CurrentDate),
      [DaySuffix] = CASE 
         WHEN DAY(@CurrentDate) = 1
            OR DAY(@CurrentDate) = 21
            OR DAY(@CurrentDate) = 31
            THEN 'st'
         WHEN DAY(@CurrentDate) = 2
            OR DAY(@CurrentDate) = 22
            THEN 'nd'
         WHEN DAY(@CurrentDate) = 3
            OR DAY(@CurrentDate) = 23
            THEN 'rd'
         ELSE 'th'
         END,
      WEEKDAY = DATEPART(dw, @CurrentDate),
      WeekDayName = DATENAME(dw, @CurrentDate),
      WeekDayName_Short = UPPER(LEFT(DATENAME(dw, @CurrentDate), 3)),
      WeekDayName_FirstLetter = LEFT(DATENAME(dw, @CurrentDate), 1),
      [DOWInMonth] = DAY(@CurrentDate),
      [DayOfYear] = DATENAME(dy, @CurrentDate),
      [WeekOfMonth] = DATEPART(WEEK, @CurrentDate) - DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM, 0, @CurrentDate), 0)) + 1,
      [WeekOfYear] = DATEPART(wk, @CurrentDate),
      [Month] = MONTH(@CurrentDate),
      [MonthName] = DATENAME(mm, @CurrentDate),
      [MonthName_Short] = UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [MonthName_FirstLetter] = LEFT(DATENAME(mm, @CurrentDate), 1),
      [Quarter] = DATEPART(q, @CurrentDate),
      [QuarterName] = CASE 
         WHEN DATENAME(qq, @CurrentDate) = 1
            THEN 'First'
         WHEN DATENAME(qq, @CurrentDate) = 2
            THEN 'second'
         WHEN DATENAME(qq, @CurrentDate) = 3
            THEN 'third'
         WHEN DATENAME(qq, @CurrentDate) = 4
            THEN 'fourth'
         END,
      [Year] = YEAR(@CurrentDate),
      [MMYYYY] = RIGHT('0' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)), 2) + CAST(YEAR(@CurrentDate) AS VARCHAR(4)),
      [MonthYear] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [IsWeekend] = CASE 
         WHEN DATENAME(dw, @CurrentDate) = 'Sunday'
            OR DATENAME(dw, @CurrentDate) = 'Saturday'
            THEN 1
         ELSE 0
         END,
      [IsHoliday] = 0,
      [FirstDateofYear] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-01-01' AS DATE),
      [LastDateofYear] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-12-31' AS DATE),
      [FirstDateofQuater] = DATEADD(qq, DATEDIFF(qq, 0, GETDATE()), 0),
      [LastDateofQuater] = DATEADD(dd, - 1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) + 1, 0)),
      [FirstDateofMonth] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)) + '-01' AS DATE),
      [LastDateofMonth] = EOMONTH(@CurrentDate),
      [FirstDateofWeek] = DATEADD(dd, - (DATEPART(dw, @CurrentDate) - 1), @CurrentDate),
      [LastDateofWeek] = DATEADD(dd, 7 - (DATEPART(dw, @CurrentDate)), @CurrentDate)

   SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

--Update Holiday information
UPDATE DWH.D_Date
SET [IsHoliday] = 1,
   [HolidayName] = 'Christmas'
WHERE [Month] = 12
   AND [DAY] = 25

UPDATE DWH.D_Date
SET SpecialDays = 'Valentines Day'
WHERE [Month] = 2
   AND [DAY] = 14

--Update current date information
UPDATE DWH.D_Date
SET CurrentYear = DATEDIFF(yy, GETDATE(), DATE),
    CurrentQuater = DATEDIFF(q, GETDATE(), DATE),
    CurrentMonth = DATEDIFF(m, GETDATE(), DATE),
    CurrentWeek = DATEDIFF(ww, GETDATE(), DATE),
    CurrentDay = DATEDIFF(dd, GETDATE(), DATE);


-------------------------------------------------
CREATE TABLE DWH.D_Location (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    City NVARCHAR(50),
    Country NVARCHAR(50)
);

INSERT INTO DWH.D_Location (City, Country)
SELECT DISTINCT ShipCity, ShipCountry
FROM Orders;

-- Create DWH.D_Customer table
CREATE TABLE DWH.D_Customer (
    Customer_Key INT IDENTITY(1,1) PRIMARY KEY,
	src_id NCHAR(5),
    CompanyName NVARCHAR(40) NOT NULL,
    ContactName NVARCHAR(30) NULL,
    ContactTitle NVARCHAR(30) NULL,
    Address NVARCHAR(60) NULL,
    City NVARCHAR(15) NULL,
    Region NVARCHAR(15) NULL,
    PostalCode NVARCHAR(10) NULL,
    Country NVARCHAR(15) NULL,
    Phone NVARCHAR(24) NULL,
    Fax NVARCHAR(24) NULL,
    is_last BIT,
    create_timestamp DATETIME,
    update_timestamp DATETIME
);

-- Create DWH.D_Employee table
CREATE TABLE DWH.D_Employee (
    Employee_Key INT IDENTITY(1,1) PRIMARY KEY,
    src_id INT,
    LastName NVARCHAR(20) NOT NULL,
    FirstName NVARCHAR(10) NOT NULL,
    Title NVARCHAR(30) NULL,
    TitleOfCourtesy NVARCHAR(25) NULL,
    BirthDate DATETIME NULL,
    HireDate DATETIME NULL,
    Address NVARCHAR(60) NULL,
    City NVARCHAR(15) NULL,
    Region NVARCHAR(15) NULL,
    PostalCode NVARCHAR(10) NULL,
    Country NVARCHAR(15) NULL,
    HomePhone NVARCHAR(24) NULL,
    Extension NVARCHAR(4) NULL,
    Photo IMAGE NULL,
    Notes NTEXT NULL,
    ReportsTo INT NULL,
    PhotoPath NVARCHAR(255) NULL,
    TerritoryID NVARCHAR(20) NULL,
    TerritoryDescription NCHAR(50) NULL,
    RegionDescription NCHAR(50) NULL,
    is_last BIT,
    create_timestamp DATETIME ,
    update_timestamp DATETIME
);

-- Create DWH.D_Supplier table
CREATE TABLE DWH.D_Supplier (
    Supplier_Key INT IDENTITY(1,1) PRIMARY KEY,
    src_id INT,
    CompanyName NVARCHAR(40) NOT NULL,
    ContactName NVARCHAR(30) NULL,
    ContactTitle NVARCHAR(30) NULL,
    Address NVARCHAR(60) NULL,
    City NVARCHAR(15) NULL,
    Region NVARCHAR(15) NULL,
    PostalCode NVARCHAR(10) NULL,
    Country NVARCHAR(15) NULL,
    Phone NVARCHAR(24) NULL,
    Fax NVARCHAR(24) NULL,
    HomePage NTEXT NULL,
    is_last BIT,
    create_timestamp DATETIME,
    update_timestamp DATETIME
);

-- Create DWH.D_Product table
CREATE TABLE DWH.D_Product (
    Product_Key INT IDENTITY(1,1) PRIMARY KEY,
    src_id INT,
    ProductName NVARCHAR(40) NOT NULL,
    SupplierID INT NULL,
    CategoryID INT NULL,
    QuantityPerUnit NVARCHAR(20) NULL,
    UnitPrice MONEY NULL,
    UnitsInStock SMALLINT NULL,
    UnitsOnOrder SMALLINT NULL,
    ReorderLevel SMALLINT NULL,
    Discontinued BIT NOT NULL,
    CategoryName NVARCHAR(15) NOT NULL,
    CategoryDescription NTEXT NULL,
    CategoryPicture IMAGE NULL,
    is_last BIT,
    create_timestamp DATETIME,
    update_timestamp DATETIME
);
ALTER TABLE DWH.D_Product
ADD ProfitPerUnit DECIMAL(10,1) NULL;


CREATE TABLE DWH.D_Shipper (
    Shipper_Key INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT NOT NULL,
    CompanyName NVARCHAR(40) NOT NULL,
    is_last BIT,
    create_timestamp DATETIME,
    update_timestamp DATETIME
);
ALTER TABLE DWH.D_Shipper
ADD Phone NVARCHAR(24) NULL;

CREATE TABLE DWH.F_Sales (
    Sales_Key INT IDENTITY(1,1) PRIMARY KEY,
    SalesID INT,
    DateKey INT, 
	Employee_Key INT,
	Customer_Key INT,
	Total_Number_Of_Orders INT,
	Total_Revenue REAL,
	Create_timestamp datetime
    CONSTRAINT FK_Sales_Date FOREIGN KEY (DateKey) REFERENCES DWH.D_Date(DateKey),
	CONSTRAINT FK_Sales_Employee FOREIGN KEY (Employee_Key) REFERENCES DWH.D_Employee(Employee_Key),
	CONSTRAINT FK_Sales_Customer FOREIGN KEY (Customer_Key) REFERENCES DWH.D_Customer(Customer_Key)
);



--DROP TABLE DWH.F_Shipper
CREATE TABLE DWH.F_Shipper (
    Shipper_Info_Key INT IDENTITY(1,1) PRIMARY KEY,
    DateKey INT, 
    Shipper_Key INT, 
	LocationID INT,
    NumberOfOrders INT,
    AvgShipmentTime REAL,
	AvgShipmentCost REAL,
    CreateTimestamp DATETIME,
    CONSTRAINT FK_Shipper_Info_Date FOREIGN KEY (DateKey) REFERENCES DWH.D_Date(DateKey),
    CONSTRAINT FK_Shipper_Info_Shipper FOREIGN KEY (Shipper_Key) REFERENCES DWH.D_Shipper(Shipper_Key),
	CONSTRAINT FK_Shipper_Info_Location FOREIGN KEY (LocationID) REFERENCES DWH.D_Location(LocationID)

);



-- Create DWH.F_Product fact table
CREATE TABLE DWH.F_Product (
    Product_Info_Key INT IDENTITY(1,1) PRIMARY KEY,
    DateKey INT,
    Product_Key INT, 
	Supplier_Key INT,
	LocationID INT,
	Num_of_Sold_Units INT,
	Total_Revenue Real,
    CreateTimestamp DATETIME,
    CONSTRAINT FK_Product_Info_Date FOREIGN KEY (DateKey) REFERENCES DWH.D_Date(DateKey),
    CONSTRAINT FK_Product_Info_Product FOREIGN KEY (Product_Key) REFERENCES DWH.D_Product(Product_Key),
	CONSTRAINT FK_Product_Info_Supplier FOREIGN KEY (Supplier_Key) REFERENCES DWH.D_Supplier(Supplier_Key),
	CONSTRAINT FK_Product_Info_Location FOREIGN KEY (LocationID) REFERENCES DWH.D_Location(LocationID)

);
SELECT * FROM DWH.D_Location;
SELECT * FROM DWH.D_Date;
SELECT * FROM DWH.D_Customer;
SELECT * FROM DWH.D_Employee;
SELECT * FROM DWH.D_Product;
SELECT * FROM DWH.D_Supplier;
SELECT * FROM DWH.D_Shipper;
SELECT * FROM DWH.F_Sales;
SELECT * FROM DWH.F_Shipper;
SELECT * FROM DWH.F_Product;


--TRUNCATE TABLE DWH.D_Customer
--TRUNCATE TABLE DWH.D_Employee
--TRUNCATE TABLE DWH.D_Product
--TRUNCATE TABLE DWH.D_Supplier
--TRUNCATE TABLE DWH.D_Shipper

--DROP TABLE DWH.F_Sales
--DROP TABLE DWH.F_Product
--DROP TABLE DWH.F_Shipper
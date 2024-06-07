use Northwind

GO

--CREATE SCHEMA STG

GO
CREATE TABLE STG.Customer (
    CustomerID NCHAR(5) PRIMARY KEY,
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
    CustomerTypeID NCHAR(10) NULL,
    CustomerDesc NTEXT NULL,
    src_update_date DATETIME,
    create_timestamp DATETIME
);
CREATE TABLE STG.Employee (
    EmployeeID INT PRIMARY KEY,
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
    src_update_date DATETIME,
    create_timestamp DATETIME
);
CREATE TABLE STG.Supplier(
    SupplierID INT PRIMARY KEY,
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
    src_update_date DATETIME,
    create_timestamp DATETIME
);
CREATE TABLE STG.Product (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(40) NOT NULL,
    SupplierID INT NULL,
    CategoryID INT NULL,
    QuantityPerUnit NVARCHAR(20) NULL,
    UnitPrice MONEY NULL,
    UnitsInStock SMALLINT NULL,
    UnitsOnOrder SMALLINT NULL,
    ReorderLevel SMALLINT NULL,
	profit_per_unit DECIMAL(10,1),
    Discontinued BIT NOT NULL,
    CategoryName NVARCHAR(15) NOT NULL,
    CategoryDescription NTEXT NULL,
    CategoryPicture IMAGE NULL,
	update_date datetime,
    src_update_date DATETIME,
    create_timestamp DATETIME,
);
CREATE TABLE STG.Shipper
(
    shipper_key INT  PRIMARY KEY,
    company_name nvarchar(40) NOT NULL,
	Phone nvarchar (24) NULL,
	src_update_date DATETIME,
    create_timestamp DATETIME
);
CREATE TABLE STG.Sales(
	SalesID INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID NCHAR(5),
	EmployeeID INT,
	Total_Number_Of_Orders INT,
	Total_Revenue REAL,
	src_update_date DATETIME,
    create_timestamp DATETIME
);


--DROP TABLE STG.Shipper_Info
CREATE TABLE STG.Shipper_Info(
	Shipper_Info_ID INT IDENTITY(1,1) PRIMARY KEY,
	shipper_Key INT,
	City NVARCHAR(50),
	NumberOfOrders INT,
    AvgShipmentTime_in_days REAL,
	AvgShipmentCost REAL,
	src_update_date DATETIME,
    create_timestamp DATETIME
);

CREATE TABLE STG.Product_Info(
	Product_Info_ID INT IDENTITY(1,1) PRIMARY KEY,
	ProductID INT,
	SupplierID INT,
	Num_of_Sold_Units INT,
	Total_Revenue Real,
	City NVARCHAR(50),
	src_update_date DATETIME,
    create_timestamp DATETIME
);

CREATE TABLE STG.Conf_Table (
  table_name varchar(30),
  last_extract_date datetime
);
INSERT INTO STG.Conf_Table (table_name, last_extract_date)
VALUES ('Customer', '1950-01-01'),
       ('Employee', '1950-01-01'),
       ('Supplier', '1950-01-01'),
       ('Product', '1950-01-01'),
       ('Order_info', '1950-01-01'),
       ('Sales', '1950-01-01'),
	   ('Shipper', '1950-01-01'),
	   ('Shipper_Info', '1950-01-01'),
	   ('Customer_Info', '1950-01-01'),
	   ('Employee_Info', '1950-01-01'),
	   ('Product_Info', '1950-01-01')


-- Check the data in Conf_Table
SELECT * FROM STG.Conf_Table;

SELECT * FROM STG.Customer;
SELECT * FROM STG.Employee;
SELECT * FROM STG.Shipper;
SELECT * FROM STG.Supplier;
SELECT * FROM STG.Product;
SELECT * FROM STG.Sales;
SELECT * FROM STG.Product_Info;
SELECT * FROM STG.Shipper_Info;

TRUNCATE TABLE STG.Shipper_Info
--TRUNCATE TABLE STG.Conf_Table
SELECT * FROM Northwind.dbo.Customers
SELECT * FROM Northwind.dbo.Shippers
SELECT * FROM dbo.CustomerDemographics
SELECT * FROM dbo.CustomerCustomerDemo 

UPDATE Northwind.dbo.Customers SET ContactName='NEW SALMA Mamdoh' WHERE CustomerID='ALFKI';

UPDATE Northwind.dbo.Shippers SET Phone='(503) 555-9832' WHERE ShipperID=1;

UPDATE Northwind.dbO.Shippers SET update_date=GETDATE()

SELECT * FROM Orders

SELECT * FROM DBO.Products

UPDATE STG.Conf_Table SET last_extract_date='1950-01-01'WHERE table_name='Shipper_Info';
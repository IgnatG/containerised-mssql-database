-- Create the database if it does not exist
IF NOT EXISTS (SELECT *
FROM sys.databases
WHERE name = 'SampleMarketDB')
BEGIN
  CREATE DATABASE [SampleMarketDB];
END;
GO

USE [SampleMarketDB];
GO

-- Drop tables in dependency-safe order
DROP TABLE IF EXISTS [order_items];
DROP TABLE IF EXISTS [orders];
DROP TABLE IF EXISTS [inventory];
DROP TABLE IF EXISTS [products];
DROP TABLE IF EXISTS [suppliers];
DROP TABLE IF EXISTS [categories];
DROP TABLE IF EXISTS [customers];
GO

-- Create categories table
CREATE TABLE [categories]
(
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [name] VARCHAR(100) NOT NULL,
  [description] TEXT
);
GO

-- Create suppliers table
CREATE TABLE [suppliers]
(
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [name] VARCHAR(150) NOT NULL,
  [contact_email] VARCHAR(100),
  [phone] VARCHAR(20)
);
GO

-- Create products table
CREATE TABLE [products]
(
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [name] VARCHAR(150) NOT NULL,
  [category_id] INT FOREIGN KEY REFERENCES [categories](id),
  [supplier_id] INT FOREIGN KEY REFERENCES [suppliers](id),
  [price] DECIMAL(10, 2) NOT NULL,
  [unit] VARCHAR(20),
  [barcode] VARCHAR(50)
);
GO

-- Create inventory table
CREATE TABLE [inventory]
(
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [product_id] INT FOREIGN KEY REFERENCES [products](id),
  [quantity] INT NOT NULL,
  [last_updated] DATETIME DEFAULT GETDATE()
);
GO

-- Create customers table
CREATE TABLE [customers]
(
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [first_name] VARCHAR(50) NOT NULL,
  [last_name] VARCHAR(50) NOT NULL,
  [email] VARCHAR(100),
  [phone] VARCHAR(20),
  [address] VARCHAR(250)
);
GO

-- Create orders table
CREATE TABLE [orders]
(
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [customer_id] INT FOREIGN KEY REFERENCES [customers](id),
  [order_date] DATETIME DEFAULT GETDATE(),
  [total_amount] DECIMAL(10, 2)
);
GO

-- Create order_items table
CREATE TABLE [order_items]
(
  [id] INT IDENTITY(1,1) PRIMARY KEY,
  [order_id] INT FOREIGN KEY REFERENCES [orders](id),
  [product_id] INT FOREIGN KEY REFERENCES [products](id),
  [quantity] INT NOT NULL,
  [unit_price] DECIMAL(10, 2) NOT NULL
);
GO

-- Insert sample data into categories
INSERT INTO [categories]
  (name, description)
VALUES
  ('Beverages', 'Soft drinks, tea, coffee, etc.'),
  ('Bakery', 'Bread, pastries, and cakes'),
  ('Dairy', 'Milk, cheese, butter, and more'),
  ('Produce', 'Fresh fruits and vegetables'),
  ('Meat & Seafood', 'Raw meat, poultry, and fish');
GO

-- Insert sample data into suppliers
INSERT INTO [suppliers]
  (name, contact_email, phone)
VALUES
  ('FreshFarms Ltd.', 'contact@freshfarms.com', '01234 567890'),
  ('OceanCatch', 'orders@oceancatch.co.uk', '01345 678901'),
  ('BakeHouse Supplies', 'info@bakehouse.com', '01456 789012'),
  ('DailyDairy Co.', 'support@dailydairy.co.uk', '01567 890123');
GO

-- Insert sample data into products
INSERT INTO [products]
  (name, category_id, supplier_id, price, unit, barcode)
VALUES
  ('Orange Juice 1L', 1, 1, 1.99, 'bottle', 'OJ123456'),
  ('Whole Wheat Bread', 2, 3, 2.49, 'loaf', 'WWB234567'),
  ('Cheddar Cheese 200g', 3, 4, 2.99, 'pack', 'CHC345678'),
  ('Bananas (per kg)', 4, 1, 0.89, 'kg', 'BAN456789'),
  ('Salmon Fillet 250g', 5, 2, 5.99, 'pack', 'SAL567890');
GO

-- Insert sample data into inventory
INSERT INTO [inventory]
  (product_id, quantity)
VALUES
  (1, 120),
  (2, 60),
  (3, 80),
  (4, 150),
  (5, 40);
GO

-- Insert sample data into customers
INSERT INTO [customers]
  (first_name, last_name, email, phone, address)
VALUES
  ('Emma', 'Brown', 'emma.brown@example.com', '07123 456789', '10 Market Street, London'),
  ('James', 'Wilson', 'james.wilson@example.com', '07234 567890', '22 High Street, Leeds'),
  ('Olivia', 'Taylor', 'olivia.taylor@example.com', '07345 678901', '5 Green Lane, Manchester');
GO

-- Insert sample data into orders
INSERT INTO [orders]
  (customer_id, order_date, total_amount)
VALUES
  (1, '2025-07-25', 8.97),
  (2, '2025-07-26', 3.38),
  (3, '2025-07-27', 5.98);
GO

-- Insert sample data into order_items
INSERT INTO [order_items]
  (order_id, product_id, quantity, unit_price)
VALUES
  (1, 1, 2, 1.99),
  (1, 3, 1, 2.99),
  (2, 2, 1, 2.49),
  (2, 4, 1, 0.89),
  (3, 5, 1, 5.99);
GO

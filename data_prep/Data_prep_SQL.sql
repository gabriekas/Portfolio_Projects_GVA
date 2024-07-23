
-- Request 1. Detailed overview of all individual customers


WITH
-- Determine the latest address of the customer
  latest_address AS (
  SELECT
    DISTINCT c.CustomerID,
    MAX(a.AddressID) max_address_id
  FROM
    `tc-da-1.adwentureworks_db.address` a
  INNER JOIN
    `tc-da-1.adwentureworks_db.customeraddress`c
  ON
    a.AddressID = c.AddressID
  GROUP BY
    c.CustomerID),
 
-- Create additional CTE with aggregations to avoid grouping of all other columns in the main SELECT statement
  orders_by_customer AS (
  SELECT
    CustomerID,
    COUNT(SalesOrderID) no_of_orders,
    ROUND(SUM(TotalDue),3) total_amount,
    MAX(OrderDate) date_last_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`
  GROUP BY
    CustomerID
    ) 

 -- Main query with requested data

SELECT
  individual_customers.CustomerID,
  customers_contact.Firstname,
  customers_contact.LastName,
  CONCAT(customers_contact.Firstname,' ',customers_contact.LastName) FullName,
IF
  (customers_contact.Title IS NULL, CONCAT('Dear',' ',customers_contact.LastName), CONCAT(customers_contact.Title,' ',customers_contact.LastName)) addressing_title,
  customers_contact.Emailaddress,
  customers_contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  COALESCE(address.AddressLine2,' ') AddressLine2,
  state.Name State,
  country.Name Country,
  orders_by_customer.no_of_orders,
  orders_by_customer.total_amount,
  orders_by_customer.date_last_order
FROM
  `adwentureworks_db.individual` individual_customers
INNER JOIN
  `adwentureworks_db.contact` customers_contact
ON
  individual_customers.ContactID = customers_contact.ContactId
INNER JOIN
  `adwentureworks_db.customer` customer
ON
  individual_customers.CustomerID = customer.CustomerID
INNER JOIN
  `adwentureworks_db.customeraddress` customer_address
ON
  customer.CustomerID = customer_address.CustomerID
INNER JOIN
  `adwentureworks_db.address` address
ON
  customer_address.AddressID = address.AddressID
INNER JOIN
  `adwentureworks_db.stateprovince` state
ON
  address.StateProvinceID = state.StateProvinceID
INNER JOIN
  `adwentureworks_db.countryregion` country
ON
  state.CountryRegionCode = country.CountryRegionCode
INNER JOIN
  latest_address
ON
  address.AddressID = latest_address.max_address_id
INNER JOIN
  orders_by_customer
ON
  customer.CustomerID = orders_by_customer.CustomerID
ORDER BY
  orders_by_customer.total_amount DESC



-- Request 2. Top 200 customers with highest total amount (with tax) who did not order over the last year



WITH
-- Determine the latest address of the customer
  latest_address AS (
  SELECT
    DISTINCT c.CustomerID,
    MAX(a.AddressID) max_address_id
  FROM
    `tc-da-1.adwentureworks_db.address` a
  INNER JOIN
    `tc-da-1.adwentureworks_db.customeraddress`c
  ON
    a.AddressID = c.AddressID
  GROUP BY
    c.CustomerID),


-- Create additional CTE with aggregations to avoid grouping of all other columns in the main SELECT statement
  orders_by_customer AS (
  SELECT
    CustomerID,
    COUNT(SalesOrderID) no_of_orders,
    ROUND(SUM(TotalDue),3) total_amount,
    MAX(OrderDate) date_last_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`
  GROUP BY
    CustomerID) 

 -- Main query with requested data   
SELECT
  individual_customers.CustomerID,
  customers_contact.Firstname,
  customers_contact.LastName,
  CONCAT(customers_contact.Firstname,' ',customers_contact.LastName) FullName,
IF
  (customers_contact.Title IS NULL, CONCAT('Dear',' ',customers_contact.LastName), CONCAT(customers_contact.Title,' ',customers_contact.LastName)) addressing_title,
  customers_contact.Emailaddress,
  customers_contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  COALESCE(address.AddressLine2,' ') AddressLine2,
  state.Name State,
  country.Name Country,
  orders_by_customer.no_of_orders,
  orders_by_customer.total_amount,
  orders_by_customer.date_last_order
FROM
  `adwentureworks_db.individual` individual_customers
INNER JOIN
  `adwentureworks_db.contact` customers_contact
ON
  individual_customers.ContactID = customers_contact.ContactId
INNER JOIN
  `adwentureworks_db.customer` customer
ON
  individual_customers.CustomerID = customer.CustomerID
INNER JOIN
  `adwentureworks_db.customeraddress` customer_address
ON
  customer.CustomerID = customer_address.CustomerID
INNER JOIN
  `adwentureworks_db.address` address
ON
  customer_address.AddressID = address.AddressID
INNER JOIN
  `adwentureworks_db.stateprovince` state
ON
  address.StateProvinceID = state.StateProvinceID
INNER JOIN
  `adwentureworks_db.countryregion` country
ON
  state.CountryRegionCode = country.CountryRegionCode
INNER JOIN
  latest_address
ON
  address.AddressID = latest_address.max_address_id
INNER JOIN
  orders_by_customer
ON
  customer.CustomerID = orders_by_customer.CustomerID
WHERE
  orders_by_customer.date_last_order < (
  -- Subquery to identify date for the latest order 1 year prior
  SELECT
    DATE_SUB(MAX(orderDate), INTERVAL 365 day) year_prior_latest_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`) 
ORDER BY
  orders_by_customer.total_amount DESC
LIMIT
  200


-- Request 3. Active and inactive customers.


-- Determine the latest address of the customer
WITH
  latest_address AS (
  SELECT
    DISTINCT c.CustomerID,
    MAX(a.AddressID) max_address_id
  FROM
    `tc-da-1.adwentureworks_db.address` a
  INNER JOIN
    `tc-da-1.adwentureworks_db.customeraddress`c
  ON
    a.AddressID = c.AddressID
  GROUP BY
    c.CustomerID),
  
  -- Create additional CTE with aggregations to avoid grouping of all other columns in the main SELECT statement
  orders_by_customer AS (
  SELECT
    CustomerID,
    COUNT(SalesOrderID) no_of_orders,
    ROUND(SUM(TotalDue),3) total_amount,
    MAX(OrderDate) date_last_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`
  GROUP BY
    CustomerID) 

-- Main query with request data
SELECT
  individual_customers.CustomerID,
  customers_contact.Firstname,
  customers_contact.LastName,
  CONCAT(customers_contact.Firstname,' ',customers_contact.LastName) FullName,
IF
  (customers_contact.Title IS NULL, CONCAT('Dear',' ',customers_contact.LastName), CONCAT(customers_contact.Title,' ',customers_contact.LastName)) addressing_title,
  customers_contact.Emailaddress,
  customers_contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  COALESCE(address.AddressLine2,' ') AddressLine2,
  state.Name State,
  country.Name Country,
  orders_by_customer.no_of_orders,
  orders_by_customer.total_amount,
  orders_by_customer.date_last_order,
  CASE
    WHEN orders_by_customer.date_last_order > ( SELECT DATE_SUB(MAX(orderDate), INTERVAL 365 day) year_prior_latest_order FROM `tc-da-1.adwentureworks_db.salesorderheader`) THEN 'active'
    WHEN orders_by_customer.date_last_order < (
  SELECT
    DATE_SUB(MAX(orderDate), INTERVAL 365 day) year_prior_latest_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`) THEN 'inactive'
END
  AS activity_status
FROM
  `adwentureworks_db.individual` individual_customers
INNER JOIN
  `adwentureworks_db.contact` customers_contact
ON
  individual_customers.ContactID = customers_contact.ContactId
INNER JOIN
  `adwentureworks_db.customer` customer
ON
  individual_customers.CustomerID = customer.CustomerID
INNER JOIN
  `adwentureworks_db.customeraddress` customer_address
ON
  customer.CustomerID = customer_address.CustomerID
INNER JOIN
  `adwentureworks_db.address` address
ON
  customer_address.AddressID = address.AddressID
INNER JOIN
  `adwentureworks_db.stateprovince` state
ON
  address.StateProvinceID = state.StateProvinceID
INNER JOIN
  `adwentureworks_db.countryregion` country
ON
  state.CountryRegionCode = country.CountryRegionCode
INNER JOIN
  latest_address
ON
  address.AddressID = latest_address.max_address_id
INNER JOIN
  orders_by_customer
ON
  customer.CustomerID = orders_by_customer.CustomerID
ORDER BY
  customer.CustomerID DESC


-- Request 4. Top active customers from North America.


WITH
-- Determine the latest address of the customer
  latest_address AS (
  SELECT
    DISTINCT c.CustomerID,
    MAX(a.AddressID) max_address_id
  FROM
    `tc-da-1.adwentureworks_db.address` a
  INNER JOIN
    `tc-da-1.adwentureworks_db.customeraddress`c
  ON
    a.AddressID = c.AddressID
  GROUP BY
    c.CustomerID),


-- Create additional CTE with aggregations to avoid grouping of all other columns in the main SELECT statement
  orders_by_customer AS (
  SELECT
    CustomerID,
    COUNT(SalesOrderID) no_of_orders,
    ROUND(SUM(TotalDue),3) total_amount,
    MAX(OrderDate) date_last_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`
  GROUP BY
    CustomerID)

-- Main query with requested data    
SELECT
  individual_customers.CustomerID,
  customers_contact.Firstname,
  customers_contact.LastName,
  CONCAT(customers_contact.Firstname,' ',customers_contact.LastName) FullName,
IF
  (customers_contact.Title IS NULL, CONCAT('Dear',' ',customers_contact.LastName), CONCAT(customers_contact.Title,' ',customers_contact.LastName)) addressing_title,
  customers_contact.Emailaddress,
  customers_contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  REGEXP_EXTRACT(address.AddressLine1, '[0-9]+') address_no,
  REGEXP_EXTRACT(address.AddressLine1, '[^0-9]+') Address_st,
  COALESCE(address.AddressLine2,' ') AddressLine2,
  state.Name State,
  country.Name Country,
  orders_by_customer.no_of_orders,
  orders_by_customer.total_amount,
  orders_by_customer.date_last_order,
  CASE
    WHEN orders_by_customer.date_last_order > ( SELECT DATE_SUB(MAX(orderDate), INTERVAL 365 day) year_prior_latest_order FROM `tc-da-1.adwentureworks_db.salesorderheader`) THEN 'active'
    WHEN orders_by_customer.date_last_order < (
  SELECT
    DATE_SUB(MAX(orderDate), INTERVAL 365 day) year_prior_latest_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`) THEN 'inactive'
END
  AS activity_status
FROM
  `adwentureworks_db.individual` individual_customers
INNER JOIN
  `adwentureworks_db.contact` customers_contact
ON
  individual_customers.ContactID = customers_contact.ContactId
INNER JOIN
  `adwentureworks_db.customer` customer
ON
  individual_customers.CustomerID = customer.CustomerID
INNER JOIN
  `adwentureworks_db.customeraddress` customer_address
ON
  customer.CustomerID = customer_address.CustomerID
INNER JOIN
  `adwentureworks_db.address` address
ON
  customer_address.AddressID = address.AddressID
INNER JOIN
  `adwentureworks_db.stateprovince` state
ON
  address.StateProvinceID = state.StateProvinceID
INNER JOIN
  `adwentureworks_db.countryregion` country
ON
  state.CountryRegionCode = country.CountryRegionCode
INNER JOIN
  latest_address
ON
  address.AddressID = latest_address.max_address_id
INNER JOIN
  orders_by_customer
ON
  customer.CustomerID = orders_by_customer.CustomerID
INNER JOIN
  `adwentureworks_db.salesterritory` sales_territory
ON
  customer.TerritoryID = sales_territory.TerritoryID
WHERE
  sales_territory.Group = 'North America'
  AND orders_by_customer.date_last_order > (
-- Subquery to filter ou only active customers
  SELECT
    DATE_SUB(MAX(orderDate), INTERVAL 365 day) year_prior_latest_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`) 
  AND (orders_by_customer.total_amount >= 2500
    OR orders_by_customer.no_of_orders >=5)
ORDER BY
  Country,
  State,
  orders_by_customer.date_last_order


-- Request 5. Monthly sales numbers


SELECT
  LAST_DAY(DATE(order_header.OrderDate), month) order_month,
  sales_territory.CountryRegionCode,
  sales_territory.Name Region,
  COUNT (order_header.SalesOrderID) no_orders,
  COUNT (DISTINCT order_header.CustomerID)number_customers,
  COUNT(DISTINCT order_header.SalesPersonID) no_salesPersons,
  CAST(ROUND(SUM(order_header.TotalDue)) AS numeric) Total_w_tax
FROM
  `tc-da-1.adwentureworks_db.salesorderheader` order_header
INNER JOIN
  `tc-da-1.adwentureworks_db.salesterritory` sales_territory
ON
  order_header.TerritoryID = sales_territory.TerritoryID
GROUP BY
  order_month,
  CountryRegionCode,
  Region


-- Request 6. Cumulative sum of the total amount earned with tax per country and region


WITH
  t1 AS (
  SELECT
    LAST_DAY(DATE(order_header.OrderDate), month) order_month,
    sales_territory.CountryRegionCode,
    sales_territory.Name Region,
    COUNT (order_header.SalesOrderID) no_orders,
    COUNT (DISTINCT order_header.CustomerID)number_customers,
    COUNT(DISTINCT order_header.SalesPersonID) no_salesPersons,
    CAST(ROUND(SUM(order_header.TotalDue)) AS numeric) Total_w_tax
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` order_header
  INNER JOIN
    `tc-da-1.adwentureworks_db.salesterritory` sales_territory
  ON
    order_header.TerritoryID = sales_territory.TerritoryID
  GROUP BY
    order_month,
    CountryRegionCode,
    Region)
SELECT
  *,
  SUM(t1.Total_w_tax) OVER (PARTITION BY t1.Region ORDER BY t1.order_month) cumulative_sum
FROM
  t1


-- Request 7. Monthly country rank by sales


WITH
  t1 AS (
  SELECT
    LAST_DAY(DATE(order_header.OrderDate), month) order_month,
    sales_territory.CountryRegionCode,
    sales_territory.Name Region,
    COUNT (order_header.SalesOrderID) no_orders,
    COUNT (DISTINCT order_header.CustomerID)number_customers,
    COUNT(DISTINCT order_header.SalesPersonID) no_salesPersons,
    CAST(ROUND(SUM(order_header.TotalDue)) AS numeric) Total_w_tax
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` order_header
  INNER JOIN
    `tc-da-1.adwentureworks_db.salesterritory` sales_territory
  ON
    order_header.TerritoryID = sales_territory.TerritoryID
  GROUP BY
    order_month,
    CountryRegionCode,
    Region)
SELECT
  *,
  DENSE_RANK() OVER (PARTITION BY t1.Region ORDER BY t1.Total_w_tax DESC) country_sales_rank,
  SUM(t1.Total_w_tax) OVER (PARTITION BY t1.Region ORDER BY t1.order_month) cumulative_sum
FROM
  t1


-- Request 8. Taxes on a country level


WITH
  t1 AS (
  SELECT
    LAST_DAY(DATE(order_header.OrderDate), month) order_month,
    sales_territory.CountryRegionCode CountryRegionCode,
    sales_territory.Name Region,
    COUNT (order_header.SalesOrderID) no_orders,
    COUNT (DISTINCT order_header.CustomerID)number_customers,
    COUNT(DISTINCT order_header.SalesPersonID) no_salesPersons,
    CAST(ROUND(SUM(order_header.TotalDue)) AS numeric) Total_w_tax
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` order_header
  INNER JOIN
    `tc-da-1.adwentureworks_db.salesterritory` sales_territory
  ON
    order_header.TerritoryID = sales_territory.TerritoryID
  GROUP BY
    order_month,
    CountryRegionCode,
    Region),
  t2 AS(
  SELECT
    province.CountryRegionCode country,
    province.Name province,
  -- Selecting highest tax rate since some state have multiple tax rates
    MAX(tax_rate.TaxRate) Tax_rate
  FROM
    `tc-da-1.adwentureworks_db.stateprovince` province
  LEFT JOIN
    `tc-da-1.adwentureworks_db.salestaxrate` tax_rate
  ON
    province.StateProvinceID = tax_rate.StateProvinceID
  GROUP BY
    country, province)
SELECT
  t1.order_month,
  t1.CountryRegionCode,
  t1.Region,
  t1.no_orders,
  t1.number_customers,
  t1.no_salesPersons,
  t1.Total_w_tax,
  DENSE_RANK() OVER (PARTITION BY t1.Region ORDER BY t1.Total_w_tax DESC) country_sales_rank,
  SUM(t1.Total_w_tax) OVER (PARTITION BY t1.Region ORDER BY t1.order_month) cumulative_sum,
-- Mean tax rate to represent average tax rate in a country as taxes may vary accros provinces
  ROUND(AVG(t2.Tax_rate),1) mean_tax_rate,
-- Percentage of provinces with available tax
  ROUND(COUNT(t2.Tax_rate)/COUNT(t2.province),2) perc_provinces_w_tax
FROM
  t1
INNER JOIN
  t2
ON
  t1.CountryRegionCode = t2.country
GROUP BY
  t1.order_month,
  t1.CountryRegionCode,
  t1.Region,
  t1.no_orders,
  t1.number_customers,
  t1.no_salesPersons,
  t1.Total_w_tax
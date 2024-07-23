-- 1.1_v2

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
  --CTE used to determine the latest customer' address
  orders_by_customer AS (
  SELECT
    CustomerID,
    COUNT(SalesOrderID) no_of_orders,
    ROUND(SUM(TotalDue),3) total_amount,
    MAX(OrderDate) date_last_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`
  GROUP BY
    CustomerID) --Another CTE to avoid grouping of all other columns in the main SELECT statement
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
LIMIT
  200


--1.2_v2

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
  --CTE used to determine the latest customer' address
  orders_by_customer AS (
  SELECT
    CustomerID,
    COUNT(SalesOrderID) no_of_orders,
    ROUND(SUM(TotalDue),3) total_amount,
    MAX(OrderDate) date_last_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`
  GROUP BY
    CustomerID) --Another CTE to avoid grouping of all other columns in the main SELECT statement
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
  SELECT
    DATE_SUB(MAX(orderDate), INTERVAL 365 day) year_prior_latest_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`) --subquery used to calculate the date of the latest order and the actual date of 365 days prior the date of the latest order
ORDER BY
  orders_by_customer.total_amount DESC
LIMIT
  200


--1.3_v2

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
  --CTE used to determine the latest customer' address
  orders_by_customer AS (
  SELECT
    CustomerID,
    COUNT(SalesOrderID) no_of_orders,
    ROUND(SUM(TotalDue),3) total_amount,
    MAX(OrderDate) date_last_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`
  GROUP BY
    CustomerID) --Another CTE to avoid grouping of all other columns in the main SELECT statement
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
  LIMIT 500


--1.4_v2


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
  --CTE used to determine the latest customer' address
  orders_by_customer AS (
  SELECT
    CustomerID,
    COUNT(SalesOrderID) no_of_orders,
    ROUND(SUM(TotalDue),3) total_amount,
    MAX(OrderDate) date_last_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`
  GROUP BY
    CustomerID) --Another CTE to avoid grouping of all other columns in the main SELECT statement
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
  SELECT
    DATE_SUB(MAX(orderDate), INTERVAL 365 day) year_prior_latest_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader`) --Subquery for filtering only active customers
  AND (orders_by_customer.total_amount >= 2500
    OR orders_by_customer.no_of_orders >=5)
ORDER BY
  Country,
  State,
  orders_by_customer.date_last_order


--2.1_v2


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

--2.2_v2

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


--2.3_v2


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


--2.4_v2


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
  ROUND(AVG(t2.Tax_rate),1) mean_tax_rate,
  ROUND(COUNT(t2.Tax_rate)/COUNT(t2.province),2) per_provinces_w_tax
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
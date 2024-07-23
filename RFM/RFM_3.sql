--Additional query to retrieve data for RFM dashboard (pulling products' info)


SELECT 
DISTINCT Description, 
CustomerID,
SUM(Quantity) AS quantity_ordered,
SUM(Quantity*UnitPrice) AS total_sales
FROM `tc-da-1.turing_data_analytics.rfm`
--Select date range from 2010-12-01 to 2011-12-01
WHERE InvoiceDate < '2011-12-02' 
--Filters out damaged, wrongly sold orders etc.
AND Quantity > 0 
--Filters out debt adjustments
AND UnitPrice > 0 
--Filters out customers without ID
AND CustomerID IS NOT NULL 
GROUP BY Description, CustomerID
--Additional query to retrieve data for RFM dashboard (pulling customer's country)


SELECT  
DISTINCT CustomerID,
Country,
InvoiceDate
FROM `tc-da-1.turing_data_analytics.rfm`
--Select date range from 2010-12-01 to 2011-12-01
WHERE InvoiceDate < '2011-12-02' 
--Filter out damaged, wrongly sold orders etc.
AND Quantity > 0 
--Filter out debt adjustments
AND UnitPrice > 0 
--Filters out customers without ID
AND CustomerID IS NOT NULL 
--Additional data for RFM dashboard (part 1)


SELECT  
DISTINCT CustomerID,
Country,
InvoiceDate
FROM `tc-da-1.turing_data_analytics.rfm`
WHERE InvoiceDate < '2011-12-02' --Selects date range from 2010-12-01 to 2011-12-01
AND Quantity > 0 --Filters out damaged, wrongly sold orders etc.
AND UnitPrice > 0 --Filters out debt adjustments
AND CustomerID IS NOT NULL --Filters out customers without ID
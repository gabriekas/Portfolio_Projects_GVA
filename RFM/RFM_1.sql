WITH

-- Computation for Frequency & Monetary

F_and_M AS (
SELECT CustomerID,
MAX(DATE(InvoiceDate)) AS last_purchase_date,
COUNT(DISTINCT InvoiceNo) AS frequency,
SUM (UnitPrice*Quantity) AS monetary
FROM `tc-da-1.turing_data_analytics.rfm`
--Select date range from 2010-12-01 to 2011-12-01
--(the earliest invoice date available in the data set it 2010-12-01)
WHERE InvoiceDate < '2011-12-02'
--Filter out damaged, wrongly sold orders, etc.
AND Quantity > 0 
--Filter out debt adjustments
AND UnitPrice > 0
--Filter out customers without ID
AND CustomerID IS NOT NULL 
GROUP BY CustomerID
),

--Computation for Recency

R AS (
SELECT *,
DATE_DIFF(reference_date, last_purchase_date, DAY) AS recency
FROM (
  SELECT *,
  --Set reference date as 2011-12-01 
  MAX(last_purchase_date) OVER () AS reference_date 
  FROM F_and_M)
  ),

--Determination of quartiles for RFM metrics
Quartiles AS (
SELECT
R.*,
--All percentiles for MONETARY
tm.percentiles[OFFSET(25)] AS m25,
tm.percentiles[OFFSET(50)] AS m50,
tm.percentiles[OFFSET(75)] AS m75,
--All percentiles for FREQUENCY
tf.percentiles[OFFSET(25)] AS f25,
tf.percentiles[OFFSET(50)] AS f50,
tf.percentiles[OFFSET(75)] AS f75,
--All percentiles for RECENCY
tr.percentiles[OFFSET(25)] AS r25,
tr.percentiles[OFFSET(50)] AS r50,
tr.percentiles[OFFSET(75)] AS r75,
FROM
R,
(SELECT APPROX_QUANTILES(monetary, 100) percentiles FROM R) tm,
(SELECT APPROX_QUANTILES(frequency, 100) percentiles FROM R) tf,
(SELECT APPROX_QUANTILES(recency, 100) percentiles FROM R) tr
),

--Scores for RFM metrics

RFM_scores AS (
SELECT
*,
CONCAT(r_score, f_score, m_score) AS rfm_score
FROM (
  SELECT *,
  CASE WHEN monetary <= m25 THEN 1
        WHEN monetary <= m50 AND monetary > m25 THEN 2
        WHEN monetary <= m75 AND monetary > m50 THEN 3
        WHEN monetary > m75 THEN 4
  END AS m_score,
  CASE WHEN frequency <= f25 THEN 1
        WHEN frequency <= f50 AND frequency > f25 THEN 2
        WHEN frequency <= f75 AND frequency > f50 THEN 3
        WHEN frequency > f75 THEN 4
  END AS f_score,
  --Recency scoring is reversed as more recent customers should be scored higher in this metric
  CASE WHEN recency <= r25 THEN 4
        WHEN recency <= r50 AND recency > r25 THEN 3
        WHEN recency <= r75 AND recency > r50 THEN 2
        WHEN recency > r75 THEN 1
  END AS r_score,
  FROM Quartiles))

  --Customer segmentation

  SELECT
  CustomerID,
  recency,
  frequency,
  monetary,
  rfm_score,
  CASE 
  WHEN rfm_score IN ('334','343','344','433','434','443','444') THEN 'Best Customers'
  WHEN rfm_score IN ('224','233','234','243','244','324','333') THEN 'Big Spenders'
  WHEN rfm_score IN ('212','222','231','242','311','312','321','322','331','342','421','422','431','432','441','442') THEN 'Loyal Customers'
  WHEN rfm_score IN ('313','314','411','412','413','414') THEN 'Promising Customers'
  WHEN rfm_score IN ('132','213','214','223','232','323','332','423','424') THEN 'Need Attention'
  WHEN rfm_score IN ('122','142','143','144','211','221') THEN 'Customers at Risk'
  WHEN rfm_score IN ('113','114','123','124','133','134') THEN 'Cannot be Lost'
  WHEN rfm_score IN ('111','112','121','131','141') THEN 'Lost Customers'
  END AS rfm_segement
  FROM RFM_scores 
CREATE SCHEMA IF NOT EXISTS lakehouse.gold;
CREATE TABLE lakehouse.gold.top20_returned_customers
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT c.custkey, c.name,
       CAST(sum(f.net_revenue) AS DECIMAL(24,4)) AS revenue,
       c.acctbal, c.nation, c.address, c.phone, c.comment
FROM lakehouse.silver.customers c
JOIN lakehouse.silver.returned_items f ON c.custkey = f.custkey
GROUP BY c.custkey, c.name, c.acctbal, c.nation, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

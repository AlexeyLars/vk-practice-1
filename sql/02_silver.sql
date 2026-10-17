CREATE SCHEMA IF NOT EXISTS lakehouse.silver;
CREATE TABLE lakehouse.silver.customers
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT c.custkey, trim(c.name) AS name,
       CAST(c.acctbal AS DECIMAL(15,2)) AS acctbal,
       upper(trim(n.name)) AS nation, c.address,
       regexp_replace(c.phone, '[^0-9-]', '') AS phone, c.comment
FROM lakehouse.bronze.customer c
JOIN lakehouse.bronze.nation n ON c.nationkey = n.nationkey
WHERE c.custkey IS NOT NULL AND c.name IS NOT NULL;
CREATE TABLE lakehouse.silver.returned_items
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT o.custkey, o.orderkey, l.linenumber, o.orderdate,
       CAST(date_trunc('month', o.orderdate) AS DATE) AS order_month,
       CAST(l.extendedprice AS DECIMAL(15,2)) AS extendedprice,
       CAST(l.discount AS DECIMAL(4,2)) AS discount,
       CAST(CAST(l.extendedprice AS DECIMAL(15,2)) *
            (DECIMAL '1.00' - CAST(l.discount AS DECIMAL(4,2)))
            AS DECIMAL(20,4)) AS net_revenue
FROM lakehouse.bronze.orders o
JOIN lakehouse.bronze.lineitem l ON o.orderkey = l.orderkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND upper(trim(l.returnflag)) = 'R'
  AND l.extendedprice >= 0 AND l.discount BETWEEN 0 AND 1
  AND o.custkey IS NOT NULL;

SELECT version();

SELECT version();

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM tpch.sf1.customer c
JOIN tpch.sf1.orders o ON c.custkey = o.custkey
JOIN tpch.sf1.lineitem l ON l.orderkey = o.orderkey
JOIN tpch.sf1.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT count(*) FROM tpch.sf1.customer;

SELECT count(*) FROM tpch.sf1.orders;

SELECT count(*) FROM tpch.sf1.lineitem;

SELECT count(*) FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_orc_zstd;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.customer;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.orders;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_orc_zstd;

CREATE TABLE lakehouse.bronze_orc_zstd.customer
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_orc_zstd.orders
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_orc_zstd.lineitem
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_orc_zstd.nation
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze;

DROP TABLE IF EXISTS lakehouse.bronze.customer;

DROP TABLE IF EXISTS lakehouse.bronze.orders;

DROP TABLE IF EXISTS lakehouse.bronze.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze;

CREATE TABLE lakehouse.bronze.customer
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze.orders
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze.lineitem
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze.nation
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_snappy;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.customer;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.orders;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_snappy;

CREATE TABLE lakehouse.bronze_parquet_snappy.customer
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_parquet_snappy.orders
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_parquet_snappy.lineitem
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_parquet_snappy.nation
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_none;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.customer;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.orders;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_none;

CREATE TABLE lakehouse.bronze_parquet_none.customer
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_parquet_none.orders
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_parquet_none.lineitem
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_parquet_none.nation
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_gzip;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.customer;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.orders;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_gzip;

CREATE TABLE lakehouse.bronze_parquet_gzip.customer
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_parquet_gzip.orders
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_parquet_gzip.lineitem
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_parquet_gzip.nation
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_orc_zstd;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.customer;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.orders;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_orc_zstd;

CREATE TABLE lakehouse.bronze_orc_zstd.customer
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_orc_zstd.orders
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_orc_zstd.lineitem
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_orc_zstd.nation
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_snappy;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.customer;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.orders;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_snappy;

CREATE TABLE lakehouse.bronze_parquet_snappy.customer
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_parquet_snappy.orders
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_parquet_snappy.lineitem
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_parquet_snappy.nation
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_gzip;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.customer;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.orders;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_gzip;

CREATE TABLE lakehouse.bronze_parquet_gzip.customer
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_parquet_gzip.orders
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_parquet_gzip.lineitem
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_parquet_gzip.nation
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze;

DROP TABLE IF EXISTS lakehouse.bronze.customer;

DROP TABLE IF EXISTS lakehouse.bronze.orders;

DROP TABLE IF EXISTS lakehouse.bronze.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze;

CREATE TABLE lakehouse.bronze.customer
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze.orders
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze.lineitem
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze.nation
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_none;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.customer;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.orders;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_none;

CREATE TABLE lakehouse.bronze_parquet_none.customer
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_parquet_none.orders
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_parquet_none.lineitem
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_parquet_none.nation
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_none;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.customer;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.orders;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_none.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_none;

CREATE TABLE lakehouse.bronze_parquet_none.customer
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_parquet_none.orders
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_parquet_none.lineitem
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_parquet_none.nation
WITH (format = 'PARQUET', compression_codec = 'NONE') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_gzip;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.customer;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.orders;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_gzip.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_gzip;

CREATE TABLE lakehouse.bronze_parquet_gzip.customer
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_parquet_gzip.orders
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_parquet_gzip.lineitem
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_parquet_gzip.nation
WITH (format = 'PARQUET', compression_codec = 'GZIP') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze;

DROP TABLE IF EXISTS lakehouse.bronze.customer;

DROP TABLE IF EXISTS lakehouse.bronze.orders;

DROP TABLE IF EXISTS lakehouse.bronze.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze;

CREATE TABLE lakehouse.bronze.customer
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze.orders
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze.lineitem
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze.nation
WITH (format = 'PARQUET', compression_codec = 'ZSTD') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_snappy;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.customer;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.orders;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_parquet_snappy.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_parquet_snappy;

CREATE TABLE lakehouse.bronze_parquet_snappy.customer
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_parquet_snappy.orders
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_parquet_snappy.lineitem
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_parquet_snappy.nation
WITH (format = 'PARQUET', compression_codec = 'SNAPPY') AS
SELECT nationkey, name FROM tpch.sf1.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_orc_zstd;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.customer;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.orders;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.lineitem;

DROP TABLE IF EXISTS lakehouse.bronze_orc_zstd.nation;

CREATE SCHEMA IF NOT EXISTS lakehouse.bronze_orc_zstd;

CREATE TABLE lakehouse.bronze_orc_zstd.customer
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.sf1.customer;

CREATE TABLE lakehouse.bronze_orc_zstd.orders
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT orderkey, custkey, orderdate FROM tpch.sf1.orders;

CREATE TABLE lakehouse.bronze_orc_zstd.lineitem
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.sf1.lineitem;

CREATE TABLE lakehouse.bronze_orc_zstd.nation
WITH (format = 'ORC', compression_codec = 'ZSTD') AS
SELECT nationkey, name FROM tpch.sf1.nation;

SELECT count(*) FROM lakehouse.bronze_parquet_none.customer;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_none."customer$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_none.orders;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_none."orders$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_none.lineitem;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_none."lineitem$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_none.nation;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_none."nation$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_snappy.customer;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_snappy."customer$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_snappy.orders;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_snappy."orders$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_snappy.lineitem;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_snappy."lineitem$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_snappy.nation;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_snappy."nation$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_gzip.customer;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_gzip."customer$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_gzip.orders;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_gzip."orders$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_gzip.lineitem;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_gzip."lineitem$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_parquet_gzip.nation;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_parquet_gzip."nation$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze.customer;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze."customer$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze.orders;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze."orders$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze.lineitem;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze."lineitem$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze.nation;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze."nation$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_orc_zstd.customer;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_orc_zstd."customer$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_orc_zstd.orders;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_orc_zstd."orders$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_orc_zstd.lineitem;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_orc_zstd."lineitem$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze_orc_zstd.nation;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze_orc_zstd."nation$files" WHERE content = 0;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_none.customer c
JOIN lakehouse.bronze_parquet_none.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_none.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_none.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_snappy.customer c
JOIN lakehouse.bronze_parquet_snappy.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_snappy.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_snappy.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_gzip.customer c
JOIN lakehouse.bronze_parquet_gzip.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_gzip.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_gzip.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze.customer c
JOIN lakehouse.bronze.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_orc_zstd.customer c
JOIN lakehouse.bronze_orc_zstd.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_orc_zstd.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_orc_zstd.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_snappy.customer c
JOIN lakehouse.bronze_parquet_snappy.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_snappy.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_snappy.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_gzip.customer c
JOIN lakehouse.bronze_parquet_gzip.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_gzip.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_gzip.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze.customer c
JOIN lakehouse.bronze.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_none.customer c
JOIN lakehouse.bronze_parquet_none.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_none.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_none.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_orc_zstd.customer c
JOIN lakehouse.bronze_orc_zstd.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_orc_zstd.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_orc_zstd.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_none.customer c
JOIN lakehouse.bronze_parquet_none.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_none.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_none.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze.customer c
JOIN lakehouse.bronze.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_orc_zstd.customer c
JOIN lakehouse.bronze_orc_zstd.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_orc_zstd.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_orc_zstd.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_gzip.customer c
JOIN lakehouse.bronze_parquet_gzip.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_gzip.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_gzip.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_snappy.customer c
JOIN lakehouse.bronze_parquet_snappy.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_snappy.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_snappy.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze.customer c
JOIN lakehouse.bronze.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_none.customer c
JOIN lakehouse.bronze_parquet_none.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_none.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_none.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_gzip.customer c
JOIN lakehouse.bronze_parquet_gzip.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_gzip.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_gzip.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_snappy.customer c
JOIN lakehouse.bronze_parquet_snappy.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_snappy.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_snappy.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_orc_zstd.customer c
JOIN lakehouse.bronze_orc_zstd.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_orc_zstd.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_orc_zstd.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze.customer c
JOIN lakehouse.bronze.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_orc_zstd.customer c
JOIN lakehouse.bronze_orc_zstd.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_orc_zstd.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_orc_zstd.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_none.customer c
JOIN lakehouse.bronze_parquet_none.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_none.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_none.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_snappy.customer c
JOIN lakehouse.bronze_parquet_snappy.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_snappy.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_snappy.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_gzip.customer c
JOIN lakehouse.bronze_parquet_gzip.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_gzip.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_gzip.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_none.customer c
JOIN lakehouse.bronze_parquet_none.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_none.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_none.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze.customer c
JOIN lakehouse.bronze.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_snappy.customer c
JOIN lakehouse.bronze_parquet_snappy.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_snappy.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_snappy.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_orc_zstd.customer c
JOIN lakehouse.bronze_orc_zstd.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_orc_zstd.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_orc_zstd.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

SELECT c.custkey, c.name,
       sum(l.extendedprice * (1 - l.discount)) AS revenue,
       c.acctbal, n.name AS nation, c.address, c.phone, c.comment
FROM lakehouse.bronze_parquet_gzip.customer c
JOIN lakehouse.bronze_parquet_gzip.orders o ON c.custkey = o.custkey
JOIN lakehouse.bronze_parquet_gzip.lineitem l ON l.orderkey = o.orderkey
JOIN lakehouse.bronze_parquet_gzip.nation n ON c.nationkey = n.nationkey
WHERE o.orderdate >= DATE '1993-10-01'
  AND o.orderdate < DATE '1994-01-01'
  AND l.returnflag = 'R'
GROUP BY c.custkey, c.name, c.acctbal, n.name, c.address, c.phone, c.comment
ORDER BY revenue DESC, c.custkey
LIMIT 20;

CREATE SCHEMA IF NOT EXISTS lakehouse.gold;

DROP TABLE IF EXISTS lakehouse.gold.top20_returned_customers;

CREATE SCHEMA IF NOT EXISTS lakehouse.silver;

DROP TABLE IF EXISTS lakehouse.silver.returned_items;

DROP TABLE IF EXISTS lakehouse.silver.customers;

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

SELECT 'customer_duplicate_key' AS check_name, count(*) AS violations FROM
 (SELECT custkey FROM lakehouse.bronze.customer GROUP BY custkey HAVING count(*) > 1);

SELECT 'orders_duplicate_key' AS check_name, count(*) AS violations FROM
 (SELECT orderkey FROM lakehouse.bronze.orders GROUP BY orderkey HAVING count(*) > 1);

SELECT 'lineitem_duplicate_key' AS check_name, count(*) AS violations FROM
 (SELECT orderkey, linenumber FROM lakehouse.bronze.lineitem GROUP BY 1, 2 HAVING count(*) > 1);

SELECT 'nation_duplicate_key' AS check_name, count(*) AS violations FROM
 (SELECT nationkey FROM lakehouse.bronze.nation GROUP BY 1 HAVING count(*) > 1);

SELECT 'invalid_lineitem' AS check_name, count(*) AS violations
FROM lakehouse.bronze.lineitem
WHERE orderkey IS NULL OR linenumber IS NULL OR extendedprice IS NULL
   OR discount IS NULL OR returnflag IS NULL OR extendedprice < 0
   OR discount NOT BETWEEN 0 AND 1 OR returnflag NOT IN ('R', 'A', 'N');

SELECT 'invalid_customer' AS check_name, count(*) AS violations
FROM lakehouse.bronze.customer
WHERE custkey IS NULL OR name IS NULL OR nationkey IS NULL OR acctbal IS NULL
   OR address IS NULL OR phone IS NULL OR comment IS NULL;

SELECT 'orphan_orders' AS check_name, count(*) AS violations
FROM lakehouse.bronze.orders o LEFT JOIN lakehouse.bronze.customer c ON o.custkey = c.custkey
WHERE c.custkey IS NULL OR o.orderkey IS NULL OR o.orderdate IS NULL;

SELECT 'orphan_lineitem' AS check_name, count(*) AS violations
FROM lakehouse.bronze.lineitem l LEFT JOIN lakehouse.bronze.orders o ON l.orderkey = o.orderkey
WHERE o.orderkey IS NULL;

SELECT 'orphan_nation' AS check_name, count(*) AS violations
FROM lakehouse.bronze.customer c LEFT JOIN lakehouse.bronze.nation n ON c.nationkey = n.nationkey
WHERE n.nationkey IS NULL;

SELECT 'silver_date_or_amount' AS check_name, count(*) AS violations
FROM lakehouse.silver.returned_items
WHERE orderdate < DATE '1993-10-01' OR orderdate >= DATE '1994-01-01'
   OR net_revenue < 0 OR net_revenue IS NULL;

SELECT count(*), CAST(sum(CAST(l.extendedprice AS DECIMAL(15,2)) *
        (DECIMAL '1.00' - CAST(l.discount AS DECIMAL(4,2)))) AS DECIMAL(30,4))
        FROM lakehouse.bronze.orders o JOIN lakehouse.bronze.lineitem l ON o.orderkey=l.orderkey
        WHERE o.orderdate >= DATE '1993-10-01' AND o.orderdate < DATE '1994-01-01'
          AND l.returnflag='R';

SELECT count(*), CAST(sum(net_revenue) AS DECIMAL(30,4)) FROM lakehouse.silver.returned_items;

SELECT count(*) FROM (SELECT orderkey, linenumber FROM lakehouse.silver.returned_items GROUP BY 1,2 HAVING count(*) > 1);

SELECT * FROM lakehouse.gold.top20_returned_customers ORDER BY revenue DESC, custkey;

SELECT count(*) FROM lakehouse.bronze.customer;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze."customer$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze.orders;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze."orders$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze.lineitem;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze."lineitem$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.bronze.nation;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.bronze."nation$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.silver.customers;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.silver."customers$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.silver.returned_items;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.silver."returned_items$files" WHERE content = 0;

SELECT count(*) FROM lakehouse.gold.top20_returned_customers;

SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) FROM lakehouse.gold."top20_returned_customers$files" WHERE content = 0;

SELECT file_path FROM lakehouse.silver."customers$files" ORDER BY 1;

SELECT count(*) FROM lakehouse.silver.customers;

ALTER TABLE lakehouse.silver.customers ADD COLUMN source_system VARCHAR;

ALTER TABLE lakehouse.silver.customers RENAME COLUMN source_system TO source_label;

DESCRIBE lakehouse.silver.customers;

SELECT count(*) FROM lakehouse.silver.customers WHERE source_label IS NULL;

SELECT file_path FROM lakehouse.silver."customers$files" ORDER BY 1;

ALTER TABLE lakehouse.silver.customers DROP COLUMN source_label;

DROP TABLE IF EXISTS lakehouse.gold.recovery_demo;

CREATE TABLE lakehouse.gold.recovery_demo WITH (format='PARQUET', compression_codec='ZSTD') AS SELECT * FROM lakehouse.gold.top20_returned_customers;

SELECT snapshot_id FROM lakehouse.gold."recovery_demo$snapshots" ORDER BY committed_at DESC LIMIT 1;

SELECT * FROM lakehouse.gold.recovery_demo ORDER BY revenue DESC, custkey;

DELETE FROM lakehouse.gold.recovery_demo WHERE custkey = 57040;

SELECT count(*) FROM lakehouse.gold.recovery_demo;

SELECT * FROM lakehouse.gold.recovery_demo FOR VERSION AS OF 7780297070286732377 ORDER BY revenue DESC, custkey;

ALTER TABLE lakehouse.gold.recovery_demo EXECUTE rollback_to_snapshot(7780297070286732377);

SELECT * FROM lakehouse.gold.recovery_demo ORDER BY revenue DESC, custkey;

SELECT * FROM lakehouse.gold."recovery_demo$history" ORDER BY made_current_at;

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_none."customer$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_none."customer$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_none."customer$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_none."customer$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_none."orders$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_none."orders$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_none."lineitem$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_none."lineitem$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_none."nation$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_none."nation$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_snappy."customer$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_snappy."customer$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_snappy."orders$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_snappy."orders$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_snappy."lineitem$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_snappy."lineitem$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_snappy."nation$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_snappy."nation$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_gzip."customer$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_gzip."customer$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_gzip."orders$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_gzip."orders$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_gzip."lineitem$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_gzip."lineitem$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_parquet_gzip."nation$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_parquet_gzip."nation$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze."customer$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze."customer$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze."orders$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze."orders$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze."lineitem$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze."lineitem$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze."nation$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze."nation$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_orc_zstd."customer$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_orc_zstd."customer$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_orc_zstd."orders$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_orc_zstd."orders$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_orc_zstd."lineitem$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_orc_zstd."lineitem$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.bronze_orc_zstd."nation$files" WHERE content = 0;

SELECT key, value FROM lakehouse.bronze_orc_zstd."nation$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.silver."customers$files" WHERE content = 0;

SELECT key, value FROM lakehouse.silver."customers$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.silver."returned_items$files" WHERE content = 0;

SELECT key, value FROM lakehouse.silver."returned_items$properties";

SELECT file_path, file_size_in_bytes FROM lakehouse.gold."top20_returned_customers$files" WHERE content = 0;

SELECT key, value FROM lakehouse.gold."top20_returned_customers$properties";


CREATE SCHEMA IF NOT EXISTS lakehouse.{schema};
CREATE TABLE lakehouse.{schema}.customer
WITH (format = '{format}', compression_codec = '{codec}') AS
SELECT custkey, name, address, nationkey, phone, acctbal, comment
FROM tpch.{scale}.customer;
CREATE TABLE lakehouse.{schema}.orders
WITH (format = '{format}', compression_codec = '{codec}') AS
SELECT orderkey, custkey, orderdate FROM tpch.{scale}.orders;
CREATE TABLE lakehouse.{schema}.lineitem
WITH (format = '{format}', compression_codec = '{codec}') AS
SELECT orderkey, linenumber, extendedprice, discount, returnflag
FROM tpch.{scale}.lineitem;
CREATE TABLE lakehouse.{schema}.nation
WITH (format = '{format}', compression_codec = '{codec}') AS
SELECT nationkey, name FROM tpch.{scale}.nation;

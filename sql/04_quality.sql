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

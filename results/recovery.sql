SELECT * FROM lakehouse.gold.recovery_demo FOR VERSION AS OF 7780297070286732377;
ALTER TABLE lakehouse.gold.recovery_demo EXECUTE rollback_to_snapshot(7780297070286732377);

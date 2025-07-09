/******************************************************************************\
 *
 * Date Written: 2024-01-01     Author: Joseph P.Merten
 * After Import Verification Script for Partitioned Transactions Table
 *
\******************************************************************************/
select version()
-- Check partition information
SELECT 
    schemaname,
    tablename
FROM pg_tables 
WHERE tablename LIKE 'transactions_2024_%'
ORDER BY tablename;

-- View data distribution across partitions
SELECT 
    tableoid::regclass AS partition_name,
    COUNT(*) AS row_count,
    MIN(transaction_date) AS min_date,
    MAX(transaction_date) AS max_date
FROM transactions
GROUP BY tableoid
ORDER BY partition_name;

-- Query by a specific partition
select count(*) from transactions_2024_01 t ;
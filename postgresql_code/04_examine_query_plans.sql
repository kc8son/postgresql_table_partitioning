/******************************************************************************\
 *
 * Date Written: 2024-01-01     Author: Joseph P.Merten
 * explain will show the query plan for partitioned tables.
 *
\******************************************************************************/
-- This query will only scan the January partition
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM transactions 
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-01-31';

-- This query will scan multiple relevant partitions
EXPLAIN (ANALYZE, BUFFERS)
SELECT transaction_type, SUM(amount) 
FROM transactions 
WHERE transaction_date BETWEEN '2024-06-01' AND '2024-08-31'
GROUP BY transaction_type;
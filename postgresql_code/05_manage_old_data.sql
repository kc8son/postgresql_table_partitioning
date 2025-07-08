/******************************************************************************\
 *
 * Date Written: 2024-01-01     Author: Joseph P.Merten
 * As our data ages, it is easy to drop old data and add new partitions for future data.
 *
\******************************************************************************/
-- Efficiently drop old data (e.g., January 2024)
DROP TABLE transactions_2024_01;

-- Add new partition for future data
CREATE TABLE transactions_2025_01 PARTITION OF transactions
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
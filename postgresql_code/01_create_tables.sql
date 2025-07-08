/******************************************************************************\
 *
 * Date Written: 2024-01-01     Author: Joseph P.Merten
 * PostgreSQL Script to Create Partitioned Tables for Transactions
 * This script creates a main partitioned table and monthly partitions for the year 2024.
 * Each partition corresponds to a month in 2024.
 *
\******************************************************************************/
-- Create the main partitioned table
CREATE TABLE transactions (
    transaction_id BIGSERIAL,
    transaction_date DATE NOT NULL,
    description TEXT,
    transaction_type VARCHAR(20),
    amount DECIMAL(10,2)
) PARTITION BY RANGE (transaction_date);

-- Create monthly partitions for 2024
CREATE TABLE transactions_2024_01 PARTITION OF transactions
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-04-01') TO ('2024-05-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-05-01') TO ('2024-06-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-06-01') TO ('2024-07-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-07-01') TO ('2024-08-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-08-01') TO ('2024-09-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-09-01') TO ('2024-10-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-10-01') TO ('2024-11-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
    FOR VALUES FROM ('2024-11-01') TO ('2024-12-01');

CREATE TABLE transactions_2024_12 PARTITION OF transactions
    FOR VALUES FROM ('2024-12-01') TO ('2025-01-01');
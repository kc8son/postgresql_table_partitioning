# 📊 PostgreSQL Table Partitioning Demo

A comprehensive demonstration of PostgreSQL table partitioning techniques using realistic bank transaction data.

## 🎯 Overview

This project showcases how to implement and manage **table partitioning** in PostgreSQL, using a year's worth of checking account transactions as sample data. Table partitioning is a powerful database optimization technique that can significantly improve query performance and maintenance operations on large datasets.

## 🔧 What is Table Partitioning?

Table partitioning is a database design technique where a large table is divided into smaller, more manageable pieces called **partitions**. Each partition contains a subset of the data based on specific criteria (like date ranges), but appears as a single table to applications.

### Benefits

- ⚡ **Faster Queries**: Query only relevant partitions
- 🗂️ **Easier Maintenance**: Backup, vacuum, and manage smaller data chunks
- 📈 **Better Performance**: Parallel processing across partitions
- 🔄 **Simplified Archival**: Drop old partitions instead of deleting rows

## 📁 Sample Data Structure

The project includes a full year of synthetic checking account data (2024):

```plaintext
example_checking_account_data/
├── 2024_01.csv    # January transactions
├── 2024_02.csv    # February transactions
├── ...
└── 2024_12.csv    # December transactions
```

Each CSV contains realistic bank transactions with:

- `transaction_id`: Unique identifier
- `transaction_date`: Date of the transaction
- `description`: Transaction description
- `transaction_type`: DEPOSIT, WITHDRAWAL, TRANSFER, FEE
- `amount`: Transaction amount (negative for debits)

## 🚀 Quick Start

### Prerequisites

- PostgreSQL 10+ (native partitioning support)
- psql command-line tool or your preferred PostgreSQL client

### 1. Create the Database Schema

```sql
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

-- Continue for all 12 months...
CREATE TABLE transactions_2024_12 PARTITION OF transactions
    FOR VALUES FROM ('2024-12-01') TO ('2025-01-01');
```

### 2. Load Sample Data

#### Option A: Using psql (Command Line)

```bash
# Load each month's data into the partitioned table
for month in {01..12}; do
    psql -d your_database -c "\COPY transactions FROM 'example_checking_account_data/2024_${month}.csv' WITH CSV HEADER;"
done
```

#### Option B: Using DBeaver (GUI)

1. **Connect to your PostgreSQL database** in DBeaver
2. **Right-click on the `transactions` table** in the Database Navigator
3. **Select "Import Data"** from the context menu
4. **Choose "CSV" as the data format**
5. **Configure the import settings:**
   - **Source**: Browse and select your first CSV file (e.g., `2024_01.csv`)
   - **Target**: Select the `transactions` table
   - **Options**:
     - ✅ Header row (skip first line)
     - ✅ Replace target data: **NO** (to append data)
     - **Delimiter**: Comma (,)
     - **Quote char**: Double quote (")
6. **Map the columns** (should auto-map if column names match)
7. **Click "Start" to import the data**
8. **Repeat for all 12 CSV files** (2024_01.csv through 2024_12.csv)

**Pro Tip**: You can also use DBeaver's **batch import feature**:

- Select multiple CSV files at once
- DBeaver will process them sequentially
- Monitor the import progress in the task view

### 3. Verify Partitioning

```sql
-- Check partition information
SELECT 
    schemaname,
    tablename,
    partitionbounds
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
```

## 📊 Performance Examples

### Query Performance Comparison

```sql
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
```

### Maintenance Operations

```sql
-- Efficiently drop old data (e.g., January 2024)
DROP TABLE transactions_2024_01;

-- Add new partition for future data
CREATE TABLE transactions_2025_01 PARTITION OF transactions
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
```

## 🔍 Advanced Features

### Automatic Partition Creation

```sql
-- Create a function to automatically create monthly partitions
CREATE OR REPLACE FUNCTION create_monthly_partition(target_date DATE)
RETURNS VOID AS $$
DECLARE
    start_date DATE;
    end_date DATE;
    table_name TEXT;
BEGIN
    start_date := DATE_TRUNC('month', target_date);
    end_date := start_date + INTERVAL '1 month';
    table_name := 'transactions_' || TO_CHAR(start_date, 'YYYY_MM');
    
    EXECUTE format('CREATE TABLE %I PARTITION OF transactions 
                    FOR VALUES FROM (%L) TO (%L)',
                   table_name, start_date, end_date);
END;
$$ LANGUAGE plpgsql;
```

### Constraint Exclusion

```sql
-- Create indexes on partitions for optimal performance
CREATE INDEX CONCURRENTLY ON transactions_2024_01 (transaction_date);
CREATE INDEX CONCURRENTLY ON transactions_2024_01 (transaction_type);

-- Partial indexes for specific use cases
CREATE INDEX CONCURRENTLY ON transactions_2024_01 (amount) 
WHERE transaction_type = 'DEPOSIT';
```

## 📈 Use Cases

This partitioning strategy is ideal for:

- **Financial Applications**: Transaction logs, account histories
- **Time-Series Data**: Sensor readings, log files, events
- **E-commerce**: Order histories, user activity logs
- **Analytics**: Historical data that's queried by time ranges

## 🛠️ Tools & Technologies

- **PostgreSQL 12+**: For advanced partitioning features
- **pg_partman**: Extension for automated partition management
- **pgbench**: For performance testing with large datasets

## 📚 Learning Resources

- [PostgreSQL Partitioning Documentation](https://www.postgresql.org/docs/current/ddl-partitioning.html)
- [Partition-wise Joins](https://www.postgresql.org/docs/current/ddl-partitioning.html#DDL-PARTITIONING-WISE-JOINS)
- [pg_partman Extension](https://github.com/pgpartman/pg_partman)

## 🤝 Contributing

Feel free to contribute by:

- Adding more partitioning strategies (hash, list partitioning)
- Including performance benchmarks
- Adding automation scripts
- Improving documentation

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Happy Partitioning!** 🎉

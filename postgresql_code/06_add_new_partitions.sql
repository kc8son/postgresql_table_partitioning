/******************************************************************************\
 *
 * Date Written: 2024-01-01     Author: Joseph P.Merten
 * We can even easily add new partitions for future data by using a function.
 *
\******************************************************************************/
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
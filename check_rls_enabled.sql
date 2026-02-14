-- Check if RLS is enabled on wallet_balances table
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename = 'wallet_balances' 
    AND schemaname = 'public';

-- Enable RLS if not already enabled
ALTER TABLE wallet_balances ENABLE ROW LEVEL SECURITY;

-- Examine all RLS policies for wallet_balances table
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'wallet_balances' 
    AND schemaname = 'public'
ORDER BY policyname;

-- Also check user_balances for comparison
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'user_balances' 
    AND schemaname = 'public'
ORDER BY policyname;

-- Check which roles have bypass RLS privilege
SELECT 
    rolname,
    rolbypassrls,
    rolcreaterole,
    rolcreatedb
FROM pg_roles 
WHERE rolname IN ('authenticated', 'anon', 'postgres', 'service_role')
ORDER BY rolname;

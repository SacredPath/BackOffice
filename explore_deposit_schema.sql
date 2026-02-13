-- ============================================
-- DEPOSIT ADDRESSES SCHEMA EXPLORATION QUERIES
-- ============================================

-- 1. Find all tables that might contain deposit/withdrawal address information
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND (
    table_name ILIKE '%deposit%' 
    OR table_name ILIKE '%withdraw%' 
    OR table_name ILIKE '%address%' 
    OR table_name ILIKE '%wallet%' 
    OR table_name ILIKE '%payment%' 
    OR table_name ILIKE '%transaction%'
)
ORDER BY table_name;

-- 2. Examine deposit_requests table structure (most likely to contain addresses)
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'deposit_requests' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 3. Examine withdrawal_requests table structure
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'withdrawal_requests' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 4. Look for any payment_methods or deposit_addresses tables
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name IN ('payment_methods', 'deposit_addresses', 'user_wallets', 'crypto_wallets') 
AND table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 5. Sample data from deposit_requests to see address structure
SELECT * FROM deposit_requests LIMIT 5;

-- 6. Sample data from withdrawal_requests to see address structure
SELECT * FROM withdrawal_requests LIMIT 5;

-- 6b. Check specifically for address-related columns in deposit_requests
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'deposit_requests' 
AND table_schema = 'public'
AND (
    column_name ILIKE '%address%' 
    OR column_name ILIKE '%wallet%' 
    OR column_name ILIKE '%crypto%'
    OR column_name ILIKE '%bank%'
    OR column_name ILIKE '%paypal%'
    OR column_name ILIKE '%payment%'
);

-- 6c. Check specifically for address-related columns in withdrawal_requests
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'withdrawal_requests' 
AND table_schema = 'public'
AND (
    column_name ILIKE '%address%' 
    OR column_name ILIKE '%wallet%' 
    OR column_name ILIKE '%crypto%'
    OR column_name ILIKE '%bank%'
    OR column_name ILIKE '%paypal%'
    OR column_name ILIKE '%payment%'
);

-- 7. Check for JSON columns that might contain address data
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public'
AND data_type ILIKE '%json%'
AND table_name IN ('deposit_requests', 'withdrawal_requests', 'users', 'profiles');

-- 8. Look for foreign key relationships that might indicate address tables
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_schema = 'public'
AND (tc.table_name ILIKE '%deposit%' OR tc.table_name ILIKE '%withdraw%' OR tc.table_name ILIKE '%payment%');

-- 9. Search for any address-related columns across all tables
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public'
AND (
    column_name ILIKE '%address%' 
    OR column_name ILIKE '%wallet%' 
    OR column_name ILIKE '%crypto%'
)
ORDER BY table_name, column_name;

-- 10. Check if there are any enum types related to payment methods
SELECT 
    t.typname AS enum_name,
    e.enumlabel AS enum_value
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid  
WHERE t.typtype = 'e'
AND (
    t.typname ILIKE '%payment%' 
    OR t.typname ILIKE '%method%'
    OR t.typname ILIKE '%deposit%'
    OR t.typname ILIKE '%withdraw%'
)
ORDER BY t.typname, e.enumsortorder;

-- 11. Get row counts to understand data volume
SELECT 
    schemaname,
    relname,
    n_live_tup AS row_count
FROM pg_stat_user_tables 
WHERE schemaname = 'public'
AND (
    relname ILIKE '%deposit%' 
    OR relname ILIKE '%withdraw%' 
    OR relname ILIKE '%payment%' 
    OR relname ILIKE '%address%' 
    OR relname ILIKE '%wallet%'
)
ORDER BY relname;

-- 12. Check for any comments on tables/columns that might explain address structure
SELECT 
    table_name,
    column_name,
    pg_catalog.obj_description(c.oid, 'pg_class') AS table_comment,
    pg_catalog.col_description(c.oid, a.attnum) AS column_comment
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
JOIN pg_catalog.pg_attribute a ON a.attrelid = c.oid
WHERE n.nspname = 'public'
AND (
    c.relname ILIKE '%deposit%' 
    OR c.relname ILIKE '%withdraw%' 
    OR c.relname ILIKE '%payment%'
    OR c.relname ILIKE '%address%'
    OR c.relname ILIKE '%wallet%'
)
AND a.attnum > 0
AND NOT a.attisdropped
ORDER BY c.relname, a.attnum;

-- ============================================
-- SAMPLE QUERIES TO EXTRACT ADDRESS DATA
-- ============================================

-- Example: If addresses are stored in a separate table
-- SELECT * FROM deposit_addresses WHERE user_id = 'your-user-id';

-- Example: If addresses are in JSON columns
-- SELECT id, user_id, payment_details->>'address' as address FROM deposit_requests;

-- Example: If addresses are in method-specific columns
-- SELECT id, user_id, btc_address, eth_address, bank_account FROM user_payment_methods;

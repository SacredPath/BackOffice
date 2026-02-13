-- ============================================
-- EXAMINE ACTUAL ADDRESS STRUCTURE
-- ============================================

-- 1. Check deposit_methods table structure (this likely contains admin-configured addresses)
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'deposit_methods' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Sample data from deposit_methods (admin-configured deposit addresses)
SELECT * FROM deposit_methods;

-- 3. Check withdrawal_methods table structure
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'withdrawal_methods' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 4. Sample data from withdrawal_methods
SELECT * FROM withdrawal_methods;

-- 5. Check user_withdrawal_methods structure (user's saved withdrawal addresses)
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'user_withdrawal_methods' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 6. Sample data from user_withdrawal_methods
SELECT * FROM user_withdrawal_methods;

-- 7. Check if withdrawal_details JSON contains address info
-- Since withdrawal_requests is empty, let's see the structure
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'withdrawal_requests' 
AND table_schema = 'public'
AND column_name = 'withdrawal_details';

-- 8. Check deposit_requests structure for similar JSON column
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'deposit_requests' 
AND table_schema = 'public'
AND data_type ILIKE '%json%';

-- 9. Look for any address-related columns in all tables
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_schema = 'public'
AND (
    column_name ILIKE '%address%' 
    OR column_name ILIKE '%wallet%' 
    OR column_name ILIKE '%crypto%'
    OR column_name ILIKE '%bank%'
    OR column_name ILIKE '%paypal%'
)
ORDER BY table_name, column_name;

-- 10. Check if there are any enum types for payment methods
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

-- ============================================
-- SAMPLE QUERIES FOR ADDRESS MANAGEMENT
-- ============================================

-- Example: Insert new deposit method (admin sets up addresses users see)
-- INSERT INTO deposit_methods (id, method_name, currency, address_details, is_active, created_at)
-- VALUES (
--     gen_random_uuid(), 
--     'Bitcoin', 
--     'BTC', 
--     '{"address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wl", "qr_code_url": "https://example.com/qrs/btc.png"}', 
--     true, 
--     NOW()
-- );

-- Example: Get deposit addresses for users to see
-- SELECT method_name, currency, address_details 
-- FROM deposit_methods 
-- WHERE is_active = true;

-- Example: User withdrawal request with address in JSON
-- INSERT INTO withdrawal_requests (id, user_id, currency, amount, withdrawal_details, status, created_at)
-- VALUES (
--     gen_random_uuid(),
--     'user-uuid-here',
--     'BTC',
--     0.005,
--     '{"address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wl", "network": "bitcoin"}',
--     'pending',
--     NOW()
-- );

-- ============================================
-- FINAL ADDRESS STRUCTURE QUERIES
-- ============================================

-- Based on enum types, we know:
-- deposit_method: bank, stripe, paypal, usdt_trc20
-- withdrawal_method: bank, paypal, crypto_trc20

-- 1. Check deposit_methods table structure (admin-configured addresses)
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

-- 2. Sample data from deposit_methods (addresses users will see)
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

-- 5. Check if deposit_requests has address-related columns
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'deposit_requests' 
AND table_schema = 'public'
AND (
    column_name ILIKE '%address%' 
    OR column_name ILIKE '%wallet%' 
    OR column_name ILIKE '%crypto%'
    OR column_name ILIKE '%bank%'
    OR column_name ILIKE '%paypal%'
    OR data_type ILIKE '%json%'
);

-- 6. Check withdrawal_requests withdrawal_details JSON structure
-- Even though table is empty, we can see the column structure
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'withdrawal_requests' 
AND table_schema = 'public'
AND column_name = 'withdrawal_details';

-- 7. Look for any JSON columns that might contain addresses
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public'
AND data_type ILIKE '%json%'
AND table_name IN ('deposit_methods', 'withdrawal_methods', 'deposit_requests', 'withdrawal_requests', 'user_withdrawal_methods');

-- 8. Check user_withdrawal_methods structure (user's saved withdrawal addresses)
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

-- 9. Sample data from user_withdrawal_methods
SELECT * FROM user_withdrawal_methods;

-- ============================================
-- UNDERSTANDING THE STRUCTURE
-- ============================================

-- Based on enums, the system supports:
-- DEPOSIT METHODS: bank, stripe, paypal, usdt_trc20
-- WITHDRAWAL METHODS: bank, paypal, crypto_trc20

-- deposit_methods table likely contains:
-- - method (enum: bank, stripe, paypal, usdt_trc20)
-- - currency 
-- - address_details (JSON with actual address info)
-- - is_active (boolean)
-- - created_at, updated_at

-- withdrawal_requests.withdrawal_details likely contains:
-- JSON with address info based on withdrawal_method enum

-- Example queries for your settings page integration:

-- Get current deposit methods for admin to edit
-- SELECT method, currency, address_details, is_active 
-- FROM deposit_methods;

-- Update deposit method (when admin saves settings)
-- UPDATE deposit_methods 
-- SET address_details = '{"bank_name": "Chase", "account_number": "123456789", "routing_number": "021000021"}'
-- WHERE method = 'bank' AND currency = 'USD';

-- Insert new deposit method if it doesn't exist
-- INSERT INTO deposit_methods (id, method, currency, address_details, is_active, created_at, updated_at)
-- VALUES (
--     gen_random_uuid(),
--     'paypal',
--     'USD', 
--     '{"email": "admin@company.com", "business_id": "merchant123"}',
--     true,
--     NOW(),
--     NOW()
-- ) ON CONFLICT (method, currency) DO UPDATE SET
--     address_details = EXCLUDED.address_details,
--     is_active = EXCLUDED.is_active,
--     updated_at = NOW();

-- ============================================
-- UPDATE DEPOSIT METHODS FOR SETTINGS PAGE
-- ============================================

-- Current deposit_methods structure from your database:
-- - method_type (ach, crypto, paypal)
-- - method_name (display name)
-- - currency (USD, BTC, USDT)
-- - network (TRC20, Bitcoin, null)
-- - address (crypto wallet address)
-- - bank_name, account_number, routing_number (for ACH)
-- - paypal_email, paypal_business_name (for PayPal)
-- - min_amount, max_amount (limits)
-- - fee_percentage, fixed_fee (fees)
-- - processing_time_hours
-- - instructions (user instructions)
-- - is_active (boolean)
-- - requires_verification
-- - verification_fields (JSON array)

-- ============================================
-- UPDATE EXISTING DEPOSIT METHODS
-- ============================================

-- Update ACH Bank Transfer (ID: 4428a8e7-6fcf-4efb-a8ae-9a0a7ee4fff1)
UPDATE deposit_methods 
SET 
    bank_name = 'Chase Bank',
    account_number = '123456789',
    routing_number = '021000021',
    instructions = 'Transfer funds via ACH to the bank account shown. Please include your account ID in the transfer reference. Processing time: 2-3 business days.',
    is_active = true,
    updated_at = NOW()
WHERE id = '4428a8e7-6fcf-4efb-a8ae-9a0a7ee4fff1';

-- Update USDT TRC20 (ID: deca7dab-dab0-47e5-b0b5-fac53f34c236)
UPDATE deposit_methods 
SET 
    address = 'TXxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    instructions = 'Send USDT to the TRC20 address above. Minimum deposit: 10 USDT. Processing time: 30 minutes. Please include your account ID in the transaction memo.',
    is_active = true,
    updated_at = NOW()
WHERE id = 'deca7dab-dab0-47e5-b0b5-fac53f34c236';

-- Update PayPal (ID: be31A690-7184-4ec1-9ce4-33fb73c9da30)
UPDATE deposit_methods 
SET 
    paypal_email = 'admin@yourplatform.com',
    paypal_business_name = 'Your Platform Inc',
    instructions = 'Send payment via PayPal to the email address shown. Please include your account ID in the payment notes. Processing time: 24 hours. USDT only TRC20 accepted.',
    is_active = true,
    updated_at = NOW()
WHERE id = 'be31A690-7184-4ec1-9ce4-33fb73c9da30';

-- Update Bitcoin (ID: 5ed4cf7a-9efe-45b3-8269-7a7ef715c431)
UPDATE deposit_methods 
SET 
    address = 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wl',
    instructions = 'Send Bitcoin to the Bitcoin address above. Minimum: 0.0001 BTC. Processing: 60 minutes. Please include your account ID in the transaction memo.',
    is_active = true,
    updated_at = NOW()
WHERE id = '5ed4cf7a-9efe-45b3-8269-7a7ef715c431';

-- ============================================
-- QUERY CURRENT DEPOSIT METHODS (for settings page)
-- ============================================

-- Get all deposit methods for admin to view/edit
SELECT 
    id,
    method_type,
    method_name,
    currency,
    network,
    address,
    bank_name,
    account_number,
    routing_number,
    paypal_email,
    paypal_business_name,
    min_amount::numeric,
    max_amount::numeric,
    fee_percentage::numeric,
    fixed_fee::numeric,
    processing_time_hours,
    instructions,
    is_active,
    requires_verification,
    verification_fields
FROM deposit_methods 
ORDER BY 
    CASE method_type 
        WHEN 'ach' THEN 1
        WHEN 'paypal' THEN 2
        WHEN 'crypto' THEN 3
        ELSE 4
    END,
    currency;

-- ============================================
-- SAMPLE INSERTS FOR NEW METHODS
-- ============================================

-- Example: Add Ethereum if not exists
INSERT INTO deposit_methods (
    id,
    method_type,
    method_name,
    currency,
    network,
    address,
    min_amount,
    max_amount,
    fee_percentage,
    fixed_fee,
    processing_time_hours,
    instructions,
    is_active,
    requires_verification,
    verification_fields,
    created_at,
    updated_at
) VALUES (
    gen_random_uuid(),
    'crypto',
    'Ethereum',
    'ETH',
    'ERC20',
    '0x742d35Cc6634C0532925a3b844Bc454e4438f44',
    0.001,
    50.0,
    0.001,
    0.002,
    30,
    'Send Ethereum to the ERC20 address above. Minimum: 0.001 ETH. Processing: 30 minutes. Please include your account ID in transaction memo.',
    false,
    false,
    '[]',
    NOW(),
    NOW()
);

-- Example: Add Litecoin if not exists
INSERT INTO deposit_methods (
    id,
    method_type,
    method_name,
    currency,
    network,
    address,
    min_amount,
    max_amount,
    fee_percentage,
    fixed_fee,
    processing_time_hours,
    instructions,
    is_active,
    requires_verification,
    verification_fields,
    created_at,
    updated_at
) VALUES (
    gen_random_uuid(),
    'crypto',
    'Litecoin',
    'LTC',
    'Litecoin',
    'Lxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    0.01,
    100.0,
    0.001,
    0.001,
    45,
    'Send Litecoin to the address above. Minimum: 0.01 LTC. Processing: 45 minutes. Please include your account ID in transaction memo.',
    false,
    false,
    '[]',
    NOW(),
    NOW()
);

-- ============================================
-- SETTINGS PAGE INTEGRATION
-- ============================================

-- Query to get ACH bank details for settings form
SELECT 
    id,
    bank_name,
    account_number,
    routing_number,
    min_amount::numeric,
    max_amount::numeric,
    fee_percentage::numeric,
    fixed_fee::numeric,
    processing_time_hours,
    instructions,
    is_active
FROM deposit_methods 
WHERE method_type = 'ach' AND currency = 'USD';

-- Query to get PayPal details for settings form
SELECT 
    id,
    paypal_email,
    paypal_business_name,
    min_amount::numeric,
    max_amount::numeric,
    fee_percentage::numeric,
    fixed_fee::numeric,
    processing_time_hours,
    instructions,
    is_active
FROM deposit_methods 
WHERE method_type = 'paypal' AND currency = 'USD';

-- Query to get crypto details for settings form
SELECT 
    id,
    method_name,
    currency,
    network,
    address,
    min_amount::numeric,
    max_amount::numeric,
    fee_percentage::numeric,
    fixed_fee::numeric,
    processing_time_hours,
    instructions,
    is_active
FROM deposit_methods 
WHERE method_type = 'crypto'
ORDER BY currency;

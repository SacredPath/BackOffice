-- Add admin policies for wallet_balances to allow service_role bypass
-- These policies will be in ADDITION to existing user policies

-- Allow service_role to insert wallet balances for any user
CREATE POLICY "Service role can insert any wallet balances" ON wallet_balances
    FOR INSERT
    TO service_role
    USING (true)
    WITH CHECK (true);

-- Allow service_role to update wallet balances for any user  
CREATE POLICY "Service role can update any wallet balances" ON wallet_balances
    FOR UPDATE
    TO service_role
    USING (true);

-- Allow service_role to select wallet balances for any user
CREATE POLICY "Service role can view any wallet balances" ON wallet_balances
    FOR SELECT
    TO service_role
    USING (true);

-- Verify policies were created
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

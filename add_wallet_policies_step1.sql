-- Step 1: Allow service_role to insert wallet balances for any user
CREATE POLICY "Service role can insert any wallet balances" ON wallet_balances
    FOR INSERT
    TO service_role
    USING (true)
    WITH CHECK (true);

-- Simple policy for service_role to bypass RLS on wallet_balances
CREATE POLICY "service_role_full_access" ON wallet_balances
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

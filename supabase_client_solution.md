# RLS Policy Solution for Balance Management

## Problem Analysis
The RLS policy violations are occurring because:
1. **Direct REST API approach** isn't properly handling service role context
2. **Policy precedence issues** - multiple policies conflicting
3. **Service role bypass** not working through HTTP headers

## Confirmed Working Solution
Direct SQL with service role works:
```sql
SET LOCAL ROLE service_role;
INSERT INTO wallet_balances (user_id, currency, available, locked, created_at, updated_at)
VALUES ('8c974284-3ca1-4184-83bc-7c17480d8e55', 'USD', 200.00, 0.00, NOW(), NOW())
```

## Recommended Solutions

### Option 1: Use Supabase Client Library
Replace raw fetch calls with Supabase client:
```javascript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(supabaseUrl, supabaseKey)

// Use service role for admin operations
const { data, error } = await supabase
    .from('wallet_balances')
    .upsert({
        user_id: userId,
        currency: currency,
        available: updates.available,
        locked: updates.locked
    }, {
        headers: {
            'Authorization': `Bearer ${supabaseKey}`
        }
    })
```

### Option 2: RPC Functions
Create Supabase RPC functions for admin operations:
```sql
CREATE OR REPLACE FUNCTION admin_update_wallet_balance(
    p_user_id UUID,
    p_currency TEXT,
    p_available DECIMAL,
    p_locked DECIMAL
)
RETURNS TABLE (
    id UUID,
    user_id UUID,
    currency TEXT,
    available DECIMAL,
    locked DECIMAL,
    total DECIMAL,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
BEGIN
    -- Perform update with service role privileges
    INSERT INTO wallet_balances (user_id, currency, available, locked, created_at, updated_at)
    VALUES (p_user_id, p_currency, p_available, p_locked, NOW(), NOW())
    ON CONFLICT (user_id, currency) DO UPDATE SET
        available = EXCLUDED.available,
        locked = EXCLUDED.locked,
        updated_at = NOW()
    RETURNING *;
END;
$$;
```

### Option 3: Database Function Approach
Create a dedicated admin function that bypasses RLS:
```sql
CREATE OR REPLACE FUNCTION admin_balance_operations()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Set role and perform operations
    SET LOCAL ROLE service_role;
    -- Admin operations here
    RESET ROLE;
END;
$$;
```

## Current Status
- ✅ RLS policies are correctly configured
- ✅ Service role has bypass privileges  
- ✅ Direct SQL operations work
- ❌ REST API approach failing

## Next Steps
1. Choose one of the solutions above
2. Update API to use Supabase client or RPC functions
3. Test balance management functionality
4. Remove custom headers and use standard Supabase patterns

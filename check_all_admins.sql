-- Check all admin users
SELECT email, is_active, created_at, updated_at 
FROM admin_users 
ORDER BY created_at DESC;

-- Check if admin user exists
SELECT email, is_active, created_at 
FROM admin_users 
WHERE email = 'shellymcclenny@gmail.com';

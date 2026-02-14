-- Check profiles table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'profiles' 
ORDER BY ordinal_position;

-- Check what admin users exist (try different column names)
SELECT id, email FROM profiles 
WHERE email ILIKE '%admin%' 
LIMIT 5;

-- Check audit_log table structure completely
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'audit_log' 
ORDER BY ordinal_position;

-- Check if there are any admin-related columns
SELECT column_name FROM information_schema.columns 
WHERE table_name = 'profiles' 
    AND (column_name ILIKE '%role%' OR column_name ILIKE '%admin%' OR column_name ILIKE '%type%');

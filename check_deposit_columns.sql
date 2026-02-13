-- Check exact column structure of deposit_methods table
SELECT 
    column_name,
    data_type,
    is_nullable,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'deposit_methods' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- Show sample data to understand the structure
SELECT * FROM deposit_methods LIMIT 5;

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Pages Site</title>
</head>
<body>
-- ============================================
-- FIX RLS POLICIES FOR PUBLIC ACCESS
-- Run this in Supabase SQL Editor
-- ============================================

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Public can view active products" ON products;
DROP POLICY IF EXISTS "Authenticated users can view all products" ON products;
DROP POLICY IF EXISTS "Service role can manage products" ON products;

DROP POLICY IF EXISTS "Public can view active discounts" ON discounts;
DROP POLICY IF EXISTS "Service role can manage discounts" ON discounts;

DROP POLICY IF EXISTS "Service role can manage suppliers" ON suppliers;

-- Create new permissive policies for public read access
CREATE POLICY "Allow public read access to products" ON products
  FOR SELECT USING (true);

CREATE POLICY "Allow public read access to discounts" ON discounts
  FOR SELECT USING (true);

CREATE POLICY "Allow public read access to suppliers" ON suppliers
  FOR SELECT USING (true);

-- Verify policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

</body>
</html>
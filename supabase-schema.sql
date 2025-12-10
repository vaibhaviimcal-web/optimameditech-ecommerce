<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Pages Site</title>
</head>
<body>
-- ============================================
-- OPTIMA MEDITECH E-COMMERCE DATABASE SCHEMA
-- Supabase PostgreSQL Setup
-- ============================================

-- ============================================
-- 1. PRODUCTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sku VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  stock INTEGER DEFAULT 0,
  sales INTEGER DEFAULT 0,
  rating DECIMAL(2, 1) DEFAULT 0,
  status VARCHAR(20) DEFAULT 'active',
  image_url TEXT,
  description TEXT,
  specifications JSONB,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for products
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);

-- ============================================
-- 2. CUSTOMERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS customers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20),
  total_orders INTEGER DEFAULT 0,
  total_spent DECIMAL(12, 2) DEFAULT 0,
  tier VARCHAR(20) DEFAULT 'Silver',
  last_order_date TIMESTAMP,
  address TEXT,
  city VARCHAR(100),
  state VARCHAR(100),
  pincode VARCHAR(10),
  gst_number VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for customers
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_customers_user_id ON customers(user_id);

-- ============================================
-- 3. ORDERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  order_number VARCHAR(50) UNIQUE NOT NULL,
  customer_id UUID REFERENCES customers(id) ON DELETE SET NULL,
  customer_name VARCHAR(255) NOT NULL,
  customer_email VARCHAR(255) NOT NULL,
  customer_phone VARCHAR(20),
  total_amount DECIMAL(12, 2) NOT NULL,
  payment_status VARCHAR(20) DEFAULT 'pending',
  payment_method VARCHAR(50),
  order_status VARCHAR(20) DEFAULT 'pending',
  tracking_number VARCHAR(100),
  items JSONB NOT NULL,
  shipping_address TEXT,
  billing_address TEXT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for orders
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON orders(order_number);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(order_status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at DESC);

-- ============================================
-- 4. REVIEWS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS reviews (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  customer_id UUID REFERENCES customers(id) ON DELETE SET NULL,
  customer_name VARCHAR(255) NOT NULL,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  review_text TEXT,
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for reviews
CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(status);

-- ============================================
-- 5. DISCOUNTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS discounts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  code VARCHAR(50) UNIQUE NOT NULL,
  type VARCHAR(20) NOT NULL,
  value DECIMAL(10, 2) NOT NULL,
  min_order_amount DECIMAL(10, 2) DEFAULT 0,
  max_usage INTEGER,
  current_usage INTEGER DEFAULT 0,
  valid_until TIMESTAMP,
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for discounts
CREATE INDEX IF NOT EXISTS idx_discounts_code ON discounts(code);
CREATE INDEX IF NOT EXISTS idx_discounts_status ON discounts(status);

-- ============================================
-- 6. SUPPLIERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS suppliers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  contact_person VARCHAR(255),
  email VARCHAR(255),
  phone VARCHAR(20),
  gst_number VARCHAR(50),
  payment_terms VARCHAR(100),
  status VARCHAR(20) DEFAULT 'active',
  address TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for suppliers
CREATE INDEX IF NOT EXISTS idx_suppliers_status ON suppliers(status);

-- ============================================
-- 7. SHIPMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS shipments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  tracking_number VARCHAR(100) UNIQUE NOT NULL,
  courier VARCHAR(100),
  status VARCHAR(50) DEFAULT 'processing',
  shipped_date TIMESTAMP,
  estimated_delivery TIMESTAMP,
  actual_delivery TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for shipments
CREATE INDEX IF NOT EXISTS idx_shipments_order_id ON shipments(order_id);
CREATE INDEX IF NOT EXISTS idx_shipments_tracking ON shipments(tracking_number);
CREATE INDEX IF NOT EXISTS idx_shipments_status ON shipments(status);

-- ============================================
-- 8. ENABLE ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE discounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipments ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 9. RLS POLICIES - PRODUCTS
-- ============================================

-- Public can view active products
CREATE POLICY "Public can view active products" ON products
  FOR SELECT USING (status = 'active');

-- Authenticated users can view all products
CREATE POLICY "Authenticated users can view all products" ON products
  FOR SELECT USING (auth.role() = 'authenticated');

-- Service role can manage products (for admin operations)
CREATE POLICY "Service role can manage products" ON products
  FOR ALL USING (auth.role() = 'service_role');

-- ============================================
-- 10. RLS POLICIES - CUSTOMERS
-- ============================================

-- Users can view their own customer record
CREATE POLICY "Users can view own customer record" ON customers
  FOR SELECT USING (auth.uid() = user_id);

-- Users can update their own customer record
CREATE POLICY "Users can update own customer record" ON customers
  FOR UPDATE USING (auth.uid() = user_id);

-- Service role can manage all customers
CREATE POLICY "Service role can manage customers" ON customers
  FOR ALL USING (auth.role() = 'service_role');

-- ============================================
-- 11. RLS POLICIES - ORDERS
-- ============================================

-- Users can view their own orders
CREATE POLICY "Users can view own orders" ON orders
  FOR SELECT USING (
    auth.uid() IN (
      SELECT user_id FROM customers WHERE id = orders.customer_id
    )
  );

-- Users can create orders
CREATE POLICY "Users can create orders" ON orders
  FOR INSERT WITH CHECK (
    auth.uid() IN (
      SELECT user_id FROM customers WHERE id = orders.customer_id
    )
  );

-- Service role can manage all orders
CREATE POLICY "Service role can manage orders" ON orders
  FOR ALL USING (auth.role() = 'service_role');

-- ============================================
-- 12. RLS POLICIES - REVIEWS
-- ============================================

-- Public can view approved reviews
CREATE POLICY "Public can view approved reviews" ON reviews
  FOR SELECT USING (status = 'approved');

-- Users can create reviews
CREATE POLICY "Users can create reviews" ON reviews
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Service role can manage all reviews
CREATE POLICY "Service role can manage reviews" ON reviews
  FOR ALL USING (auth.role() = 'service_role');

-- ============================================
-- 13. RLS POLICIES - DISCOUNTS
-- ============================================

-- Public can view active discounts
CREATE POLICY "Public can view active discounts" ON discounts
  FOR SELECT USING (status = 'active' AND valid_until > NOW());

-- Service role can manage discounts
CREATE POLICY "Service role can manage discounts" ON discounts
  FOR ALL USING (auth.role() = 'service_role');

-- ============================================
-- 14. RLS POLICIES - SUPPLIERS
-- ============================================

-- Service role only can access suppliers
CREATE POLICY "Service role can manage suppliers" ON suppliers
  FOR ALL USING (auth.role() = 'service_role');

-- ============================================
-- 15. RLS POLICIES - SHIPMENTS
-- ============================================

-- Users can view shipments for their orders
CREATE POLICY "Users can view own shipments" ON shipments
  FOR SELECT USING (
    order_id IN (
      SELECT id FROM orders WHERE customer_id IN (
        SELECT id FROM customers WHERE user_id = auth.uid()
      )
    )
  );

-- Service role can manage all shipments
CREATE POLICY "Service role can manage shipments" ON shipments
  FOR ALL USING (auth.role() = 'service_role');

-- ============================================
-- 16. FUNCTIONS - AUTO UPDATE TIMESTAMP
-- ============================================

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to all tables
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON customers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_discounts_updated_at BEFORE UPDATE ON discounts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_suppliers_updated_at BEFORE UPDATE ON suppliers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_shipments_updated_at BEFORE UPDATE ON shipments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 17. SAMPLE DATA (OPTIONAL - FOR TESTING)
-- ============================================

-- Insert sample products
INSERT INTO products (sku, name, category, price, stock, sales, rating, status, image_url, description) VALUES
('PM-2024-001', 'Multi-Parameter Patient Monitor', 'Patient Monitoring', 245000, 15, 45, 4.9, 'active', 'https://images.unsplash.com/photo-1631217868264-e5b90bb7e133?w=500', 'Advanced patient monitoring system with multi-parameter display'),
('US-2024-002', 'Color Doppler Ultrasound', 'Diagnostic Imaging', 850000, 8, 23, 4.8, 'active', 'https://images.unsplash.com/photo-1579154204601-01588f351e67?w=500', 'High-resolution color doppler ultrasound machine'),
('VT-2024-003', 'ICU Ventilator', 'Emergency Care', 1250000, 5, 18, 5.0, 'active', 'https://images.unsplash.com/photo-1583911860205-72f8ac8ddcbe?w=500', 'Advanced ICU ventilator with multiple modes')
ON CONFLICT (sku) DO NOTHING;

-- Insert sample discounts
INSERT INTO discounts (code, type, value, min_order_amount, max_usage, current_usage, valid_until, status) VALUES
('WELCOME10', 'percentage', 10, 100000, 100, 5, '2024-12-31 23:59:59', 'active'),
('BULK20', 'percentage', 20, 500000, 50, 12, '2024-12-31 23:59:59', 'active'),
('NEWYEAR2025', 'fixed', 50000, 1000000, 25, 0, '2025-01-15 23:59:59', 'active')
ON CONFLICT (code) DO NOTHING;

-- ============================================
-- SETUP COMPLETE!
-- ============================================

-- Verify tables created
SELECT 
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE'
ORDER BY table_name;
</body>
</html>
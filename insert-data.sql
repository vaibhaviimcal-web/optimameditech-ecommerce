<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Pages Site</title>
</head>
<body>
-- ============================================
-- INSERT SAMPLE DATA FOR OPTIMA MEDITECH
-- Run this in Supabase SQL Editor
-- ============================================

-- Temporarily disable RLS for data insertion
ALTER TABLE products DISABLE ROW LEVEL SECURITY;
ALTER TABLE discounts DISABLE ROW LEVEL SECURITY;
ALTER TABLE suppliers DISABLE ROW LEVEL SECURITY;

-- ============================================
-- INSERT PRODUCTS
-- ============================================
INSERT INTO products (sku, name, category, price, stock, sales, rating, status, image_url, description) VALUES
('PM-2024-001', 'Multi-Parameter Patient Monitor', 'Patient Monitoring', 245000, 15, 45, 4.9, 'active', 'https://images.unsplash.com/photo-1631217868264-e5b90bb7e133?w=500', 'Advanced patient monitoring system with multi-parameter display'),
('US-2024-002', 'Color Doppler Ultrasound', 'Diagnostic Imaging', 850000, 8, 23, 4.8, 'active', 'https://images.unsplash.com/photo-1579154204601-01588f351e67?w=500', 'High-resolution color doppler ultrasound machine'),
('VT-2024-003', 'ICU Ventilator', 'Emergency Care', 1250000, 5, 18, 5.0, 'active', 'https://images.unsplash.com/photo-1583911860205-72f8ac8ddcbe?w=500', 'Advanced ICU ventilator with multiple modes'),
('XR-2024-004', 'Digital X-Ray System', 'Diagnostic Imaging', 1575000, 3, 12, 4.9, 'active', 'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=500', 'High-resolution digital X-ray imaging system'),
('OT-2024-005', 'Electric Operating Table', 'OT Equipment', 325000, 12, 34, 4.7, 'active', 'https://images.unsplash.com/photo-1551601651-2a8555f1a136?w=500', 'Fully electric operating table with multiple positions'),
('EC-2024-006', '12-Channel ECG Machine', 'Cardiology', 185000, 20, 56, 4.9, 'active', 'https://images.unsplash.com/photo-1530497610245-94d3c16cda28?w=500', 'Advanced 12-channel ECG machine with interpretation'),
('IP-2024-007', 'Syringe Infusion Pump', 'Emergency Care', 95000, 25, 67, 4.8, 'active', 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=500', 'Precision syringe infusion pump with alarm system'),
('DF-2024-008', 'Automated Defibrillator', 'Emergency Care', 450000, 10, 28, 5.0, 'active', 'https://images.unsplash.com/photo-1582719471384-894fbb16e074?w=500', 'Automated external defibrillator with voice prompts'),
('SL-2024-009', 'LED Surgical Lights', 'OT Equipment', 275000, 8, 19, 4.8, 'active', 'https://images.unsplash.com/photo-1581594549595-35f6edc7b762?w=500', 'High-intensity LED surgical lights with shadow reduction'),
('BP-2024-010', 'Digital BP Monitor', 'Patient Monitoring', 45000, 50, 120, 4.6, 'active', 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?w=500', 'Automatic digital blood pressure monitor')
ON CONFLICT (sku) DO NOTHING;

-- ============================================
-- INSERT DISCOUNTS
-- ============================================
INSERT INTO discounts (code, type, value, min_order_amount, max_usage, current_usage, valid_until, status) VALUES
('WELCOME10', 'percentage', 10, 100000, 100, 5, '2024-12-31 23:59:59', 'active'),
('BULK20', 'percentage', 20, 500000, 50, 12, '2024-12-31 23:59:59', 'active'),
('NEWYEAR2025', 'fixed', 50000, 1000000, 25, 0, '2025-01-15 23:59:59', 'active')
ON CONFLICT (code) DO NOTHING;

-- ============================================
-- INSERT SUPPLIERS
-- ============================================
INSERT INTO suppliers (name, contact_person, email, phone, gst_number, payment_terms, status, address) VALUES
('MedTech Solutions Pvt Ltd', 'Ramesh Gupta', 'ramesh@medtech.com', '+91 98765 11111', '27AABCU9603R1ZM', 'Net 30', 'active', 'Mumbai, Maharashtra'),
('Global Medical Devices', 'Sarah Johnson', 'sarah@globalmed.com', '+91 98765 22222', '29AABCU9603R1ZN', 'Net 45', 'active', 'Bangalore, Karnataka'),
('Healthcare Equipment India', 'Vikram Singh', 'vikram@healthcare.in', '+91 98765 33333', '07AABCU9603R1ZO', 'Net 60', 'active', 'Delhi, NCR')
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- RE-ENABLE RLS
-- ============================================
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE discounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;

-- ============================================
-- VERIFY DATA INSERTED
-- ============================================
SELECT 'Products' as table_name, COUNT(*) as count FROM products
UNION ALL
SELECT 'Discounts', COUNT(*) FROM discounts
UNION ALL
SELECT 'Suppliers', COUNT(*) FROM suppliers;

-- ============================================
-- DONE! You should see:
-- Products: 10
-- Discounts: 3
-- Suppliers: 3
-- ============================================
</body>
</html>
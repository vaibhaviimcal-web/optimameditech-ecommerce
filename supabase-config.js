<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Pages Site</title>
</head>
<body>
// ============================================
// SUPABASE CONFIGURATION
// Optima Meditech E-Commerce Platform
// ============================================

// Supabase Project Credentials
const SUPABASE_URL = 'https://lloiwbkgfsxdhjohfuwd.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_u6C2SMG2JM42-wDl33iS6w_GqUqaoTb';

// Initialize Supabase Client
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// ============================================
// HELPER FUNCTIONS
// ============================================

// Check if user is authenticated
async function isAuthenticated() {
    const { data: { user } } = await supabase.auth.getUser();
    return user !== null;
}

// Get current user
async function getCurrentUser() {
    const { data: { user } } = await supabase.auth.getUser();
    return user;
}

// ============================================
// PRODUCTS FUNCTIONS
// ============================================

// Get all active products
async function getProducts() {
    const { data, error } = await supabase
        .from('products')
        .select('*')
        .eq('status', 'active')
        .order('created_at', { ascending: false });
    
    if (error) {
        console.error('Error fetching products:', error);
        return [];
    }
    return data;
}

// Get product by ID
async function getProductById(id) {
    const { data, error } = await supabase
        .from('products')
        .select('*')
        .eq('id', id)
        .single();
    
    if (error) {
        console.error('Error fetching product:', error);
        return null;
    }
    return data;
}

// Get products by category
async function getProductsByCategory(category) {
    const { data, error } = await supabase
        .from('products')
        .select('*')
        .eq('category', category)
        .eq('status', 'active')
        .order('created_at', { ascending: false });
    
    if (error) {
        console.error('Error fetching products:', error);
        return [];
    }
    return data;
}

// Search products
async function searchProducts(query) {
    const { data, error } = await supabase
        .from('products')
        .select('*')
        .or(`name.ilike.%${query}%,description.ilike.%${query}%`)
        .eq('status', 'active');
    
    if (error) {
        console.error('Error searching products:', error);
        return [];
    }
    return data;
}

// ============================================
// ORDERS FUNCTIONS
// ============================================

// Create new order
async function createOrder(orderData) {
    const { data, error } = await supabase
        .from('orders')
        .insert([orderData])
        .select()
        .single();
    
    if (error) {
        console.error('Error creating order:', error);
        return null;
    }
    return data;
}

// Get orders by customer
async function getOrdersByCustomer(customerId) {
    const { data, error } = await supabase
        .from('orders')
        .select('*')
        .eq('customer_id', customerId)
        .order('created_at', { ascending: false });
    
    if (error) {
        console.error('Error fetching orders:', error);
        return [];
    }
    return data;
}

// Get all orders (admin only)
async function getAllOrders() {
    const { data, error } = await supabase
        .from('orders')
        .select('*')
        .order('created_at', { ascending: false });
    
    if (error) {
        console.error('Error fetching orders:', error);
        return [];
    }
    return data;
}

// Update order status
async function updateOrderStatus(orderId, status) {
    const { data, error } = await supabase
        .from('orders')
        .update({ order_status: status })
        .eq('id', orderId)
        .select()
        .single();
    
    if (error) {
        console.error('Error updating order:', error);
        return null;
    }
    return data;
}

// ============================================
// CUSTOMERS FUNCTIONS
// ============================================

// Create customer profile
async function createCustomer(customerData) {
    const { data, error } = await supabase
        .from('customers')
        .insert([customerData])
        .select()
        .single();
    
    if (error) {
        console.error('Error creating customer:', error);
        return null;
    }
    return data;
}

// Get customer by user ID
async function getCustomerByUserId(userId) {
    const { data, error } = await supabase
        .from('customers')
        .select('*')
        .eq('user_id', userId)
        .single();
    
    if (error) {
        console.error('Error fetching customer:', error);
        return null;
    }
    return data;
}

// Update customer profile
async function updateCustomer(customerId, updates) {
    const { data, error } = await supabase
        .from('customers')
        .update(updates)
        .eq('id', customerId)
        .select()
        .single();
    
    if (error) {
        console.error('Error updating customer:', error);
        return null;
    }
    return data;
}

// ============================================
// REVIEWS FUNCTIONS
// ============================================

// Get reviews for product
async function getProductReviews(productId) {
    const { data, error } = await supabase
        .from('reviews')
        .select('*')
        .eq('product_id', productId)
        .eq('status', 'approved')
        .order('created_at', { ascending: false });
    
    if (error) {
        console.error('Error fetching reviews:', error);
        return [];
    }
    return data;
}

// Create review
async function createReview(reviewData) {
    const { data, error } = await supabase
        .from('reviews')
        .insert([reviewData])
        .select()
        .single();
    
    if (error) {
        console.error('Error creating review:', error);
        return null;
    }
    return data;
}

// ============================================
// DISCOUNTS FUNCTIONS
// ============================================

// Get active discounts
async function getActiveDiscounts() {
    const { data, error } = await supabase
        .from('discounts')
        .select('*')
        .eq('status', 'active')
        .gte('valid_until', new Date().toISOString());
    
    if (error) {
        console.error('Error fetching discounts:', error);
        return [];
    }
    return data;
}

// Validate discount code
async function validateDiscountCode(code) {
    const { data, error } = await supabase
        .from('discounts')
        .select('*')
        .eq('code', code)
        .eq('status', 'active')
        .gte('valid_until', new Date().toISOString())
        .single();
    
    if (error) {
        console.error('Error validating discount:', error);
        return null;
    }
    return data;
}

// ============================================
// AUTHENTICATION FUNCTIONS
// ============================================

// Sign up new user
async function signUp(email, password, userData) {
    const { data, error } = await supabase.auth.signUp({
        email: email,
        password: password,
        options: {
            data: userData
        }
    });
    
    if (error) {
        console.error('Error signing up:', error);
        return { success: false, error: error.message };
    }
    return { success: true, user: data.user };
}

// Sign in user
async function signIn(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({
        email: email,
        password: password
    });
    
    if (error) {
        console.error('Error signing in:', error);
        return { success: false, error: error.message };
    }
    return { success: true, user: data.user };
}

// Sign out user
async function signOut() {
    const { error } = await supabase.auth.signOut();
    
    if (error) {
        console.error('Error signing out:', error);
        return { success: false, error: error.message };
    }
    return { success: true };
}

// Reset password
async function resetPassword(email) {
    const { data, error } = await supabase.auth.resetPasswordForEmail(email);
    
    if (error) {
        console.error('Error resetting password:', error);
        return { success: false, error: error.message };
    }
    return { success: true };
}

// ============================================
// STORAGE FUNCTIONS
// ============================================

// Upload product image
async function uploadProductImage(file) {
    const fileName = `${Date.now()}_${file.name}`;
    const { data, error } = await supabase.storage
        .from('product-images')
        .upload(fileName, file);
    
    if (error) {
        console.error('Error uploading image:', error);
        return null;
    }
    
    // Get public URL
    const { data: { publicUrl } } = supabase.storage
        .from('product-images')
        .getPublicUrl(fileName);
    
    return publicUrl;
}

// ============================================
// ANALYTICS FUNCTIONS
// ============================================

// Get dashboard analytics
async function getDashboardAnalytics() {
    try {
        // Get total revenue
        const { data: orders } = await supabase
            .from('orders')
            .select('total_amount, order_status');
        
        const totalRevenue = orders
            ?.filter(o => o.order_status !== 'cancelled')
            .reduce((sum, o) => sum + parseFloat(o.total_amount), 0) || 0;
        
        // Get total orders
        const totalOrders = orders?.length || 0;
        
        // Get total products
        const { count: totalProducts } = await supabase
            .from('products')
            .select('*', { count: 'exact', head: true });
        
        // Get total customers
        const { count: totalCustomers } = await supabase
            .from('customers')
            .select('*', { count: 'exact', head: true });
        
        // Get pending orders
        const pendingOrders = orders?.filter(o => o.order_status === 'pending').length || 0;
        
        // Get low stock items
        const { data: lowStock } = await supabase
            .from('products')
            .select('*')
            .lte('stock', 10);
        
        return {
            totalRevenue,
            totalOrders,
            totalProducts: totalProducts || 0,
            totalCustomers: totalCustomers || 0,
            pendingOrders,
            lowStockItems: lowStock?.length || 0,
            avgOrderValue: totalOrders > 0 ? totalRevenue / totalOrders : 0
        };
    } catch (error) {
        console.error('Error fetching analytics:', error);
        return {
            totalRevenue: 0,
            totalOrders: 0,
            totalProducts: 0,
            totalCustomers: 0,
            pendingOrders: 0,
            lowStockItems: 0,
            avgOrderValue: 0
        };
    }
}

// ============================================
// EXPORT FUNCTIONS
// ============================================

console.log('✅ Supabase configuration loaded successfully!');
console.log('📊 Project URL:', SUPABASE_URL);
console.log('🔑 Using publishable key');

</body>
</html>
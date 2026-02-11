CREATE TABLE IF NOT EXISTS Countries ( country_id TINYINT PRIMARY KEY AUTO_INCREMENT, country_code CHAR(2) NOT NULL UNIQUE, country_name VARCHAR(80) NOT NULL ); 
INSERT INTO Countries (country_code, country_name) VALUES ('IN', 'India'), ('US', 'United States'), ('GB', 'United Kingdom');

CREATE TABLE IF NOT EXISTS States ( state_id SMALLINT PRIMARY KEY AUTO_INCREMENT, country_id TINYINT NOT NULL, state_name VARCHAR(80) NOT NULL, state_code VARCHAR(5) NOT NULL, 
FOREIGN KEY (country_id) REFERENCES Countries(country_id), 
UNIQUE (country_id, state_code) 
 
); 
INSERT INTO States (country_id, state_name, state_code) VALUES (1, 'Karnataka', 'KA'), (1, 'Maharashtra', 'MH'), (1, 'Tamil Nadu', 'TN'), (1, 'Delhi', 'DL'), (1, 'Telangana', 'TS');  


CREATE TABLE IF NOT EXISTS Cities ( city_id INT PRIMARY KEY AUTO_INCREMENT, state_id SMALLINT NOT NULL, city_name VARCHAR(100) NOT NULL, city_code VARCHAR(10) NULL, center_lat DECIMAL(9,6) NULL, center_lng DECIMAL(9,6) NULL, radius_km DECIMAL(6,2) NULL, is_serviceable BOOLEAN DEFAULT FALSE, launch_date DATE NULL, 
UNIQUE (state_id, city_name), 
FOREIGN KEY (state_id) REFERENCES States(state_id), 
INDEX idx_city_serviceable (is_serviceable) 
 
); 
INSERT INTO Cities (state_id, city_name, city_code, center_lat, center_lng, is_serviceable) VALUES (1, 'Bangalore', 'BLR', 12.971599, 77.594566, TRUE), (2, 'Mumbai', 'MUM', 19.076090, 72.877426, TRUE), (2, 'Pune', 'PNQ', 18.520430, 73.856743, TRUE), (3, 'Chennai', 'CHE', 13.082680, 80.270718, TRUE), (4, 'Delhi', 'DEL', 28.613939, 77.209023, TRUE), (5, 'Hyderabad', 'HYD', 17.385044, 78.486671, TRUE);


CREATE TABLE IF NOT EXISTS Customers ( customer_id BIGINT PRIMARY KEY AUTO_INCREMENT, email VARCHAR(100) NOT NULL UNIQUE, phone VARCHAR(20) NOT NULL UNIQUE, full_name VARCHAR(100) NOT NULL, date_of_birth DATE NULL, password_hash CHAR(64) NOT NULL, loyalty_points INT DEFAULT 0, loyalty_tier ENUM('Bronze','Silver','Gold','Platinum') DEFAULT 'Bronze', is_active BOOLEAN DEFAULT TRUE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ); 
INSERT INTO Customers (email, phone, full_name, password_hash) VALUES ('priya@gmail.com', '9876543210', 'Priya Sharma', 'a3f5c9d2e1b8f4a7c6d9e2b5f8a1c4d7e0b3f6a9c2d5e8b1'), ('raj@gmail.com', '9876543211', 'Raj Patel', 'b4g6d0e2c9f5b8e1d4g7c0f3e6b9d2g5c8f1e4b7d0g3f6'), ('ananya@gmail.com', '9876543212', 'Ananya Singh', 'c5h7e1f3d0g6c9f2e5h8d1g4f7c0e3h6d9g2f5c8e1h4g7');  



CREATE TABLE IF NOT EXISTS Customer_Wallets ( wallet_id BIGINT PRIMARY KEY AUTO_INCREMENT, customer_id BIGINT NOT NULL UNIQUE, -- UNIQUE enforces 1:1 
balance DECIMAL(12,2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0), -- Can NEVER go negative 
currency CHAR(3) NOT NULL DEFAULT 'INR', total_credited DECIMAL(14,2) DEFAULT 0.00, total_spent DECIMAL(14,2) DEFAULT 0.00, total_refunded DECIMAL(14,2) DEFAULT 0.00, is_active BOOLEAN DEFAULT TRUE, is_frozen BOOLEAN DEFAULT FALSE, -- Fraud lockout 
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, last_transaction TIMESTAMP NULL, 
CONSTRAINT fk_wallet_customer 
   FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) 
   ON DELETE CASCADE 
 
); 
INSERT INTO Customer_Wallets (customer_id, balance, total_credited, total_spent) VALUES (1, 1850.00, 3000.00, 1150.00), (2, 500.00, 500.00, 0.00), (3, 0.00, 200.00, 200.00);




CREATE TABLE IF NOT EXISTS Restaurants ( restaurant_id INT PRIMARY KEY AUTO_INCREMENT, restaurant_name VARCHAR(150) NOT NULL, owner_name VARCHAR(100) NOT NULL, fssai_license VARCHAR(20) UNIQUE NOT NULL, phone VARCHAR(15) NOT NULL, address VARCHAR(300) NOT NULL, city_id INT NOT NULL, avg_rating DECIMAL(3,2) DEFAULT 0.00, avg_delivery_mins INT DEFAULT 30, min_order_amount DECIMAL(8,2) DEFAULT 0.00, is_open BOOLEAN DEFAULT FALSE, opening_time TIME NULL, closing_time TIME NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
FOREIGN KEY (city_id) REFERENCES Cities(city_id), 
INDEX idx_restaurant_city   (city_id), 
INDEX idx_restaurant_rating (avg_rating) 
 
); 
INSERT INTO Restaurants (restaurant_name, owner_name, fssai_license, phone, address, city_id, avg_rating, is_open) VALUES ("Domino's Pizza", 'Jubilant FoodWorks', 'FSSAI001', '080-12345678', 'MG Road, Bangalore', 1, 4.20, TRUE), ("McDonald's", 'Hardcastle Rest.', 'FSSAI002', '080-23456789', 'Brigade Road, Bangalore', 1, 4.10, TRUE), ('Biryani Blues', 'Blue Foods Pvt Ltd', 'FSSAI003', '080-34567890', 'Koramangala, Bangalore', 1, 4.50, TRUE), ('KFC', 'Devyani Intl.', 'FSSAI004', '022-12345678', 'Bandra, Mumbai', 2, 4.00, TRUE);  



CREATE TABLE IF NOT EXISTS Delivery_Partners ( partner_id INT PRIMARY KEY AUTO_INCREMENT, full_name VARCHAR(100) NOT NULL, phone VARCHAR(15) NOT NULL UNIQUE, vehicle_number VARCHAR(15) NOT NULL UNIQUE, vehicle_type ENUM('Bike','Scooter','Car') NOT NULL, license_number VARCHAR(20) NOT NULL UNIQUE, avg_rating DECIMAL(3,2) DEFAULT 0.00, total_deliveries INT DEFAULT 0, is_available BOOLEAN DEFAULT FALSE, current_lat DECIMAL(10,7) NULL, current_lng DECIMAL(10,7) NULL, joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ); 
INSERT INTO Delivery_Partners (full_name, phone, vehicle_number, vehicle_type, license_number, avg_rating) VALUES ('Ravi Kumar', '9000000001', 'KA01AB1234', 'Bike', 'KA-DL-00001', 4.70), ('Suresh Babu', '9000000002', 'KA02CD5678', 'Scooter', 'KA-DL-00002', 4.50), ('Mohan Rao', '9000000003', 'MH03EF9012', 'Bike', 'MH-DL-00003', 4.80); 



CREATE TABLE IF NOT EXISTS Customer_Addresses ( address_id BIGINT PRIMARY KEY AUTO_INCREMENT, customer_id BIGINT NOT NULL, label ENUM('Home','Work','Other') DEFAULT 'Home', address_line1 VARCHAR(200) NOT NULL, address_line2 VARCHAR(200) NULL, city_id INT NOT NULL, pincode CHAR(6) NOT NULL, latitude DECIMAL(10,7) NULL, longitude DECIMAL(10,7) NULL, is_default BOOLEAN DEFAULT FALSE, 
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE, 
FOREIGN KEY (city_id)     REFERENCES Cities(city_id), 
INDEX idx_ca_customer (customer_id) 
 
); 
INSERT INTO Customer_Addresses (customer_id, label, address_line1, city_id, pincode, is_default) VALUES (1, 'Home', 'Flat 4B, Sunrise Apts, MG Road', 1, '560001', TRUE), (1, 'Work', '3rd Floor, Tech Park, Whitefield', 1, '560066', FALSE), (2, 'Home', 'B-12, Shree Apartments, Andheri West', 2, '400053', TRUE);





CREATE TABLE IF NOT EXISTS Menu_Categories ( category_id INT PRIMARY KEY AUTO_INCREMENT, restaurant_id INT NOT NULL, category_name VARCHAR(100) NOT NULL, description TEXT NULL, display_order INT DEFAULT 0, is_active BOOLEAN DEFAULT TRUE, 
FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE 
 
); 
INSERT INTO Menu_Categories (restaurant_id, category_name, display_order) VALUES (1, 'Pizzas', 1), (1, 'Sides & Extras', 2), (1, 'Beverages', 3), (2, 'Burgers', 1), (2, 'Wraps', 2), (3, 'Biryani', 1), (3, 'Starters', 2);  




CREATE TABLE IF NOT EXISTS Menu_Items ( item_id INT PRIMARY KEY AUTO_INCREMENT, restaurant_id INT NOT NULL, category_id INT NOT NULL, item_name VARCHAR(150) NOT NULL, description TEXT NULL, price DECIMAL(8,2) NOT NULL CHECK (price >= 0), food_type ENUM('Veg','NonVeg','Egg') NOT NULL, calories INT NULL, prep_time_mins INT DEFAULT 15, is_available BOOLEAN DEFAULT TRUE, image_url VARCHAR(300) NULL, 
FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id), 
FOREIGN KEY (category_id)   REFERENCES Menu_Categories(category_id), 
INDEX idx_mi_restaurant (restaurant_id), 
INDEX idx_mi_food_type  (food_type) 
 
); 
INSERT INTO Menu_Items (restaurant_id, category_id, item_name, price, food_type, prep_time_mins) VALUES (1, 1, 'Margherita Pizza', 250.00, 'Veg', 20), (1, 1, 'Pepperoni Pizza', 320.00, 'NonVeg', 22), (1, 1, 'BBQ Chicken Pizza', 350.00, 'NonVeg', 22), (1, 2, 'Garlic Bread', 150.00, 'Veg', 10), (1, 2, 'Stuffed Garlic Bread', 180.00, 'Veg', 12), (1, 3, 'Coke 500ml', 60.00, 'Veg', 2), (2, 4, 'McAloo Tikki Burger', 100.00, 'Veg', 10), (2, 4, 'McChicken Burger', 150.00, 'NonVeg', 12), (3, 6, 'Chicken Biryani', 280.00, 'NonVeg', 25), (3, 6, 'Veg Biryani', 220.00, 'Veg', 20);





CREATE TABLE IF NOT EXISTS Coupons ( coupon_id INT PRIMARY KEY AUTO_INCREMENT, coupon_code VARCHAR(20) NOT NULL UNIQUE, description VARCHAR(255) NOT NULL, discount_type ENUM('flat','percentage') NOT NULL, discount_value DECIMAL(8,2) NOT NULL CHECK (discount_value > 0), max_discount DECIMAL(8,2) NULL, -- Cap for percentage type 
min_order_value DECIMAL(8,2) DEFAULT 0.00, valid_from DATETIME NOT NULL, valid_until DATETIME NOT NULL, max_uses INT NULL, -- NULL = unlimited 
current_uses INT DEFAULT 0, max_uses_per_user TINYINT DEFAULT 1, applicable_to ENUM('all','new_users','specific_restaurant') DEFAULT 'all', restaurant_id INT NULL, is_active BOOLEAN DEFAULT TRUE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
CONSTRAINT chk_coupon_dates   CHECK (valid_until > valid_from), 
CONSTRAINT chk_coupon_uses    CHECK (max_uses IS NULL OR current_uses <= max_uses), 
CONSTRAINT chk_pct_range      CHECK (discount_type = 'flat' OR discount_value <= 100), 
 
FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE SET NULL, 
INDEX idx_coupon_code   (coupon_code), 
INDEX idx_coupon_active (is_active, valid_until) 
 
); 
INSERT INTO Coupons (coupon_code, description, discount_type, discount_value, max_discount, min_order_value, valid_from, valid_until, max_uses, applicable_to) VALUES ('WELCOME50', '50% off your first order, max ₹150', 'percentage', 50.00, 150.00, 199.00, '2024-01-01', '2024-12-31', NULL, 'new_users'), ('FLAT100', '₹100 flat off on orders above ₹499', 'flat', 100.00, NULL, 499.00, '2024-02-01', '2024-02-29', 5000, 'all'), ('WEEKEND30', '30% off on weekends, max ₹200', 'percentage', 30.00, 200.00, 399.00, '2024-01-01', '2024-12-31', NULL, 'all'); 






CREATE TABLE IF NOT EXISTS Orders ( order_id BIGINT PRIMARY KEY AUTO_INCREMENT, customer_id BIGINT NOT NULL, restaurant_id INT NOT NULL, delivery_address_id BIGINT NOT NULL, coupon_id INT NULL, order_status ENUM('placed','confirmed','preparing','out_for_delivery','delivered','cancelled') DEFAULT 'placed', subtotal DECIMAL(10,2) NOT NULL, delivery_fee DECIMAL(6,2) DEFAULT 0.00, discount_amount DECIMAL(8,2) DEFAULT 0.00, tax_amount DECIMAL(8,2) DEFAULT 0.00, total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount > 0), special_instructions TEXT NULL, placed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, estimated_delivery TIMESTAMP NULL, 
FOREIGN KEY (customer_id)          REFERENCES Customers(customer_id), 
FOREIGN KEY (restaurant_id)        REFERENCES Restaurants(restaurant_id), 
FOREIGN KEY (delivery_address_id)  REFERENCES Customer_Addresses(address_id), 
FOREIGN KEY (coupon_id)            REFERENCES Coupons(coupon_id) ON DELETE SET NULL, 
 
INDEX idx_order_customer    (customer_id), 
INDEX idx_order_restaurant  (restaurant_id), 
INDEX idx_order_status      (order_status), 
INDEX idx_order_placed_at   (placed_at) 
 
); 
INSERT INTO Orders (customer_id, restaurant_id, delivery_address_id, order_status, subtotal, delivery_fee, total_amount) VALUES (1, 1, 1, 'delivered', 650.00, 40.00, 690.00), (1, 2, 1, 'delivered', 410.00, 40.00, 450.00), (2, 3, 3, 'placed', 280.00, 30.00, 310.00), (3, 1, 1, 'cancelled', 500.00, 40.00, 540.00); 








CREATE TABLE IF NOT EXISTS Order_Items ( order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT, 
-- Foreign Keys 
order_id         BIGINT        NOT NULL, 
item_id          INT           NOT NULL, 
 
-- Quantity & Price Snapshot 
quantity         INT           NOT NULL CHECK (quantity >= 1), 
unit_price       DECIMAL(8,2)  NOT NULL CHECK (unit_price >= 0), 
item_total       DECIMAL(10,2) NOT NULL,          -- quantity × unit_price 
 
-- Customization Notes 
customization    TEXT          NULL,               -- "Extra cheese, no onions" 
 
-- Promo / Complimentary Flag 
is_complimentary BOOLEAN       DEFAULT FALSE,      -- Free item (from promo) 
 
-- Audit 
created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP, 
 
-- Constraint: item_total must equal quantity × unit_price 
-- (unless complimentary, then price is 0) 
CONSTRAINT chk_item_total 
   CHECK (is_complimentary = TRUE OR item_total = quantity * unit_price), 
 
-- Foreign Key Relationships 
CONSTRAINT fk_oi_order 
   FOREIGN KEY (order_id) 
   REFERENCES Orders(order_id) 
   ON DELETE CASCADE,           -- Delete order → delete its items 
 
CONSTRAINT fk_oi_item 
   FOREIGN KEY (item_id) 
   REFERENCES Menu_Items(item_id) 
   ON DELETE RESTRICT,          -- Cannot delete menu item that has orders 
 
-- Indexes 
INDEX idx_oi_order (order_id), 
INDEX idx_oi_item  (item_id) 
 
); 
-- Sample Data 
INSERT INTO Order_Items (order_id, item_id, quantity, unit_price, item_total, customization) VALUES -- Order 8821: 2x Margherita + 1x Garlic Bread + 1x Coke (1, 1, 2, 250.00, 500.00, 'Extra cheese on one pizza'), (1, 4, 1, 150.00, 150.00, NULL), 
-- Order 8822: McAloo + McChicken 
(2, 7, 1, 100.00, 100.00, 'No onions'), 
(2, 8, 1, 150.00, 150.00, NULL), 
(2, 6, 2,  60.00, 120.00, NULL), 
 
-- Order 8823: Biryani 
(3, 9, 1, 280.00, 280.00, 'Extra raita please'); 









CREATE TABLE IF NOT EXISTS Order_Status_History ( history_id BIGINT PRIMARY KEY AUTO_INCREMENT, 
-- Foreign Key 
order_id         BIGINT    NOT NULL, 
 
-- Status Transition (before and after) 
previous_status  ENUM('placed','confirmed','preparing','out_for_delivery','delivered','cancelled') 
                         NULL,     -- NULL for the initial 'placed' entry 
new_status       ENUM('placed','confirmed','preparing','out_for_delivery','delivered','cancelled') 
                         NOT NULL, 
 
-- Who changed it 
changed_by_type  ENUM('system','restaurant','rider','customer','admin') NOT NULL, 
changed_by_id    BIGINT    NULL,    -- ID of the actor who changed it 
 
-- When and where 
changed_at       TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),  -- Microsecond precision 
 
-- Location of rider when status changed (optional, for tracking) 
latitude         DECIMAL(10,7) NULL, 
longitude        DECIMAL(10,7) NULL, 
 
-- Notes 
notes            VARCHAR(255) NULL,   -- "Customer requested cancellation" 
 
-- Constraint: previous and new status must be different 
CONSTRAINT chk_status_changed 
   CHECK (previous_status IS NULL OR previous_status != new_status), 
 
-- Foreign Key 
CONSTRAINT fk_osh_order 
   FOREIGN KEY (order_id) 
   REFERENCES Orders(order_id) 
   ON DELETE CASCADE, 
 
-- Indexes 
INDEX idx_osh_order  (order_id, changed_at), 
INDEX idx_osh_status (new_status, changed_at) 
 
); 
-- Sample Data: Complete lifecycle for Order 1 
INSERT INTO Order_Status_History (order_id, previous_status, new_status, changed_by_type, notes) VALUES (1, NULL, 'placed', 'customer', 'Order placed via app'), (1, 'placed', 'confirmed', 'restaurant', 'Restaurant accepted order'), (1, 'confirmed', 'preparing', 'restaurant', 'Started food preparation'), (1, 'preparing', 'out_for_delivery', 'rider', 'Picked up from restaurant'), (1, 'out_for_delivery', 'delivered', 'rider', 'Delivered to customer'), 
-- Order 4 was cancelled 
(4, NULL,                'placed',             'customer',   'Order placed via app'), 
(4, 'placed',            'cancelled',          'customer',   'Customer changed mind'); 





CREATE TABLE IF NOT EXISTS Deliveries ( delivery_id BIGINT PRIMARY KEY AUTO_INCREMENT, order_id BIGINT NOT NULL UNIQUE, -- 1:1 with Orders 
partner_id INT NOT NULL, 
-- Timestamps of each delivery phase 
assigned_at      TIMESTAMP NULL, 
picked_up_at     TIMESTAMP NULL, 
delivered_at     TIMESTAMP NULL, 
 
-- Status 
delivery_status  ENUM('assigned','heading_to_restaurant','picked_up', 
                     'heading_to_customer','delivered','failed') 
                         DEFAULT 'assigned', 
 
-- Metrics 
distance_km      DECIMAL(6,2)  NULL,           -- Distance travelled 
delivery_fee     DECIMAL(6,2)  DEFAULT 0.00,   -- Fee paid to partner 
 
-- Security OTP (customer confirms receipt) 
otp_code         CHAR(6)   NULL, 
otp_verified     BOOLEAN   DEFAULT FALSE, 
 
CONSTRAINT fk_del_order 
   FOREIGN KEY (order_id)   REFERENCES Orders(order_id), 
CONSTRAINT fk_del_partner 
   FOREIGN KEY (partner_id) REFERENCES Delivery_Partners(partner_id), 
 
INDEX idx_del_partner (partner_id), 
INDEX idx_del_status  (delivery_status) 
 
); 
INSERT INTO Deliveries (order_id, partner_id, assigned_at, picked_up_at, delivered_at, delivery_status, distance_km, otp_code, otp_verified) VALUES (1, 1, '2024-02-08 14:05:00', '2024-02-08 14:27:00', '2024-02-08 14:46:00', 'delivered', 3.20, '482910', TRUE), (2, 2, '2024-02-05 19:10:00', '2024-02-05 19:30:00', '2024-02-05 19:52:00', 'delivered', 2.80, '731045', TRUE), (3, 3, '2024-02-10 13:00:00', NULL, NULL, 'heading_to_restaurant', 4.10, '629874', FALSE); 
 
 
 
 
 
 
 
 
 
 CREATE TABLE IF NOT EXISTS Payments ( payment_id BIGINT PRIMARY KEY AUTO_INCREMENT, order_id BIGINT NOT NULL UNIQUE, -- 1:1 with Orders 
-- External transaction identifier from payment gateway 
transaction_id   VARCHAR(100)  NULL UNIQUE, 
 
payment_method   ENUM('Credit_Card','Debit_Card','UPI', 
                     'Net_Banking','Wallet','Cash_On_Delivery') NOT NULL, 
 
amount           DECIMAL(10,2) NOT NULL CHECK (amount > 0), 
currency         CHAR(3)       DEFAULT 'INR', 
 
status           ENUM('pending','success','failed','refunded') DEFAULT 'pending', 
 
-- Microsecond precision for financial ordering 
paid_at          TIMESTAMP(6)  NULL, 
 
-- Raw gateway response stored as JSON for audit/debugging 
gateway_response JSON          NULL, 
 
CONSTRAINT fk_pay_order 
   FOREIGN KEY (order_id) REFERENCES Orders(order_id), 
 
INDEX idx_pay_status  (status), 
INDEX idx_pay_paid_at (paid_at) 
 
); 
INSERT INTO Payments (order_id, transaction_id, payment_method, amount, status, paid_at) VALUES (1, 'TXN_RZP_A9X23', 'UPI', 690.00, 'success', '2024-02-08 14:04:55.123456'), (2, 'TXN_RZP_B8Y34', 'Wallet', 450.00, 'success', '2024-02-05 19:09:30.654321'), (3, 'TXN_RZP_C7Z45', 'UPI', 310.00, 'pending', NULL); 








CREATE TABLE IF NOT EXISTS Reviews ( review_id BIGINT PRIMARY KEY AUTO_INCREMENT, 
-- Foreign Keys 
order_id            BIGINT       NOT NULL UNIQUE,  -- 1 review per order (enforced!) 
customer_id         BIGINT       NOT NULL, 
restaurant_id       INT          NOT NULL, 
partner_id          INT          NULL,             -- NULL if delivery not assigned 
 
-- Ratings (1–5 stars) 
food_rating         TINYINT      NOT NULL CHECK (food_rating BETWEEN 1 AND 5), 
delivery_rating     TINYINT      NULL     CHECK (delivery_rating BETWEEN 1 AND 5), 
 
-- Review Content 
review_title        VARCHAR(100) NULL, 
review_text         TEXT         NULL, 
 
-- Photo attachments (JSON array of URLs) 
image_urls          JSON         NULL,              -- ["url1.jpg","url2.jpg"] 
 
-- Moderation 
is_visible          BOOLEAN      DEFAULT TRUE,      -- Admin can hide abusive reviews 
is_verified         BOOLEAN      DEFAULT TRUE,      -- Confirmed purchase 
flagged_count       TINYINT      DEFAULT 0,         -- User-reported count 
 
-- Restaurant Response 
restaurant_reply    TEXT         NULL, 
replied_at          TIMESTAMP    NULL, 
 
-- Timestamps 
reviewed_at         TIMESTAMP    DEFAULT CURRENT_TIMESTAMP, 
updated_at          TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
 
-- Foreign Key Relationships 
CONSTRAINT fk_rev_order 
   FOREIGN KEY (order_id)        REFERENCES Orders(order_id)        ON DELETE CASCADE, 
CONSTRAINT fk_rev_customer 
   FOREIGN KEY (customer_id)     REFERENCES Customers(customer_id)  ON DELETE CASCADE, 
CONSTRAINT fk_rev_restaurant 
   FOREIGN KEY (restaurant_id)   REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE, 
CONSTRAINT fk_rev_partner 
   FOREIGN KEY (partner_id)      REFERENCES Delivery_Partners(partner_id) ON DELETE SET NULL, 
 
-- Indexes 
INDEX idx_rev_restaurant (restaurant_id, food_rating), 
INDEX idx_rev_customer   (customer_id), 
INDEX idx_rev_visible    (is_visible, reviewed_at) 
 
); 
-- Sample Data 
INSERT INTO Reviews (order_id, customer_id, restaurant_id, partner_id, food_rating, delivery_rating, review_title, review_text) VALUES (1, 1, 1, 1, 5, 4, 'Best pizza in Bangalore!', 'Cheese was perfect, arrived hot. Rider was quick but packaging slightly damaged.'), (2, 1, 2, 2, 4, 5, 'Good burger, great delivery', 'McAloo Tikki was fresh. Rider was on time and very professional.'); 






CREATE TABLE IF NOT EXISTS Coupon_Usage ( usage_id BIGINT PRIMARY KEY AUTO_INCREMENT, coupon_id INT NOT NULL, customer_id BIGINT NOT NULL, order_id BIGINT NOT NULL UNIQUE, -- One entry per order discount_applied DECIMAL(8,2) NOT NULL, -- Actual amount saved used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
FOREIGN KEY (coupon_id)   REFERENCES Coupons(coupon_id), 
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id), 
FOREIGN KEY (order_id)    REFERENCES Orders(order_id), 
 
-- Used to check: how many times has this customer used this coupon? 
INDEX idx_cu_customer_coupon (customer_id, coupon_id) 
 
); 










CREATE TABLE IF NOT EXISTS Wallet_Transactions ( txn_id BIGINT PRIMARY KEY AUTO_INCREMENT, wallet_id BIGINT NOT NULL, order_id BIGINT NULL, -- NULL for top-ups, bonuses 
txn_type        ENUM( 
                   'credit',           -- Money added by user 
                   'debit',            -- Money spent on order 
                   'refund',           -- Order refunded to wallet 
                   'cashback',         -- Promo cashback credited 
                   'referral_bonus',   -- Refer-a-friend bonus 
                   'adjustment'        -- Manual admin correction 
               ) NOT NULL, 
 
amount          DECIMAL(10,2) NOT NULL CHECK (amount > 0), 
balance_after   DECIMAL(12,2) NOT NULL,             -- Snapshot of balance post-txn 
description     VARCHAR(255)  NULL, 
reference_id    VARCHAR(100)  NULL,                 -- External payment reference 
 
txn_at          TIMESTAMP(6)  DEFAULT CURRENT_TIMESTAMP(6),  -- Microsecond precision 
 
FOREIGN KEY (wallet_id) REFERENCES Customer_Wallets(wallet_id), 
FOREIGN KEY (order_id)  REFERENCES Orders(order_id) ON DELETE SET NULL, 
 
INDEX idx_wt_wallet (wallet_id, txn_at), 
INDEX idx_wt_type   (txn_type) 
 
); 
-- Sample Data: Wallet history for Priya (customer 1) 
INSERT INTO Wallet_Transactions (wallet_id, txn_type, amount, balance_after, description) VALUES (1, 'credit', 1000.00, 1000.00, 'Wallet top-up via UPI'), (1, 'referral_bonus', 200.00, 1200.00, 'Referred user Raj Patel'), (1, 'debit', 690.00, 510.00, 'Order #1 - Dominos'), (1, 'cashback', 40.00, 550.00, '10% cashback on order #1'), (1, 'credit', 2000.00, 2550.00, 'Wallet top-up via net banking'), (1, 'debit', 700.00, 1850.00, 'Order #2 - McDonalds'); 
-- ═══════════════════════════════════════════════════════════════════ -- RE-ENABLE FOREIGN KEY CHECKS -- ═══════════════════════════════════════════════════════════════════ SET FOREIGN_KEY_CHECKS = 1; 
-- ═══════════════════════════════════════════════════════════════════ -- VERIFICATION: Check all tables were created -- ═══════════════════════════════════════════════════════════════════ 
SELECT TABLE_NAME, TABLE_ROWS, CREATE_TIME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'FoodDeliveryApp' ORDER BY CREATE_TIME; 
-- ═══════════════════════════════════════════════════════════════════ -- COMPLETE TABLE LIST (18 tables total): -- -- LOOKUP TABLES (3): -- Countries, States, Cities -- -- CORE ENTITIES (5): -- Customers, Customer_Addresses, Restaurants, -- Delivery_Partners, Menu_Categories, Menu_Items -- -- FINANCIAL (3): -- Coupons, Customer_Wallets, Wallet_Transactions -- -- TRANSACTION CORE (2): -- Orders, Order_Items ← WAS MISSING -- -- TRACKING & AUDIT (3): -- Deliveries, Order_Status_History ← WAS MISSING, Payments -- -- ENGAGEMENT (2): -- Reviews ← WAS MISSING, Coupon_Usage ← WAS MISSING -- ═══════════════════════════════════════════════════════════════════ 
 DELIMITER $$ 
 CREATE TRIGGER  trg_update_restaurant_rating 
 AFTER INSERT ON Reviews FOR EACH ROW 
 BEGIN 
 UPDATE Restaurants SET avg_rating = ( SELECT ROUND(AVG(food_rating), 2) FROM Reviews WHERE restaurant_id = NEW.restaurant_id AND is_visible = TRUE ) WHERE restaurant_id = NEW.restaurant_id; 
 END$$ DELIMITER ; 
 
 
 
 
 
 
 DELIMITER $$
 CREATE TRIGGER  trg_capture_order_status 
 AFTER UPDATE ON Orders FOR EACH ROW 
 BEGIN 
 IF OLD.order_status != NEW.order_status THEN INSERT INTO Order_Status_History (order_id, previous_status, new_status, changed_by_type) VALUES (NEW.order_id, OLD.order_status, NEW.order_status, 'system'); 
 END IF;
 END$$ DELIMITER ; 
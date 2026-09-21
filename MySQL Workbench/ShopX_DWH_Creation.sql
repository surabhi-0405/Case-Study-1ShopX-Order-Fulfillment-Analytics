-- Create database
CREATE DATABASE IF NOT EXISTS shopx_dwh;

USE shopx_dwh;

-- ============================================================
-- 1. Customers
-- ============================================================

CREATE TABLE Customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    region VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    street_address VARCHAR(255),
    phone_number VARCHAR(30),
    email_address VARCHAR(100),
    language VARCHAR(20),
    tax_number VARCHAR(50),
    customer_group VARCHAR(50),
    sales_organization VARCHAR(20),
    distribution_channel VARCHAR(20),
    division VARCHAR(20)
);


-- ============================================================
-- 2. Orders
-- ============================================================

CREATE TABLE Orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    order_type VARCHAR(20),
    sales_organization VARCHAR(20),
    distribution_channel VARCHAR(20),
    division VARCHAR(20),
    order_status VARCHAR(20),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);


-- ============================================================
-- 3. Order_Items
-- ============================================================

CREATE TABLE Order_Items (
    order_id VARCHAR(20) NOT NULL,
    item_number VARCHAR(10) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    order_quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    item_status VARCHAR(20),
    source_delivery_date DATE,

    PRIMARY KEY (order_id, item_number),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);


-- ============================================================
-- 4. Shipments
-- ============================================================

CREATE TABLE Shipments (
    shipment_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    delivery_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    shipment_date DATE NOT NULL,
    shipping_point VARCHAR(20),
    carrier VARCHAR(100),
    shipment_status VARCHAR(20),
    route VARCHAR(50),
    shipping_type VARCHAR(20),

    CONSTRAINT fk_shipments_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT fk_shipments_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);


-- ============================================================
-- 5. Shipment_Items
-- ============================================================

CREATE TABLE Shipment_Items (
    shipment_id VARCHAR(20) NOT NULL,
    item_number VARCHAR(10) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    shipped_quantity INT NOT NULL,
    item_status VARCHAR(20),
    delivery_id VARCHAR(20),
    customer_id VARCHAR(20) NOT NULL,
    order_id VARCHAR(20) NOT NULL,
    sales_item VARCHAR(10),
    shipment_date DATE NOT NULL,

    PRIMARY KEY (shipment_id, item_number),

    CONSTRAINT fk_shipment_items_shipment
        FOREIGN KEY (shipment_id)
        REFERENCES Shipments(shipment_id)
);


-- ============================================================
-- 6. Carriers
-- ============================================================

CREATE TABLE Carriers (
    carrier_id VARCHAR(20) PRIMARY KEY,
    carrier_name VARCHAR(100),
    country VARCHAR(50),
    region VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    street_address VARCHAR(255),
    phone_number VARCHAR(30),
    email_address VARCHAR(100),
    language VARCHAR(20),
    tax_number VARCHAR(50),
    payment_terms VARCHAR(50)
);


-- ============================================================
-- 7. Delivery_Status
-- ============================================================

CREATE TABLE Delivery_Status (
    delivery_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    delivery_date DATE NOT NULL,
    delivery_status VARCHAR(20),
    shipping_status VARCHAR(20),
    shipping_point VARCHAR(20),
    shipping_type VARCHAR(20),
    route VARCHAR(50),
    delivery_priority VARCHAR(20),

    CONSTRAINT fk_delivery_status_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT fk_delivery_status_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);


-- ============================================================
-- 8. Delivery_Analytics
-- ============================================================

CREATE TABLE Delivery_Analytics (
    analytics_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    shipment_date DATE,
    delivery_date DATE,
    order_to_ship_days INT,
    order_to_delivery_days INT,
    shipment_to_delivery_days INT,
    fulfillment_status VARCHAR(30),

    CONSTRAINT fk_delivery_analytics_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT fk_delivery_analytics_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);


-- ============================================================
-- 9. Date_Dimension
-- ============================================================

CREATE TABLE Date_Dimension (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    year INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter INT NOT NULL,
    day INT NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    week_number INT NOT NULL
);


-- ============================================================
-- 10. Delivery_Items
-- ============================================================

CREATE TABLE Delivery_Items (
    delivery_id VARCHAR(20) NOT NULL,
    item_number VARCHAR(10) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    delivered_quantity INT NOT NULL,
    net_price DECIMAL(12,2) NOT NULL,
    delivery_status VARCHAR(20),
    customer_id VARCHAR(20) NOT NULL,
    order_id VARCHAR(20) NOT NULL,
    sales_item VARCHAR(10),
    delivery_date DATE NOT NULL,

    PRIMARY KEY (delivery_id, item_number),

    CONSTRAINT fk_delivery_items_delivery
        FOREIGN KEY (delivery_id)
        REFERENCES Delivery_Status(delivery_id)
);


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_orders_customer
    ON Orders(customer_id);

CREATE INDEX idx_orders_date
    ON Orders(order_date);

CREATE INDEX idx_order_items_product
    ON Order_Items(product_id);

CREATE INDEX idx_shipments_order
    ON Shipments(order_id);

CREATE INDEX idx_shipments_customer
    ON Shipments(customer_id);

CREATE INDEX idx_shipments_date
    ON Shipments(shipment_date);

CREATE INDEX idx_delivery_status_order
    ON Delivery_Status(order_id);

CREATE INDEX idx_delivery_status_customer
    ON Delivery_Status(customer_id);

CREATE INDEX idx_delivery_status_date
    ON Delivery_Status(delivery_date);

CREATE INDEX idx_delivery_analytics_order
    ON Delivery_Analytics(order_id);

CREATE INDEX idx_delivery_analytics_customer
    ON Delivery_Analytics(customer_id);

CREATE INDEX idx_delivery_analytics_date
    ON Delivery_Analytics(delivery_date);



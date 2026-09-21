USE shopx_dwh;

-- ============================================================
-- 1. VERIFY LOADED RECORD COUNTS
-- ============================================================

SELECT 'Customers' AS table_name, COUNT(*) AS records FROM Customers
UNION ALL
SELECT 'Carriers', COUNT(*) FROM Carriers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Order_Items', COUNT(*) FROM Order_Items
UNION ALL
SELECT 'Delivery_Status', COUNT(*) FROM Delivery_Status
UNION ALL
SELECT 'Delivery_Items', COUNT(*) FROM Delivery_Items
UNION ALL
SELECT 'Shipments', COUNT(*) FROM Shipments
UNION ALL
SELECT 'Shipment_Items', COUNT(*) FROM Shipment_Items
UNION ALL
SELECT 'Delivery_Analytics', COUNT(*) FROM Delivery_Analytics
UNION ALL
SELECT 'Date_Dimension', COUNT(*) FROM Date_Dimension;


-- ============================================================
-- 2. VERIFY ORDERS
-- ============================================================

SELECT *
FROM Orders;

-- ============================================================
-- 3. VERIFY ORDER ITEMS
-- ============================================================

SELECT *
FROM Order_Items;

-- ============================================================
-- 4. VERIFY DELIVERY STATUS
-- ============================================================

SELECT *
FROM Delivery_Status;
-- ============================================================
-- 5. VERIFY DELIVERY ITEMS
-- ============================================================

SELECT *
FROM Delivery_Items;

-- ============================================================
-- 6. VERIFY SHIPMENTS
-- ============================================================

SELECT *
FROM Shipments;

-- ============================================================
-- 7. VERIFY SHIPMENT ITEMS
-- ============================================================

SELECT *
FROM Shipment_Items;

-- ============================================================
-- 8. VERIFY CUSTOMERS
-- ============================================================

SELECT *
FROM Customers;

-- ============================================================
-- 9. VERIFY CARRIERS
-- ============================================================

SELECT *
FROM Carriers;

-- ============================================================
-- 10. VERIFY DELIVERY ANALYTICS
-- ============================================================

SELECT *
FROM Delivery_Analytics;

-- ============================================================
-- 11. VERIFY DATE DIMENSION
-- ============================================================

SELECT *
FROM Date_Dimension;

-- ============================================================
-- 12. CHECK DELIVERY ANALYTICS COUNT
-- ============================================================

SELECT COUNT(*) AS analytics_count
FROM Delivery_Analytics;

-- ===========================================================
-- 13. CHECK FULFILLMENT STATUS DISTRIBUTION
-- ============================================================

SELECT
    fulfillment_status,
    COUNT(*) AS order_count
FROM Delivery_Analytics
GROUP BY fulfillment_status
ORDER BY fulfillment_status;

-- ============================================================

SELECT
    order_id,
    customer_id,
    order_date,
    shipment_date,
    delivery_date,
    order_to_ship_days,
    order_to_delivery_days,
    shipment_to_delivery_days,
    fulfillment_status
FROM Delivery_Analytics
WHERE shipment_date IS NULL
   OR delivery_date IS NULL;

-- ============================================================

SELECT
    order_id,
    customer_id,
    order_date,
    shipment_date,
    delivery_date,
    order_to_ship_days,
    order_to_delivery_days,
    shipment_to_delivery_days,
    fulfillment_status
FROM Delivery_Analytics
WHERE order_id IN ('1000021', '1000022');

-- ============================================================
-- 16. VERIFY ORDERS WITH DELIVERY ANALYTICS
-- ============================================================

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    da.fulfillment_status,
    da.order_to_ship_days,
    da.order_to_delivery_days
FROM Orders o
LEFT JOIN Delivery_Analytics da
    ON o.order_id = da.order_id
ORDER BY o.order_id;

-- ============================================================

SELECT
    order_id,
    order_date,
    delivery_date,
    order_to_delivery_days
FROM Delivery_Analytics
WHERE delivery_date IS NOT NULL
ORDER BY order_id;

-- ============================================================

SELECT
    order_id,
    shipment_date,
    delivery_date,
    shipment_to_delivery_days
FROM Delivery_Analytics
WHERE shipment_date IS NOT NULL
  AND delivery_date IS NOT NULL
ORDER BY order_id;

-- ============================================================

SELECT
    shipment_status,
    COUNT(*) AS shipment_count
FROM Shipments
GROUP BY shipment_status
ORDER BY shipment_status;

-- ============================================================

SELECT
    carrier,
    COUNT(*) AS shipment_count
FROM Shipments
GROUP BY carrier
ORDER BY carrier;

-- ============================================================

SELECT
    delivery_status,
    COUNT(*) AS delivery_count
FROM Delivery_Status
GROUP BY delivery_status
ORDER BY delivery_status;

-- ============================================================
-- DIMENSION RANGE
-- ============================================================

SELECT
    MIN(full_date) AS start_date,
    MAX(full_date) AS end_date,
    COUNT(*) AS total_dates
FROM Date_Dimension;


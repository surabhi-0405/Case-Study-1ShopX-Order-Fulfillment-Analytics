USE shopx_dwh;


-- ============================================================
-- ORDER STATUS DISTRIBUTION
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS order_count
FROM Orders
GROUP BY order_status
ORDER BY order_status;


-- ============================================================
-- TOTAL ORDERS
-- ============================================================

SELECT
    COUNT(*) AS total_orders
FROM Orders;


-- ============================================================

SELECT
    COUNT(*) AS delivered_orders
FROM Delivery_Analytics
WHERE fulfillment_status = 'Delivered';


-- ============================================================

SELECT
    ROUND(
        COUNT(CASE
            WHEN fulfillment_status = 'Delivered' THEN 1
        END) * 100.0 / COUNT(*),
        2
    ) AS customer_order_fulfillment_rate
FROM Delivery_Analytics;


-- ============================================================

SELECT
    fulfillment_status,
    COUNT(*) AS order_count
FROM Delivery_Analytics
GROUP BY fulfillment_status
ORDER BY fulfillment_status;


-- ============================================================

SELECT
    ROUND(AVG(order_to_ship_days), 2) AS average_order_to_ship_days
FROM Delivery_Analytics
WHERE order_to_ship_days IS NOT NULL;


-- ============================================================

SELECT
    ROUND(AVG(order_to_delivery_days), 2) AS average_order_to_delivery_days
FROM Delivery_Analytics
WHERE order_to_delivery_days IS NOT NULL;


-- ============================================================

SELECT
    ROUND(AVG(shipment_to_delivery_days), 2)
        AS average_shipment_to_delivery_days
FROM Delivery_Analytics
WHERE shipment_to_delivery_days IS NOT NULL;


-- ============================================================
SELECT
    order_id,
    customer_id,
    order_date,
    shipment_date,
    order_to_ship_days
FROM Delivery_Analytics
WHERE shipment_date IS NOT NULL
ORDER BY order_id;


-- ============================================================

SELECT
    order_id,
    customer_id,
    order_date,
    delivery_date,
    order_to_delivery_days,
    fulfillment_status
FROM Delivery_Analytics
WHERE delivery_date IS NOT NULL
ORDER BY order_id;


-- ============================================================

SELECT
    order_id,
    customer_id,
    order_date,
    shipment_date,
    delivery_date,
    order_to_ship_days,
    order_to_delivery_days,
    fulfillment_status
FROM Delivery_Analytics
ORDER BY order_id;


-- ============================================================
-- TOTAL SHIPMENTS
-- ============================================================

SELECT
    COUNT(*) AS total_shipments
FROM Shipments;


-- ============================================================
-- DELIVERED SHIPMENTS
-- ============================================================

SELECT
    COUNT(*) AS delivered_shipments
FROM Shipments
WHERE shipment_status = 'Delivered';


-- ============================================================
--IN-TRANSIT SHIPMENTS
-- ============================================================

SELECT
    COUNT(*) AS in_transit_shipments
FROM Shipments
WHERE shipment_status = 'In Transit';


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
ORDER BY shipment_count DESC;

-- ============================================================

SELECT
    carrier,
    shipment_status,
    COUNT(*) AS shipment_count
FROM Shipments
GROUP BY carrier, shipment_status
ORDER BY carrier, shipment_status;


-- ============================================================

SELECT
    carrier,
    COUNT(*) AS total_shipments,
    SUM(
        CASE
            WHEN shipment_status = 'Delivered' THEN 1
            ELSE 0
        END
    ) AS delivered_shipments,
    SUM(
        CASE
            WHEN shipment_status = 'In Transit' THEN 1
            ELSE 0
        END
    ) AS in_transit_shipments
FROM Shipments
GROUP BY carrier
ORDER BY carrier;


-- ============================================================

SELECT
    s.carrier,
    ROUND(AVG(da.shipment_to_delivery_days), 2)
        AS average_shipment_to_delivery_days
FROM Shipments s
JOIN Delivery_Analytics da
    ON s.order_id = da.order_id
WHERE da.shipment_to_delivery_days IS NOT NULL
GROUP BY s.carrier
ORDER BY s.carrier;


-- ============================================================
-- ORDERS BY CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY order_count DESC, c.customer_id;


-- ============================================================
-- ORDERS BY REGION
-- ============================================================

SELECT
    c.region,
    COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.region
ORDER BY order_count DESC;


-- ============================================================
-- CUSTOMER FULFILLMENT STATUS
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    da.fulfillment_status,
    COUNT(da.order_id) AS order_count
FROM Customers c
JOIN Delivery_Analytics da
    ON c.customer_id = da.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    da.fulfillment_status
ORDER BY
    c.customer_id,
    da.fulfillment_status;


-- ============================================================
-- CUSTOMER ORDER SUMMARY
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    c.region,
    COUNT(da.order_id) AS total_orders,
    SUM(
        CASE
            WHEN da.fulfillment_status = 'Delivered'
            THEN 1
            ELSE 0
        END
    ) AS delivered_orders,
    SUM(
        CASE
            WHEN da.fulfillment_status = 'In Delivery'
            THEN 1
            ELSE 0
        END
    ) AS orders_in_delivery,
    SUM(
        CASE
            WHEN da.fulfillment_status = 'Order Processing'
            THEN 1
            ELSE 0
        END
    ) AS orders_in_processing
FROM Customers c
JOIN Delivery_Analytics da
    ON c.customer_id = da.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.region
ORDER BY total_orders DESC, c.customer_id;


-- ============================================================
-- ORDERS BY MONTH
-- ============================================================

SELECT
    dd.year,
    dd.month,
    dd.month_name,
    COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Date_Dimension dd
    ON o.order_date = dd.full_date
GROUP BY
    dd.year,
    dd.month,
    dd.month_name
ORDER BY
    dd.year,
    dd.month;


-- ============================================================
-- DELIVERY STATUS DISTRIBUTION
-- ============================================================

SELECT
    delivery_status,
    COUNT(*) AS delivery_count
FROM Delivery_Status
GROUP BY delivery_status
ORDER BY delivery_status;


-- ============================================================
-- ORDERS CURRENTLY IN DELIVERY
-- ============================================================

SELECT
    order_id,
    customer_id,
    order_date,
    shipment_date,
    fulfillment_status
FROM Delivery_Analytics
WHERE fulfillment_status = 'In Delivery'
ORDER BY order_id;


-- ============================================================
-- ORDERS CURRENTLY IN PROCESSING
-- ============================================================

SELECT
    order_id,
    customer_id,
    order_date,
    fulfillment_status
FROM Delivery_Analytics
WHERE fulfillment_status = 'Order Processing'
ORDER BY order_id;


-- ============================================================

SELECT
    COUNT(order_id) AS orders_with_delivery,
    MIN(order_to_delivery_days) AS minimum_delivery_days,
    MAX(order_to_delivery_days) AS maximum_delivery_days,
    ROUND(AVG(order_to_delivery_days), 2)
        AS average_delivery_days
FROM Delivery_Analytics
WHERE order_to_delivery_days IS NOT NULL;


-- ============================================================

SELECT
    COUNT(*) AS total_orders,
    COUNT(shipment_date) AS orders_with_shipment,
    COUNT(delivery_date) AS orders_with_delivery,
    COUNT(order_to_ship_days) AS valid_order_to_ship_records,
    COUNT(order_to_delivery_days) AS valid_order_to_delivery_records
FROM Delivery_Analytics;

-- ============================================================

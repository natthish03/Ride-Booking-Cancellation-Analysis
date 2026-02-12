CREATE DATABASE ride_booking_project;
USE ride_booking_project;
CREATE TABLE ride_data (
    booking_id VARCHAR(20),
    booking_date DATE,
    booking_time TIME,
    customer_id VARCHAR(20),
    driver_id VARCHAR(20),
    pickup_location VARCHAR(50),
    drop_location VARCHAR(50),
    ride_distance_km FLOAT,
    ride_duration_min FLOAT,
    fare_amount FLOAT,
    payment_method VARCHAR(20),
    ride_status VARCHAR(20),
    driver_rating FLOAT,
    customer_rating FLOAT
);

# Remove Duplicate Records

DELETE FROM ride_data
WHERE booking_id NOT IN (
    SELECT booking_id FROM (
        SELECT MIN(booking_id) AS booking_id
        FROM ride_data
        GROUP BY booking_id
    ) AS temp
);

# Replace Missing Fare (Cancelled Rides)
UPDATE ride_data
SET fare_amount = 0
WHERE ride_status = 'Cancelled'
AND fare_amount IS NULL;

# Replace Missing Fare (Completed Rides)

UPDATE ride_data
SET fare_amount = (
    SELECT AVG(fare_amount)
    FROM ride_data
    WHERE ride_status = 'Completed'
)
WHERE fare_amount IS NULL;

# Total Revenue 

SELECT sum(fare_amount) AS total_revenue
from ride_data
Where ride_status = "Completed";

# Total Rides

select count(*) as total_rides
from ride_data;

# Cancellation Rate

SELECT ride_status, COUNT(*) AS rides
FROM ride_data
GROUP BY ride_status;

# Peak Booking Hours

SELECT HOUR(booking_time) AS booking_hour,
COUNT(*) AS ride_count
FROM ride_data
GROUP BY booking_hour
ORDER BY ride_count DESC;

# revenue by Pickup Location

select pickup_location,
sum(fare_amount) as revenue
from ride_data
group by pickup_location
order by revenue DESC;

# Payment Method Analusis

select payment_method,
count(*) as ride_count
from ride_data
group by payment_method;

# Driver Performance Analysis

select driver_id,
avg(driver_rating) as avg_rating,
count(*) as total_rides
from ride_data
where ride_status = "Completed"
group by driver_id
order by avg_rating DESC;

# Monthly Revenue Trend
select month(booking_date) as month,
sum(fare_amount) as revenue
from ride_data
group by month
order by month;

# Average Fare per KM

select avg(fare_amount / ride_distance_km) as Average_Fare_per_KM
from ride_data
where ride_status = "Completed";

# Top 5 Pickup Locations
SELECT pickup_location,
COUNT(*) AS rides
FROM ride_data
GROUP BY pickup_location
ORDER BY rides DESC
LIMIT 5;

# Customer Ride Frequency

select customer_id,
count(*) as total_rides
from ride_data 
group by customer_id
order by total_rides DESC;






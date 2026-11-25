-- 												Task 2



#Task 2.1

CREATE DATABASE noshowguard;

USE noshowguard;

SELECT DATABASE();

CREATE TABLE clinics (
  clinic_id VARCHAR(5) PRIMARY KEY, clinic_name VARCHAR(40) NOT NULL, city VARCHAR(20) NOT NULL,
  tier VARCHAR(10), latitude DECIMAL(8,4), longitude DECIMAL(8,4), temp_c DECIMAL(5,1));
CREATE TABLE appointments (
  appointment_id VARCHAR(8) PRIMARY KEY, patient_id VARCHAR(8) NOT NULL, clinic_id VARCHAR(5) NOT NULL,
  booked_on DATE, appt_date DATE, age INT, gender VARCHAR(1), distance_km DECIMAL(5,1), fee_inr INT,
  booking_channel VARCHAR(10), visit_type VARCHAR(12), reminder_sent VARCHAR(3), prior_no_shows INT,
  status VARCHAR(10), lead_days INT, no_show INT,
  FOREIGN KEY (clinic_id) REFERENCES clinics(clinic_id));
  

SELECT COUNT(*) AS total_clinics
FROM clinics;

SELECT COUNT(*) AS total_appointments
FROM appointments;

SELECT SUM(no_show) AS total_no_shows
FROM appointments;


SELECT *
FROM appointments
WHERE appointment_id = 'A0001';

INSERT INTO appointments
SELECT *
FROM appointments
WHERE appointment_id = 'A0001';


# Error Message 

# 13:13:04	INSERT INTO appointments SELECT * FROM appointments WHERE appointment_id = 'A0001'	Error Code: 1062. Duplicate entry 'A0001' for key 'appointments.PRIMARY'	0.0016 sec 


------------------------------------------------------------------------------------------------------------------



#Task 2.2

USE noshowguard;

SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS appointments
FROM appointments a
JOIN clinics c
    ON a.clinic_id = c.clinic_id
GROUP BY
    c.clinic_name,
    c.city
ORDER BY
    appointments DESC;


-------------------------------------

SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS appointments,
    SUM(a.no_show) AS no_shows
FROM appointments a
JOIN clinics c
    ON a.clinic_id = c.clinic_id
GROUP BY
    c.clinic_name,
    c.city
ORDER BY
    appointments DESC;
    
    
---------------------------------------------    

SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS appointments,
    SUM(a.no_show) AS no_shows,
    ROUND(100.0 * SUM(a.no_show) / COUNT(*), 1) AS no_show_pct
FROM appointments a
JOIN clinics c
    ON a.clinic_id = c.clinic_id
GROUP BY
    c.clinic_name,
    c.city
ORDER BY
    no_show_pct DESC;
    
    
    
------------------------------------------------------



SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS appointments,
    SUM(a.no_show) AS no_shows,
    ROUND(100.0 * SUM(a.no_show) / COUNT(*), 1) AS no_show_pct
FROM appointments a
JOIN clinics c
    ON a.clinic_id = c.clinic_id
GROUP BY
    c.clinic_name,
    c.city
HAVING COUNT(*) >= 95
ORDER BY
    no_show_pct DESC;    
    
    
    
    
 --------------------------------------------
 
SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS appointments,
    SUM(a.no_show) AS no_shows,
    ROUND(100.0 * SUM(a.no_show) / COUNT(*), 1) AS no_show_pct
FROM appointments a
JOIN clinics c
    ON a.clinic_id = c.clinic_id
GROUP BY
    c.clinic_name,
    c.city
ORDER BY
    no_show_pct DESC;
    
    
    
----------------------------------------------------------------------------------------------------------------    

# Task 2.3

SELECT
    CASE
        WHEN lead_days BETWEEN 1 AND 7 THEN '1-7'
        WHEN lead_days BETWEEN 8 AND 14 THEN '8-14'
        WHEN lead_days BETWEEN 15 AND 30 THEN '15-30'
        WHEN lead_days >= 31 THEN '31+'
    END AS lead_time_band,

    COUNT(*) AS appointments,

    SUM(no_show) AS no_shows,

    ROUND(100.0 * SUM(no_show) / COUNT(*), 1) AS no_show_pct

FROM appointments

GROUP BY lead_time_band

ORDER BY MIN(lead_days);


-------------------------------------------------------------------------------------------------------------

# Task 2.4

WITH monthly AS (
    SELECT
        SUBSTR(appt_date, 1, 7) AS month,
        COUNT(*) AS appointments,
        ROUND(
            100.0 * SUM(no_show) / COUNT(*),
            1
        ) AS no_show_pct
    FROM appointments
    GROUP BY SUBSTR(appt_date, 1, 7)
)

SELECT
    month,
    appointments,
    no_show_pct,
    ROUND(
        no_show_pct - LAG(no_show_pct) OVER (ORDER BY month),
        1
    ) AS percentage_point_change
FROM monthly
ORDER BY month;


-----------------------------------------------------------------------------------------------------------------




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


---------------------------------------------------------------------------------------------------------------
# Task 2.5

WITH clinic_rates AS (
    SELECT
        c.clinic_name AS clinic,
        c.city,
        ROUND(
            100.0 * SUM(a.no_show) / COUNT(*),
            1
        ) AS no_show_pct
    FROM clinics c
    JOIN appointments a
        ON c.clinic_id = a.clinic_id
    GROUP BY
        c.clinic_id,
        c.clinic_name,
        c.city
),

ranked_clinics AS (
    SELECT
        clinic,
        city,
        no_show_pct,

        RANK() OVER (
            PARTITION BY city
            ORDER BY no_show_pct DESC
        ) AS rank_in_city,

        CASE
            WHEN no_show_pct > (
                SELECT
                    100.0 * SUM(no_show) / COUNT(*)
                FROM appointments
            )
            THEN 'Above'

            WHEN no_show_pct < (
                SELECT
                    100.0 * SUM(no_show) / COUNT(*)
                FROM appointments
            )
            THEN 'Below'

            ELSE 'Equal'
        END AS vs_overall

    FROM clinic_rates
)

SELECT
    clinic,
    city,
    no_show_pct,
    rank_in_city,
    vs_overall
FROM ranked_clinics
ORDER BY
    city,
    rank_in_city;
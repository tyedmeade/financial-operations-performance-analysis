-- Financial Operations & Loan Performance Analysis
-- Author: Tyler Edmeade
-- Tools Used: PostgreSQL, SQL, Power BI

-- =========================================
-- CUSTOMER RETENTION STATUS
-- =========================================

-- Business Purpose:
-- Segments customers based on payment recency
-- and identifies retention risk levels.

CREATE OR REPLACE VIEW customer_retention_status AS

WITH customer_last_payment AS (

    SELECT
        customer_id,

        MAX(payment_date) AS last_payment_date

    FROM clean_payments

    WHERE payment_status IN ('Paid', 'Late')

    GROUP BY customer_id
),

retention_status AS (

    SELECT
        c.customer_id,

        c.signup_date,

        c.region,

        r.regional_manager,

        r.market_type,

        c.acquisition_channel,

        c.credit_score_band,

        c.customer_segment,

        clp.last_payment_date,

        DATE '2024-07-01'
        - clp.last_payment_date
        AS days_since_last_payment,

        CASE
            WHEN clp.last_payment_date IS NULL
                THEN 'No Payment Yet'

            WHEN DATE '2024-07-01'
                - clp.last_payment_date > 90
                THEN 'Churned'

            WHEN DATE '2024-07-01'
                - clp.last_payment_date
                BETWEEN 60 AND 90
                THEN 'At Risk'

            ELSE 'Active'
        END AS retention_status

    FROM clean_customers c

    JOIN clean_regions r
        ON c.region = r.region

    LEFT JOIN customer_last_payment clp
        ON c.customer_id = clp.customer_id
)

SELECT *
FROM retention_status;

-- =========================================
-- CUSTOMER SEGMENT RISK SUMMARY
-- =========================================

-- Business Purpose:
-- Evaluates payment delinquency risk
-- by customer segment and credit profile.

CREATE OR REPLACE VIEW segment_risk_summary AS

WITH payment_summary AS (

    SELECT
        c.customer_segment,

        c.credit_score_band,

        COUNT(*) AS total_payments,

        COUNT(*) FILTER (
            WHERE p.payment_status = 'Late'
        ) AS late_payments,

        AVG(p.days_late) FILTER (
            WHERE p.payment_status = 'Late'
        ) AS avg_days_late,

        SUM(p.payment_amount) FILTER (
            WHERE p.payment_status IN (
                'Paid',
                'Late'
            )
        ) AS collected_amount

    FROM clean_payments p

    JOIN clean_customers c
        ON p.customer_id = c.customer_id

    WHERE p.payment_status IN ('Paid', 'Late')

    GROUP BY
        c.customer_segment,
        c.credit_score_band
)

SELECT
    customer_segment,

    credit_score_band,

    total_payments,

    late_payments,

    avg_days_late,

    collected_amount,

    ROUND(
        late_payments::numeric
        / NULLIF(total_payments, 0),
        4
    ) AS late_payment_rate,

    RANK() OVER (
        ORDER BY
            late_payments::numeric
            / NULLIF(total_payments, 0) DESC
    ) AS risk_rank

FROM payment_summary;

-- =========================================
-- CUSTOMER PAYMENT RISK SCATTER VIEW
-- =========================================

-- Business Purpose:
-- Supports scatter plot analysis of
-- customer payment severity, delinquency,
-- and financial exposure.

CREATE OR REPLACE VIEW vw_customer_payment_risk_scatter AS

WITH segment_summary AS (

    SELECT
        c.customer_segment,

        c.credit_score_band,

        c.region,

        COUNT(*) AS total_payments,

        COUNT(*) FILTER (
            WHERE p.payment_status = 'Late'
        ) AS late_payments,

        AVG(p.days_late) FILTER (
            WHERE p.payment_status = 'Late'
        ) AS avg_days_late,

        SUM(p.payment_amount) FILTER (
            WHERE p.payment_status IN (
                'Paid',
                'Late'
            )
        ) AS collected_amount

    FROM clean_payments p

    JOIN clean_customers c
        ON p.customer_id = c.customer_id

    WHERE p.payment_status IN ('Paid', 'Late')

    GROUP BY
        c.customer_segment,
        c.credit_score_band,
        c.region
)

SELECT
    customer_segment,

    credit_score_band,

    region,

    total_payments,

    late_payments,

    avg_days_late,

    collected_amount,

    ROUND(
        late_payments::numeric
        / NULLIF(total_payments,0),
        4
    ) AS late_payment_rate

FROM segment_summary;

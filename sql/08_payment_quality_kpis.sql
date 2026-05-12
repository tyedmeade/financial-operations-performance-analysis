-- Financial Operations & Loan Performance Analysis
-- Author: Tyler Edmeade
-- Tools Used: PostgreSQL, SQL, Power BI

-- =========================================
-- PAYMENT QUALITY & COLLECTION ANALYSIS
-- =========================================

-- Business Purpose:
-- Evaluates payment reliability,
-- delinquency trends, reversals,
-- and collection performance.

CREATE OR REPLACE VIEW payment_quality_kpis AS

WITH valid_payments AS (

    SELECT
        p.payment_id,

        p.customer_id,

        c.region,

        r.regional_manager,

        r.market_type,

        c.customer_segment,

        p.payment_date,

        p.payment_amount,

        p.payment_status,

        p.days_late

    FROM clean_payments p

    JOIN clean_customers c
        ON p.customer_id = c.customer_id

    JOIN clean_regions r
        ON c.region = r.region

    WHERE p.payment_status IN (
        'Paid',
        'Late',
        'Reversed'
    )
),

monthly_payment_summary AS (

    SELECT
        DATE_TRUNC(
            'month',
            payment_date
        )::date AS month,

        region,

        regional_manager,

        market_type,

        COUNT(*) AS total_payments,

        SUM(payment_amount) FILTER (
            WHERE payment_status IN (
                'Paid',
                'Late'
            )
        ) AS collected_amount,

        COUNT(*) FILTER (
            WHERE payment_status = 'Late'
        ) AS late_payments,

        AVG(days_late) FILTER (
            WHERE payment_status = 'Late'
        ) AS avg_days_late,

        COUNT(*) FILTER (
            WHERE payment_status = 'Reversed'
        ) AS reversed_payments,

        SUM(payment_amount) FILTER (
            WHERE payment_status = 'Reversed'
        ) AS reversed_amount

    FROM valid_payments

    GROUP BY
        DATE_TRUNC('month', payment_date),
        region,
        regional_manager,
        market_type
)

SELECT
    month,

    region,

    regional_manager,

    market_type,

    total_payments,

    collected_amount,

    late_payments,

    avg_days_late,

    reversed_payments,

    reversed_amount,

    ROUND(
        late_payments::numeric
        / NULLIF(total_payments, 0),
        4
    ) AS late_payment_rate,

    ROUND(
        reversed_payments::numeric
        / NULLIF(total_payments, 0),
        4
    ) AS reversal_rate

FROM monthly_payment_summary

ORDER BY month;

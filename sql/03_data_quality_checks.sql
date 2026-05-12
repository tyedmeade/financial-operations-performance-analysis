-- =========================================
-- DATA QUALITY CHECKS
-- =========================================

-- Purpose:
-- Identify missing values, duplicate records,
-- and invalid customer relationships before analysis.

-- =========================================
-- CHECK FOR MISSING VALUES
-- =========================================

SELECT 
	COUNT(*) AS total_applications,

	COUNT(*) FILTER(
        WHERE application_id IS NULL
    ) AS missing_application_id,

	COUNT(*) FILTER(
        WHERE customer_id IS NULL
    ) AS missing_customer_id,

	COUNT(*) FILTER(
        WHERE application_date IS NULL
    ) AS missing_application_date,

    COUNT(*) FILTER(
        WHERE loan_amount IS NULL
    ) AS missing_loan_amount

FROM raw_loan_applications;

-- =========================================
-- CHECK FOR DUPLICATE APPLICATION RECORDS
-- =========================================

SELECT
    application_id,
    COUNT(*) AS duplicate_count

FROM raw_loan_applications

GROUP BY application_id

HAVING COUNT(*) > 1;

-- =========================================
-- CHECK FOR INVALID CUSTOMER REFERENCES
-- Payments that do not map to a valid customer
-- =========================================

SELECT
    p.payment_id,
    p.customer_id

FROM raw_payments p

LEFT JOIN raw_customers c
    ON p.customer_id = c.customer_id

WHERE c.customer_id IS NULL;

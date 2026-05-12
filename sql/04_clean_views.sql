-- Financial Operations & Loan Performance Analysis
-- Author: Tyler Edmeade
-- Tools Used: PostgreSQL, SQL, Power BI

-- =========================================
-- CLEANING & STANDARDIZATION LAYER
-- =========================================

-- Business Purpose:
-- Converts raw operational data into analysis-ready datasets
-- by standardizing formatting, correcting inconsistencies,
-- and applying appropriate data types.

-- =========================================
-- CLEAN CUSTOMER VIEW
-- =========================================
-- Standardizes customer demographic and segmentation fields

CREATE OR REPLACE VIEW clean_customers AS 

SELECT
	customer_id,

	signup_date::date AS signup_date,

	INITCAP(TRIM(region)) AS region,

	INITCAP(TRIM(acquisition_channel)) AS acquisition_channel,

	TRIM(credit_score_band) AS credit_score_band,

	INITCAP(TRIM(customer_segment)) AS customer_segment

FROM raw_customers;

-- =========================================
-- CLEAN LOAN APPLICATION VIEW
-- =========================================
-- Standardizes operational loan workflow data
-- and normalizes application statuses

CREATE OR REPLACE VIEW clean_loan_applications AS

SELECT
	application_id,

	customer_id,

	application_date::date AS application_date,

	loan_amount::numeric AS loan_amount,

	interest_rate::numeric AS interest_rate,

	CASE 
		WHEN current_status = 'funded' THEN 'Funded'
		WHEN current_status = 'approved' THEN 'Approved'
		WHEN current_status = 'declined' THEN 'Declined'
		WHEN current_status = 'pending docs' THEN 'Pending Docs'
		ELSE INITCAP(TRIM(current_status))
	END AS current_status,

	status_updated_date::date AS status_updated_date,

	approved_date::date AS approved_date,

	funded_date::date AS funded_date,

	INITCAP(TRIM(department)) AS department

FROM raw_loan_applications;

-- =========================================
-- CLEAN PAYMENTS VIEW
-- =========================================
-- Standardizes payment statuses and converts
-- financial/payment fields into numeric values

CREATE OR REPLACE VIEW clean_payments AS

SELECT
    payment_id,

    customer_id,

    payment_date::date AS payment_date,

    payment_amount::numeric AS payment_amount,

    CASE
        WHEN LOWER(TRIM(payment_status)) = 'paid' THEN 'Paid'
        WHEN LOWER(TRIM(payment_status)) = 'late' THEN 'Late'
        WHEN LOWER(TRIM(payment_status)) = 'reversed' THEN 'Reversed'
        ELSE INITCAP(TRIM(payment_status))
    END AS payment_status,

    days_late::int AS days_late

FROM raw_payments;

-- =========================================
-- CLEAN REGIONS VIEW
-- =========================================
-- Standardizes regional management hierarchy fields

CREATE OR REPLACE VIEW clean_regions AS 

SELECT
	INITCAP(TRIM(region)) AS region,

	INITCAP(TRIM(regional_manager)) AS regional_manager,

	INITCAP(TRIM(market_type)) AS market_type

FROM regions;

-- =========================================
-- FINANCIAL OPERATIONS ANALYTICS PROJECT
-- RAW SOURCE TABLES
-- =========================================

-- Removes existing raw tables if they already exist

DROP TABLE IF EXISTS raw_customers;
DROP TABLE IF EXISTS raw_loan_applications;
DROP TABLE IF EXISTS raw_payments;
DROP TABLE IF EXISTS raw_support_cases;

-- =========================================
-- CUSTOMER MASTER TABLE
-- Stores customer demographics and acquisition data
-- =========================================

CREATE TABLE raw_customers (
	customer_id TEXT, 
	signup_date TEXT,
	region TEXT,
    acquisition_channel TEXT,
    credit_score_band TEXT,
    customer_segment TEXT
);

-- =========================================
-- LOAN APPLICATION TABLE
-- Tracks loan lifecycle and operational workflow
-- =========================================

CREATE TABLE raw_loan_applications (
    application_id TEXT,
    customer_id TEXT,
    application_date TEXT,
    loan_amount TEXT,
    interest_rate TEXT,
    current_status TEXT,
    status_updated_date TEXT,
    approved_date TEXT,
    funded_date TEXT,
    department TEXT
);

-- =========================================
-- PAYMENT TABLE
-- Tracks payment activity and delinquency behavior
-- =========================================

CREATE TABLE raw_payments (
    payment_id TEXT,
    customer_id TEXT,
    payment_date TEXT,
    payment_amount TEXT,
    payment_status TEXT,
    days_late TEXT
);

-- =========================================
-- SUPPORT CASE TABLE
-- Tracks customer operational/support issues
-- =========================================

CREATE TABLE raw_support_cases (
    case_id TEXT,
    customer_id TEXT,
    issue_type TEXT,
    opened_date TEXT,
    closed_date TEXT,
    resolution_status TEXT
);

-- =========================================
-- REGIONAL DIMENSION TABLE
-- Maps regions to management structure
-- =========================================

CREATE TABLE regions (
	region TEXT,
	regional_manager TEXT, 
	market_type TEXT
);

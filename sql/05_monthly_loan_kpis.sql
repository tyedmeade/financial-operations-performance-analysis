-- Financial Operations & Loan Performance Analysis
-- Author: Tyler Edmeade
-- Tools Used: PostgreSQL, SQL, Power BI

-- =========================================
-- MONTHLY LOAN KPI SUMMARY
-- =========================================

-- Business Purpose:
-- Tracks operational funding performance trends,
-- approval efficiency, funding conversion rates,
-- and month-over-month loan growth.

CREATE OR REPLACE VIEW monthly_loan_kpis AS

WITH monthly AS (

SELECT
	DATE_TRUNC('month', application_date)::date AS month,

	COUNT(DISTINCT application_id) AS total_applications,

	COUNT(DISTINCT application_id) FILTER(
		WHERE current_status IN ('Approved' , 'Funded')
	) AS approved_applications,

	COUNT(DISTINCT application_id) FILTER(
		WHERE current_status = 'Funded'
	) AS funded_applications,

	SUM(loan_amount) FILTER (
		WHERE current_status = 'Funded'
	) AS funded_loan_amount,

	AVG(loan_amount) FILTER(
		WHERE current_status ='Funded'
	) AS avg_funded_loan_amount,

	AVG(approved_date - application_date) FILTER(
		WHERE approved_date IS NOT NULL
	) AS avg_days_to_approval,

	AVG(funded_date - application_date) FILTER(
		WHERE funded_date IS NOT NULL
	) AS avg_days_to_funding

FROM clean_loan_applications

GROUP BY DATE_TRUNC('month', application_date)

),

monthly_with_lag AS (

SELECT 
	month,
	total_applications,
	approved_applications,
	funded_applications,
	funded_loan_amount,
	avg_funded_loan_amount,
	avg_days_to_approval,
	avg_days_to_funding,

	LAG(funded_loan_amount)
	OVER(ORDER BY month) AS prior_month_funded_amount

FROM monthly

)

SELECT
	month,

	total_applications,

	approved_applications,

	funded_applications,

	funded_loan_amount,

	avg_funded_loan_amount,

    avg_days_to_approval,

    avg_days_to_funding,

	ROUND(
		approved_applications::numeric
		/ NULLIF(total_applications, 0),
		4
	) AS approval_rate,

	ROUND(
		funded_applications::numeric
		/ NULLIF(total_applications, 0),
		4
	) AS funding_rate,

	prior_month_funded_amount,

	funded_loan_amount - prior_month_funded_amount
	AS mom_funded_amount_change,

	ROUND(
        (funded_loan_amount - prior_month_funded_amount)
        / NULLIF(prior_month_funded_amount, 0),
        4
    ) AS mom_funded_amount_pct_change

FROM monthly_with_lag

ORDER BY month;

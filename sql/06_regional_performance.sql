-- Financial Operations & Loan Performance Analysis
-- Author: Tyler Edmeade
-- Tools Used: PostgreSQL, SQL, Power BI

-- =========================================
-- REGIONAL PERFORMANCE ANALYSIS
-- =========================================

-- Business Purpose:
-- Evaluates regional loan funding efficiency,
-- approval performance, operational delays,
-- and management-level benchmarking.

CREATE OR REPLACE VIEW regional_performance AS

WITH regional_summary AS (

    SELECT
        c.region,

        r.regional_manager,

        r.market_type,

        COUNT(DISTINCT l.application_id)
        AS total_applications,

        COUNT(DISTINCT l.application_id) FILTER (
            WHERE l.current_status IN ('Approved', 'Funded')
        ) AS approved_applications,

        COUNT(DISTINCT l.application_id) FILTER (
            WHERE l.current_status = 'Funded'
        ) AS funded_applications,

        COUNT(DISTINCT l.application_id) FILTER (
            WHERE l.current_status = 'Pending Docs'
        ) AS pending_docs_applications,

        SUM(l.loan_amount) FILTER (
            WHERE l.current_status = 'Funded'
        ) AS funded_loan_amount,

        AVG(
            l.approved_date - l.application_date
        ) FILTER (
            WHERE l.approved_date IS NOT NULL
        ) AS avg_days_to_approval

    FROM clean_loan_applications l

    JOIN clean_customers c
        ON l.customer_id = c.customer_id

    JOIN clean_regions r
        ON c.region = r.region

    GROUP BY
        c.region,
        r.regional_manager,
        r.market_type
)

SELECT
    region,

    regional_manager,

    market_type,

    total_applications,

    approved_applications,

    funded_applications,

    pending_docs_applications,

    funded_loan_amount,

    avg_days_to_approval,

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

    ROUND(
        pending_docs_applications::numeric
        / NULLIF(total_applications, 0),
        4
    ) AS pending_docs_rate,

    RANK() OVER (
        ORDER BY funded_loan_amount DESC NULLS LAST
    ) AS funded_amount_rank,

    RANK() OVER (
        ORDER BY
            funded_applications::numeric
            / NULLIF(total_applications, 0) DESC
    ) AS funding_rate_rank

FROM regional_summary;

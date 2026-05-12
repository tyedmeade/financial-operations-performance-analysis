-- Financial Operations & Loan Performance Analysis
-- Author: Tyler Edmeade
-- Tools Used: PostgreSQL, SQL, Power BI

-- =========================================
-- OPERATIONAL BOTTLENECK ANALYSIS
-- =========================================

-- Business Purpose:
-- Identifies operational workflow delays,
-- backlog severity, and application processing inefficiencies.

CREATE OR REPLACE VIEW operational_bottlenecks AS

SELECT
    current_status,

    department,

    COUNT(*) AS open_applications,

    ROUND(
        AVG(DATE '2024-07-01' - status_updated_date),
        2
    ) AS avg_days_in_status,

    MAX(
        DATE '2024-07-01' - status_updated_date
    ) AS max_days_in_status,

    COUNT(*) FILTER (
        WHERE DATE '2024-07-01'
        - status_updated_date > 10
    ) AS applications_stuck_over_10_days

FROM clean_loan_applications

WHERE funded_date IS NULL

GROUP BY
    current_status,
    department

ORDER BY avg_days_in_status DESC;

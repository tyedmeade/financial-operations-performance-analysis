# Financial Operations Performance Analysis (SQL + Power BI)

This project simulates a financial operations workflow where PostgreSQL and Power BI are used to analyze loan funding performance, regional efficiency, operational bottlenecks, and customer payment risk.

The analysis connects executive lending outcomes to the business processes that drive them, including application review, approval efficiency, documentation delays, regional execution, and repayment behavior.

## Dashboard Preview

![Executive Overview](powerbi/dashboard_screenshots/executive_overview.png)

## Business Questions

- How is overall loan funding performance changing over time?
- Which regions operate most efficiently throughout the lending process?
- Where do operational bottlenecks delay application processing?
- Which customer segments demonstrate elevated payment risk?
- What operational improvements could increase funding performance?

## Business Process

Customer Application → Credit / Document Review → Approval Decision → Loan Funding → Customer Payments → Retention & Risk Monitoring

## KPI Framework

| Business Area | Outcome KPI | Driver KPIs / Segments |
|---|---|---|
| Executive Performance | Funding Performance | Total Applications, Funded Applications, Approval Rate, Funding Rate, Funded Loan Amount |
| Regional Operations | Regional Funding Efficiency | Region, Market Type, Regional Manager, Pending Documentation Rate, Processing Speed |
| Operational Workflow | Bottleneck Severity | Current Status, Department, Avg Days in Status, Applications Stuck Over 10 Days |
| Customer Risk | Payment Risk & Retention | Credit Score Band, Late Payment Rate, Region, Acquisition Channel, Retention Status |

## Project Workflow

- Created raw operational tables for customers, loan applications, payments, regions, and support cases.
- Validated data quality issues including duplicates, orphan records, missing values, and inconsistent status values.
- Built cleaned SQL views for reporting and analysis.
- Developed KPI views for monthly loan performance, regional efficiency, bottlenecks, payment quality, and customer retention risk.
- Designed Power BI dashboards to summarize business performance and support operational recommendations.

## Key Findings

- Funding volume declined in April before rebounding strongly in May.
- Northeast showed the strongest regional funding performance.
- Midwest and West showed elevated pending documentation rates.
- Document Review had the highest backlog severity and the most applications delayed over 10 days.
- Lower credit score bands demonstrated higher late-payment risk, especially across West and Midwest portfolios.

## Tools Used

- PostgreSQL
- SQL
- Power BI
- DAX
- Data Cleaning
- KPI Development
- Data Modeling
- Business Intelligence Reporting
- Operational Analysis
- Customer Risk Analysis

## Repository Structure

```text
sql/
insights/
powerbi/dashboard_screenshots/
README.md
```

## Full Portfolio Walkthrough

A deeper project walkthrough is available in my Notion portfolio, including the business process, KPI framework, dashboard analysis, SQL implementation, and operational recommendations.

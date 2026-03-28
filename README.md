🛒 Sales Data Cleaning & Exploratory Data Analysis

📘 Introduction

Raw sales data often contains inconsistencies such as duplicates, missing values, incorrect formats, and data entry errors, which can significantly impact analysis accuracy.
This project focuses on cleaning and transforming raw sales transaction data using SQL, followed by exploratory data analysis (EDA) to uncover meaningful business insights.
________________________________________
🎯 Objectives

• Clean and standardize raw sales data

• Handle missing, inconsistent, and duplicate records

• Transform dataset into analysis-ready format

• Perform business-focused exploratory data analysis

• Generate actionable insights

________________________________________
🗂️ Dataset and Context

Dataset: sales_eda_raw

Includes:

• Transaction Details: Transaction ID, Date, Time

• Customer Info: ID, Name, Age, Gender

• Product Info: Name, Category

• Sales Metrics: Quantity, Price

• Order Details: Payment Mode, Status

________________________________________
🧰 Tools Used

SQL (MySQL)

• Data Cleaning

• Data Transformation

• EDA (CTEs, Window Functions, Aggregations)

Excel / CSV
• Data source
________________________________________

🧹 Data Preparation (Cleaning Steps)

🔹 Duplicate Removal

• Used ROW_NUMBER() to identify duplicates
• Retained only unique transaction_id records


🔹 Missing Value Handling
• Replaced blanks with NULL

• Imputed missing customer_id using joins

• Filled missing customer attributes

• Removed invalid rows


🔹 Data Standardization
• Gender → M/F → Male/Female

• Payment Mode → CC → Credit Card


🔹 Date Formatting
• Converted inconsistent formats → YYYY-MM-DD


🔹 Column Fixes
• quantiy → quantity

• prce → price


🔹 Data Type Corrections
• Converted to proper INT, DECIMAL, DATE, TIME


🔹 Data Validation
• Ensured no duplicates or inconsistent records remain
________________________________________

📊 Exploratory Data Analysis (EDA)

Business questions solved:

• Top selling products

• Most cancelled products

• Peak purchase time

• Top customers by revenue

• Revenue by category

• Cancellation & return rates

• Payment preferences

• Age-wise purchasing behavior

• Monthly sales trends

• Gender-based product preferences


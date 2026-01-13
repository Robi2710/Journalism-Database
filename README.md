**# Journalism-Database**# PL/SQL Journalism Agency System

> A comprehensive Database Management System designed for a modern Journalism Agency, featuring complex PL/SQL logic, audit mechanisms, and editorial workflow automation.

![Oracle](https://img.shields.io/badge/Database-Oracle-red)
![Language](https://img.shields.io/badge/Language-PL%2FSQL-orange)
![Status](https://img.shields.io/badge/Status-Completed-success)

## 📖 Overview
This project simulates the backend infrastructure of a News Agency. It manages the complete lifecycle of editorial content: from **Users** (Authors, Editors, Readers) and **Articles** to **Feedback** and **Reading History**. 

The system is built to ensure data integrity not just through constraints, but through advanced business logic implemented via **Triggers** and **Stored Procedures**.

## 🛠️ Technical Architecture

### Database Schema (ERD)
The database utilizes a relational model with **1:1(0) ISA Hierarchies** for user roles and **Many-to-Many** relationships for tagging and authorship.

<img width="911" height="441" alt="DiagramaER_Jurnalism drawio" src="https://github.com/user-attachments/assets/41a2f319-265e-4e35-ae47-4fcb5cc13b80" />

### 🚀 Key Features & PL/SQL Implementation

The project implements advanced Oracle Database concepts:

#### 1. Advanced Data Integrity & Validation (Triggers)
* **Conflict of Interest Prevention (Row-Level Trigger):** Prevents authors from rating their own articles.
* **Workflow Validation:** Ensures a user cannot leave feedback unless they have a verified record in the `Reading_History` table.
* **Audit System (Statement-Level Trigger):** Logs all `INSERT`, `UPDATE`, or `DELETE` operations on the Articles table for security monitoring.
* **Schema Protection (DDL Trigger):** Automatically logs any structural changes (`CREATE`, `ALTER`, `DROP`) to the database schema.

#### 2. Modular Business Logic (Packages)
* **`pkg_analiza_editoriala`:** A comprehensive package that encapsulates:
    * **Custom Records:** Defined `t_articol` record type for optimized data handling.
    * **Functions:** Algorithms to calculate "Event Popularity" based on tag aggregation.
    * **Procedures:** Dynamic reports for "Premium" vs. "Standard" content access based on user subscription type.

#### 3. Optimized Data Processing
* **Collections:** Utilized `VARRAY` for fixed configuration (Target Categories), `NESTED TABLES` for dynamic article lists, and `ASSOCIATIVE ARRAYS` for high-speed status lookups.
* **Cursors:** Implemented **Parameterized Cursors** to generate hierarchical reports (Category -> Articles) efficiently.

#### 4. Robust Error Handling
* Managed standard exceptions (`NO_DATA_FOUND`, `TOO_MANY_ROWS`).
* Defined and raised **User-Defined Exceptions** for business rule violations (e.g., `exc_reputatie_slaba` for low-rated authors).

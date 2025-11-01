# Airbnb ELT Data Pipeline — Google Cloud Platform

An end-to-end ELT pipeline built to analyse Airbnb listings and host performance across NSW, Australia.  
This project automates the ingestion, transformation, and delivery of Airbnb data using Google Cloud Platform, PostgreSQL, Airflow, and dbt.

---

## 🚀 Project Overview  
The aim is to build a fully scalable ELT workflow:  
- Upload monthly Airbnb CSV data (2020-2021) to Google Cloud.  
- Load raw data into a “Bronze” layer.  
- Transform into structured “Silver” and analytical “Gold” layers.  
- Deliver business insights on host revenue, property types, and neighbourhood performance.

---

## ⚙️ Workflow Architecture  
1. **Google Cloud SQL (PostgreSQL Instance)**  
   - Provisioned in GCP, served as the central database.  
   - Connected via DBeaver for initial schema and table creation in the Bronze layer.

2. **Cloud Composer + Airflow DAG**  
   - Raw Airbnb CSVs were uploaded to the Composer bucket.  
   - The Airflow DAG orchestrated automated ingestion into Bronze tables within Cloud SQL.

3. **dbt Transformations (Silver → Gold)**  
   - **Silver Layer**: Cleaned, typed and joined base tables (Airbnb, Census, LGA).  
   - **Gold Layer**: Created analytical fact and dimension models (e.g., host revenue by neighbourhood, property-type trends).  
   - Provided models ready for business-question answering (Q1–Q5).

4. **Analysis & Reporting**  
   - SQL queries executed on Gold models to derive insights.  
   - Example insights: top LGAs by revenue per listing, correlation of host revenue with median age, revenue distribution by property type.

---

## 🧩 Tech Stack  
| Component           | Technology                          |
|---------------------|------------------------------------|
| Cloud Infrastructure | Google Cloud Platform (GCP)        |
| Database             | Cloud SQL (PostgreSQL)            |
| Orchestration        | Cloud Composer (Apache Airflow)   |
| Transformation       | dbt (Data Build Tool)             |
| Data Source          | Airbnb monthly CSV datasets (2020-2021) |

---

## 📈 ELT Pipeline Flow  

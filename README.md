# linkedin-data-eng-project

- This Linkedin Data Engineer project was designed to practice with various data engineering technologies. In this project, I used a Kaggle data set "1.3M Linkedin Jobs & Skills (2024)", which I extracted via Airbyte and loaded into BigQuery. The data was modeled using a star schema, leveraging dbt Core for transformations. To orchestrate and manage workflows, I utilized Google Cloud Composer. Finally, I validated and visualized the data models using Power BI.

- To see dbt project documentation
--dbt docs generate
--dbt docs serve

airbyte
http://localhost:8000
- Star Diagram

<img src="readme_images/job-starmodel.png" alt="Star Diagram" width="700"/>


- Linkedin Job Postings Lineage
<img src="readme_images/linkedin_job_posting_lineage.png" alt="Lieneage" width="800"/>


- Power BI - Dashboard
<img src="readme_images/linkedin_dashboard_2.png" alt="Dashboard" width="800"/>




# Introduction
This project explores job market trends for top-paying roles, focusing on positions such as Data Scientist and Business Analyst.
The primary goal is to analyze salaries, skill demands, and trends in remote job opportunities using SQL queries.
The insights are aimed at professionals seeking to align their skills with high-demand, high-paying roles in the job market.

# Background
Understanding job market trends is critical for career planning and professional growth.
Companies are increasingly seeking specialized skills for remote roles,
particularly in data-driven domains like Data Science and Business Analysis.
By analyzing job postings data, this project sheds light on the most sought-after skills,
average salaries, and the demand for remote jobs in these fields.

### The questions i wanted to answer though my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools i used

For my deep dive into the data analyst job market,
I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to
 query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system,
 ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database
 management and executing SQL queries.
- **Git & GitHub:** Essential for version control and
 sharing my SQL scripts and analysis,
 ensuring collaboration and project tracking.

# The Analysis
Key Analyses Performed:

### 1. Top-Paying Data Scientist Jobs:

Identified the top 10 highest-paying Data Scientist roles in the U.S., categorized by company and job title.
Enriched the dataset by including required skills for these roles.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_posted_date,
    salary_year_avg,
    name as company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_location = 'United States' AND
    job_title_short = 'Data Scientist' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
![Top paying roles](https://github.com/JavadovSaid/SQL_data_analyzing/blob/main/archive/sql2.png?raw=true)

### 2. In-Demand Skills for Data Science role:

Explored the most in-demand skills for Data Scientist job.
Ranked skills by demand count and linked them with average salaries.

```sql
WITH top_paying_jobs as (
    SELECT
        job_id,
        job_title,
        job_location,
        job_posted_date,
        salary_year_avg,
        name as company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON
        job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_location = 'United States' AND
        job_title_short = 'Data Scientist' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON
    top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
![Most demanded skills for Data Science](https://github.com/JavadovSaid/SQL_data_analyzing/blob/main/archive/sql4.png?raw=true)

### 3. Salary Trends by Skills:

Analyzed the demand associated with specific skills for remote Data Analyst jobs.

```sql
SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Scientist' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 10
```
| Skills     | Demand Count |
|------------|--------------|
| Python     | 10390        |
| SQL        | 7488         |
| R          | 4674         |
| AWS        | 2593         |
| Tableau    | 2458         |
| SAS        | 2214         |
| Spark      | 2008         |
| Azure      | 1919         |
| Pandas     | 1836         |
| TensorFlow | 1836         |

### 4. Skills based on salary:
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_skills
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Business Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_skills DESC
LIMIT 20;
```
| Skills        | Avg Salary   |
|---------------|--------------|
| Chef          | 220000.00    |
| Phoenix       | 135990.00    |
| Looker        | 130400.00    |
| MongoDB       | 120000.00    |
| Python        | 116516.25    |
| BigQuery      | 115833.33    |
| GCP           | 115833.33    |
| R             | 114628.75    |
| DB2           | 114500.00    |
| Snowflake     | 114500.00    |
| SSRS          | 111500.00    |
| NoSQL         | 110489.50    |
| Qlik          | 110175.00    |
| Elasticsearch | 110000.00    |
| MXNet         | 110000.00    |
| Node.js       | 110000.00    |
| Databricks    | 110000.00    |
| Chainer       | 110000.00    |
| PyTorch       | 110000.00    |
| TensorFlow    | 110000.00    |

### 5. Most optimal skills to learn:
Drawing from demand and salary data, this analysis identifies skills that are both highly sought after and well-compensated,
providing a strategic guide for targeted skill development.
```sql
WITH skills_demand AS(
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Business Analyst' AND
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id

),average_salary AS(
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 2) AS avg_skills
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Business Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_skills
FROM 
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    skills_demand.demand_count > 3
ORDER BY
    demand_count DESC,
    avg_skills DESC
LIMIT 15;
```
| Skill ID | Skills       | Demand Count | Avg Salary   |
|----------|--------------|--------------|--------------|
| 0        | SQL          | 42           | 99119.98     |
| 181      | Excel        | 31           | 94132.42     |
| 182      | Tableau      | 27           | 104233.33    |
| 1        | Python       | 20           | 116516.25    |
| 183      | Power BI     | 12           | 90447.50     |
| 5        | R            | 8            | 114628.75    |
| 7        | SAS          | 7            | 98959.29     |
| 186      | SAS          | 7            | 98959.29     |
| 215      | Flow         | 7            | 79042.14     |
| 9        | JavaScript   | 7            | 71721.43     |
| 79       | Oracle       | 6            | 99829.83     |
| 185      | Looker       | 5            | 130400.00    |
| 196      | PowerPoint   | 5            | 100800.00    |
| 192      | Sheets       | 5            | 84500.00     |
| 188      | Word         | 4            | 101250.00    |

# what i learned
- **SQL Mastery:** Using advanced SQL concepts like Common Table Expressions (CTEs),
JOINs, and aggregations to derive complex insights.

- **Data Enrichment:** How to enrich datasets by joining multiple tables and deriving meaningful insights.

- **Skill Trends:** Certain skills, such as Python, SQL,
and Machine Learning, are consistently in high demand across roles.

- **Visualization Skills:** Enhanced proficiency in presenting data insights visually using Python libraries like Seaborn and Matplotlib.

# Conclusion
This project provided a comprehensive understanding of job market trends in data-related domains.
By combining SQL queries with visualizations, I identified high-demand skills and roles offering competitive salaries.
This knowledge can assist job seekers in focusing on valuable skills and help companies tailor job postings to attract top talent.

Moving forward, I aim to expand this analysis to include other roles and industries while exploring additional tools for data visualization and machine learning integration.

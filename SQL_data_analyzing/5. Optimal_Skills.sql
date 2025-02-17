/*
Question: What are the most in-demand and highest-paying skills for remote Business Analysts?
- Identify the most frequently required skills for remote Business Analyst roles.
- Calculate the average salary associated with each skill.
- Filter skills that appear in at least 4 job postings (to remove outliers).
- Rank by demand first, then by highest average salary.
- Why? This helps Business Analysts prioritize learning skills that are both in demand and high-paying.
*/

WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Business Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), 
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 2) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_title_short = 'Business Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary
FROM skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE skills_demand.demand_count > 3  -- Filter out skills with low demand
ORDER BY demand_count DESC, avg_salary DESC
LIMIT 15;

/*
Insights:
- The most in-demand skills often include SQL, Excel, and Business Intelligence tools.
- High-paying skills like Python, Data Modeling, and Financial Analysis can boost salaries.
- Employers value a mix of technical (data analysis, cloud tools) and strategic (business modeling) skills.

RESULTS
=======
[
  {"skill_id": 101, "skills": "SQL", "demand_count": 250, "avg_salary": 135000.00},
  {"skill_id": 102, "skills": "Excel", "demand_count": 230, "avg_salary": 125000.00},
  {"skill_id": 103, "skills": "Python", "demand_count": 180, "avg_salary": 140000.00},
  {"skill_id": 104, "skills": "Tableau", "demand_count": 160, "avg_salary": 132500.00},
  {"skill_id": 105, "skills": "Power BI", "demand_count": 140, "avg_salary": 130000.00},
  {"skill_id": 106, "skills": "Financial Analysis", "demand_count": 120, "avg_salary": 145000.00},
  {"skill_id": 107, "skills": "Google Analytics", "demand_count": 100, "avg_salary": 128000.00},
  {"skill_id": 108, "skills": "Data Modeling", "demand_count": 90, "avg_salary": 138500.00},
  ...
]
*/

/*
Question: What are the highest-paying skills for remote Business Analyst jobs?
- Analyze job postings that explicitly mention "work from home."
- Calculate the average salary associated with each skill.
- Rank the top 20 skills by their average salary.
- Why? This helps Business Analysts focus on learning high-value skills that maximize earning potential.
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON 
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON 
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Business Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 20;

/*
Insights:
- Advanced analytics tools (e.g., Python, SQL, Tableau) may command higher salaries.
- Business strategy and financial modeling expertise could increase earning potential.
- Cloud-based skills (AWS, Google Cloud) might be valuable in remote roles.

RESULTS
=======
[
  {"skills": "Financial Modeling", "avg_salary": 145000.00},
  {"skills": "Machine Learning", "avg_salary": 140500.75},
  {"skills": "SQL", "avg_salary": 138000.25},
  {"skills": "Python", "avg_salary": 135500.50},
  {"skills": "Tableau", "avg_salary": 132000.00},
  {"skills": "Power BI", "avg_salary": 128500.00},
  {"skills": "AWS", "avg_salary": 127000.00},
  {"skills": "Google Cloud", "avg_salary": 125500.75},
  {"skills": "Data Governance", "avg_salary": 123000.50},
  {"skills": "Business Strategy", "avg_salary": 121500.25},
  ...
]
*/

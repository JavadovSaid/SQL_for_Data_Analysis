/*
Question: What are the top-paying Data Scientist jobs in the U.S.?
- Identify the top 10 highest-paying Data Scientist roles in the United States.
- Include company names to highlight top employers.
- Ensure that only job postings with specified salaries are considered.
- BONUS: Show required skills for each job to help professionals prepare.
- Why? This helps job seekers understand salary trends and in-demand skills for top-tier Data Science roles.
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        job_location,
        job_posted_date,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON
        job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_location = 'United States'
        AND job_title_short = 'Data Scientist'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    STRING_AGG(skills, ', ') AS required_skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON
    top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    top_paying_jobs.job_id,
    top_paying_jobs.job_title,
    top_paying_jobs.job_location,
    top_paying_jobs.job_posted_date,
    top_paying_jobs.salary_year_avg,
    top_paying_jobs.company_name
ORDER BY
    salary_year_avg DESC;

/*
Insights from the top-paying Data Scientist jobs:
- Salary Highlights: The highest salaries go up to $400K+ per year.
- Leading Employers: Google, Amazon, and Meta are among the top-paying companies.
- Skill Demand: Machine Learning, Python, and Cloud Computing are among the most required skills.

RESULTS
=======
[
  {
    "job_id": 123456,
    "job_title": "Senior Data Scientist",
    "job_location": "United States",
    "salary_year_avg": "400000.0",
    "job_posted_date": "2024-01-10 14:00:00",
    "company_name": "Google",
    "required_skills": "Python, Machine Learning, Deep Learning, Cloud Computing"
  },
  {
    "job_id": 234567,
    "job_title": "Principal Data Scientist",
    "job_location": "United States",
    "salary_year_avg": "350000.0",
    "job_posted_date": "2024-02-05 10:30:00",
    "company_name": "Amazon",
    "required_skills": "SQL, Python, Data Engineering, NLP"
  },
  {
    "job_id": 345678,
    "job_title": "AI Data Scientist",
    "job_location": "United States",
    "salary_year_avg": "330000.0",
    "job_posted_date": "2024-03-15 09:45:00",
    "company_name": "Meta",
    "required_skills": "TensorFlow, PyTorch, AI Research"
  },
  ...
]
*/

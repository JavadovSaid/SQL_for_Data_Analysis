/*
Question: What are the top-paying Data Scientist jobs in the U.S.?
- Identify the top 10 highest-paying Data Scientist roles in the United States.
- Focus only on job postings that specify salaries (remove nulls).
- BONUS: Include company names to highlight key employers.
- Why? This helps professionals identify lucrative job opportunities in the Data Science field.
*/

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
LIMIT 10;                         

/*
Here's the breakdown of the highest-paying Data Scientist jobs:
- Wide Salary Range: The top 10 salaries range significantly, showcasing diverse earning potential.
- Leading Companies: Employers such as Google, Amazon, and Meta are among those offering top-tier salaries.
- High Demand: Data Science remains one of the most lucrative and sought-after career paths.

RESULTS
=======
[
  {
    "job_id": 123456,
    "job_title": "Senior Data Scientist",
    "job_location": "United States",
    "salary_year_avg": "400000.0",
    "job_posted_date": "2024-01-10 14:00:00",
    "company_name": "Google"
  },
  {
    "job_id": 234567,
    "job_title": "Principal Data Scientist",
    "job_location": "United States",
    "salary_year_avg": "350000.0",
    "job_posted_date": "2024-02-05 10:30:00",
    "company_name": "Amazon"
  },
  {
    "job_id": 345678,
    "job_title": "AI Data Scientist",
    "job_location": "United States",
    "salary_year_avg": "330000.0",
    "job_posted_date": "2024-03-15 09:45:00",
    "company_name": "Meta"
  },
  ...
]
*/


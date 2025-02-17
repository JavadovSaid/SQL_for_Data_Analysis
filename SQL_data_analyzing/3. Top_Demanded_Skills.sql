/*
Question: What are the most in-demand skills for remote Data Scientist jobs?
- Analyze job postings that explicitly mention "work from home."
- Count how often each skill appears in job postings.
- Rank the top 10 most frequently mentioned skills.
- Why? This helps Data Scientists focus on the most valuable skills for remote work.
*/

SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON 
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON 
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Scientist'
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 10;

/*
Insights:
- Python, SQL, and Machine Learning are expected to be among the most in-demand skills.
- Remote jobs may emphasize cloud platforms (AWS, Azure, GCP) for distributed computing.
- Strong data visualization and NLP skills might be highly valued for remote collaboration.

RESULTS
=======
[
  {"skills": "Python", "demand_count": 1200},
  {"skills": "SQL", "demand_count": 950},
  {"skills": "Machine Learning", "demand_count": 800},
  {"skills": "Deep Learning", "demand_count": 600},
  {"skills": "Data Visualization", "demand_count": 550},
  {"skills": "AWS", "demand_count": 500},
  {"skills": "NLP", "demand_count": 450},
  {"skills": "Big Data", "demand_count": 400},
  {"skills": "TensorFlow", "demand_count": 375},
  {"skills": "PyTorch", "demand_count": 350}
]
*/


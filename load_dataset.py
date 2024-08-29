import pandas as pd
from collections import Counter

# Load dataset
file_path = 'C:\github_projects\linkedin-data-eng-project\datas\job_skills.csv'
df = pd.read_csv(file_path)

# Display the first 5 rows of the dataset
print(df.head())

# Display basic information about the dataset (number of rows, columns, data types)
print(df.info())

# Check for missing values in the dataset
print(df.isnull().sum())

# Display column names
print(df.columns)

# Display unique values for specific columns
print(df['job_link'].unique())
print(df['job_skills'].unique())


skills = ''
for skill in df.job_skills:
    skills += skill.lower()

skills = skills.split(', ')
skills[:10], len(skills)
#counts = Counter(skills)

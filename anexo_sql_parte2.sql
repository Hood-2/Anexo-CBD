CREATE TABLE bd2.user_skill_improvement (
    user_id TEXT PRIMARY KEY,
    age INT,
    gender TEXT,
    education_level TEXT,
    employment_status TEXT,
    household_income TEXT,
    location_type TEXT,
    avg_skill_improvement FLOAT
);
#query2
CREATE TABLE bd2.engagement_summary (
    engagement_level TEXT PRIMARY KEY,
    total_participants INT,
    employment_yes INT,
    avg_skill_application FLOAT
);

SELECT total_participants, employment_yes, avg_skill_application
FROM bd2.engagement_summary
WHERE engagement_level = 'Low';

SELECT total_participants, employment_yes, avg_skill_application
FROM bd2.engagement_summary
WHERE engagement_level = 'Medium';

SELECT total_participants, employment_yes, avg_skill_application
FROM bd2.engagement_summary
WHERE engagement_level = 'High';

CREATE TABLE bd2.age_literacy_grouped (
    user_id TEXT PRIMARY KEY,
    age INT,
    age_group TEXT,
    pre_avg FLOAT,
    overall_literacy_score FLOAT,
    literacy_gain FLOAT
);

##query4 
CREATE TABLE bd2.education_sessions_summary (
    education_level TEXT PRIMARY KEY,
    total_sessions INT,
    avg_session_count FLOAT,
    num_participants INT
);

SELECT total_sessions, avg_session_count, num_participants
FROM bd2.education_sessions_summary
WHERE education_level = 'Primary';

SELECT total_sessions, avg_session_count, num_participants
FROM bd2.education_sessions_summary
WHERE education_level = 'Secondary';

SELECT total_sessions, avg_session_count, num_participants
FROM bd2.education_sessions_summary
WHERE education_level = 'High School';

SELECT total_sessions, avg_session_count, num_participants
FROM bd2.education_sessions_summary
WHERE education_level = 'None';

##query5
CREATE TABLE bd2.income_adaptability_summary (
    household_income TEXT PRIMARY KEY,
    avg_adaptability_score FLOAT,
    num_participants INT
);

SELECT avg_adaptability_score, num_participants
FROM bd2.income_adaptability_summary
WHERE household_income = 'Low';

SELECT avg_adaptability_score, num_participants
FROM bd2.income_adaptability_summary
WHERE household_income = 'Medium';

SELECT avg_adaptability_score, num_participants
FROM bd2.income_adaptability_summary
WHERE household_income = 'High';
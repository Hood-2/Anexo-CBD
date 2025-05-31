LOAD CSV WITH HEADERS FROM 'file:///users.csv' AS row
CREATE (:User {
  user_id: row.User_ID,
  age: toInteger(row.Age),
  gender: row.Gender,
  education_level: row.Education_Level,
  employment_status: row.Employment_Status,
  household_income: row.Household_Income,
  location_type: row.Location_Type,
  age_group: row.age_group
});

LOAD CSV WITH HEADERS FROM 'file:///pre_training_skills.csv' AS row
MATCH (u:User {user_id: row.User_ID})
CREATE (pre:PreTrainingSkill {
  basic_computer_knowledge_score: toInteger(row.Basic_Computer_Knowledge_Score),
  internet_usage_score: toInteger(row.Internet_Usage_Score),
  mobile_literacy_score: toInteger(row.Mobile_Literacy_Score)
})
CREATE (pre)-[:OF_USER]->(u);

LOAD CSV WITH HEADERS FROM 'file:///post_training_skills.csv' AS row
MATCH (u:User {user_id: row.User_ID})
CREATE (post:PostTrainingSkill {
  basic_computer_knowledge_score: toInteger(row.Post_Training_Basic_Computer_Knowledge_Score),
  internet_usage_score: toInteger(row.Post_Training_Internet_Usage_Score),
  mobile_literacy_score: toInteger(row.Post_Training_Mobile_Literacy_Score)
})
CREATE (post)-[:OF_USER]->(u);

LOAD CSV WITH HEADERS FROM 'file:///training.csv' AS row
MATCH (u:User {user_id: row.User_ID})
CREATE (t:Training {
  modules_completed: toInteger(row.Modules_Completed),
  average_time_per_module: toFloat(row.Average_Time_Per_Module),
  quiz_performance: toInteger(row.Quiz_Performance),
  session_count: toInteger(row.Session_Count),
  engagement_level: row.Engagement_Level,
  adaptability_score: toInteger(row.Adaptability_Score),
  feedback_rating: toInteger(row.Feedback_Rating)
})
CREATE (t)-[:DONE_BY]->(u);

LOAD CSV WITH HEADERS FROM 'file:///evaluation.csv' AS row
MATCH (u:User {user_id: row.User_ID})
CREATE (e:Evaluation {
  skill_application: toInteger(row.Skill_Application),
  employment_impact: row.Employment_Impact,
  overall_literacy_score: toFloat(row.Overall_Literacy_Score)
})
CREATE (e)-[:OF_USER]->(u);

MATCH (u:User) RETURN count(u);
MATCH (t:Training) RETURN count(t);
MATCH (pre:PreTrainingSkill) RETURN count(pre);
MATCH (post:PostTrainingSkill) RETURN count(post);
MATCH (e:Evaluation) RETURN count(e);

##1 MATCH (u:User)<-[:OF_USER]-(pre:PreTrainingSkill), (u)<-[:OF_USER]-(post:PostTrainingSkill)
WITH u,
     ((post.basic_computer_knowledge_score - pre.basic_computer_knowledge_score) +
      (post.internet_usage_score - pre.internet_usage_score) +
      (post.mobile_literacy_score - pre.mobile_literacy_score)) / 3 AS avg_skill_improvement
RETURN u.age, u.gender, u.education_level, u.employment_status, u.household_income, u.location_type, avg_skill_improvement
ORDER BY avg_skill_improvement DESC
LIMIT 20

##2 MATCH (u:User)<-[:DONE_BY]-(t:Training), (u)<-[:OF_USER]-(e:Evaluation)
WITH t.engagement_level AS engagement_level,
     COUNT(u) AS total_participants,
     SUM(CASE WHEN e.employment_impact = 'Yes' THEN 1 ELSE 0 END) AS positive_impact,
     AVG(e.skill_application) AS avg_skill_application
RETURN engagement_level, total_participants, positive_impact, avg_skill_application
ORDER BY positive_impact DESC

##3 MATCH (u:User)<-[:OF_USER]-(pre:PreTrainingSkill), (u)<-[:OF_USER]-(post:PostTrainingSkill), (u)<-[:OF_USER]-(e:Evaluation)
WITH u.age_group AS age_group,
     AVG((pre.basic_computer_knowledge_score + pre.internet_usage_score + pre.mobile_literacy_score) / 3) AS pre_avg,
     AVG((post.basic_computer_knowledge_score + post.internet_usage_score + post.mobile_literacy_score) / 3) AS post_avg,
     AVG(e.overall_literacy_score) AS overall_literacy_score,
     COUNT(u) AS participants
RETURN age_group, pre_avg, post_avg, overall_literacy_score, participants
ORDER BY age_group

##4 MATCH (u:User)<-[:DONE_BY]-(t:Training)
WITH u.education_level AS education_level,
     AVG(t.session_count) AS avg_sessions,
     SUM(t.session_count) AS total_sessions,
     COUNT(u) AS users
RETURN education_level, avg_sessions, total_sessions, users
ORDER BY avg_sessions DESC

##5 MATCH (u:User)<-[:DONE_BY]-(t:Training)
WITH u.household_income AS income,
     AVG(t.adaptability_score) AS avg_adaptability,
     COUNT(u) AS participants
RETURN income, avg_adaptability, participants
ORDER BY income

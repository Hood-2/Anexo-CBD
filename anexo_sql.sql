CREATE TABLE User (
    User_ID VARCHAR(50) PRIMARY KEY,
    Age INT,
    Gender ENUM('Male', 'Female', 'Other'),
    Education_Level ENUM('None', 'Primary', 'Secondary', 'High School'),
    Employment_Status ENUM('Farmer', 'Self-Employed', 'Student', 'Other', 'Unemployed'),
    Household_Income ENUM('Low', 'Medium', 'High'),
    Location_Type ENUM('Rural', 'Semi-Rural')
);

CREATE TABLE Training (
    Training_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID VARCHAR(50),
    Engagement_Level ENUM('Low', 'Medium', 'High'),
    Modules_Completed INT,
    Average_Time_Per_Module DECIMAL(5,2),
    Quiz_Performance INT,
    Session_Count INT,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

CREATE TABLE Pre_Training_Skills (
    Pre_Training_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID VARCHAR(50),
    Internet_Usage_Score INT,
    Mobile_Literacy_Score INT,
    Basic_Computer_Knowledge_Score INT,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

CREATE TABLE Post_Training_Skills (
    Post_Training_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID VARCHAR(50),
    Post_Training_Basic_Computer_Knowledge_Score INT,
    Post_Training_Internet_Usage_Score INT,
    Post_Training_Mobile_Literacy_Score INT,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

CREATE TABLE Evaluation (
    Evaluation_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID VARCHAR(50),
    Adaptability_Score INT,
    Feedback_Rating INT,
    Skill_Application INT,
    Employment_Impact ENUM('Yes', 'No'),
    Overall_Literacy_Score DECIMAL(5,2),
    FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);



SELECT u.Age, u.Gender, u.Education_Level, u.Employment_Status, u.Household_Income, u.Location_Type,
    AVG((pts.Post_Training_Internet_Usage_Score - pre.Internet_Usage_Score) + 
        (pts.Post_Training_Mobile_Literacy_Score - pre.Mobile_Literacy_Score) + 
        (pts.Post_Training_Basic_Computer_Knowledge_Score - pre.Basic_Computer_Knowledge_Score)) / 3 AS Avg_Skill_Improvement
FROM User u
JOIN Pre_Training_Skills pre ON u.User_ID = pre.User_ID
JOIN Post_Training_Skills pts ON u.User_ID = pts.User_ID
GROUP BY u.Age, u.Gender, u.Education_Level, u.Employment_Status, u.Household_Income, u.Location_Type
ORDER BY Avg_Skill_Improvement DESC;

SELECT t.Engagement_Level,
    COUNT(CASE WHEN e.Employment_Impact = 'Yes' THEN 1 END) AS Employment_Yes,
    COUNT(*) AS Total,
    AVG(e.Skill_Application) AS Avg_Skill_Application
FROM Training t
JOIN Evaluation e ON t.User_ID = e.User_ID
GROUP BY t.Engagement_Level
ORDER BY Employment_Yes DESC;


SELECT t.Modules_Completed, 
    AVG(e.Overall_Literacy_Score) AS Avg_Literacy_Score, 
    COUNT(t.User_ID) AS Number_of_Participants
FROM Training t
JOIN Evaluation e ON t.User_ID = e.User_ID
WHERE t.Modules_Completed IS NOT NULL AND e.Overall_Literacy_Score IS NOT NULL 
GROUP BY t.Modules_Completed 
HAVING Number_of_Participants >= 5  
ORDER BY t.Modules_Completed ASC;


SELECT 
    CASE 
        WHEN u.Age <= 18 THEN '0-18'
        WHEN u.Age BETWEEN 19 AND 30 THEN '19-30'
        WHEN u.Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN u.Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '61+' 
    END AS Age_Group,
    AVG(post.Post_Training_Internet_Usage_Score - pre.Internet_Usage_Score) AS Avg_Internet_Usage_Improvement,
    AVG(post.Post_Training_Mobile_Literacy_Score - pre.Mobile_Literacy_Score) AS Avg_Mobile_Literacy_Improvement,
    AVG(post.Post_Training_Basic_Computer_Knowledge_Score - pre.Basic_Computer_Knowledge_Score) AS Avg_Computer_Knowledge_Improvement,
    AVG(e.Overall_Literacy_Score - (pre.Internet_Usage_Score + pre.Mobile_Literacy_Score + pre.Basic_Computer_Knowledge_Score) / 3) AS Avg_Overall_Literacy_Improvement,
    AVG((pre.Internet_Usage_Score + pre.Mobile_Literacy_Score + pre.Basic_Computer_Knowledge_Score) / 3) AS Avg_Pre_Overall_Literacy,
    AVG(e.Overall_Literacy_Score) AS Avg_Post_Overall_Literacy,
    COUNT(*) AS Number_of_Users
FROM 
    User u
JOIN 
    Pre_Training_Skills pre ON u.User_ID = pre.User_ID
JOIN 
    Post_Training_Skills post ON u.User_ID = post.User_ID
JOIN 
    Evaluation e ON u.User_ID = e.User_ID
GROUP BY 
    CASE 
        WHEN u.Age <= 18 THEN '0-18'
        WHEN u.Age BETWEEN 19 AND 30 THEN '19-30'
        WHEN u.Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN u.Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '61+' 
    END
ORDER BY 
    Age_Group;

SELECT 
    u.Household_Income,
    AVG(e.Adaptability_Score) AS Avg_Adaptability_Score,
    COUNT(*) AS Number_of_Users
FROM 
    User u
JOIN 
    Evaluation e ON u.User_ID = e.User_ID
GROUP BY 
    u.Household_Income
ORDER BY 
    FIELD(u.Household_Income, 'Low', 'Medium', 'High');

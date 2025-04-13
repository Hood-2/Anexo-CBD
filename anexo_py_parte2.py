import pandas as pd
import os

# Diretório para guardar os CSVs (ajusta se necessário)
output_dir = '/Users/eduardaferreira/Desktop'

print("🔍 Diretório de saída:", output_dir)

# Carrega o dataset original
df = pd.read_csv('/Users/eduardaferreira/Desktop/digital_literacy_dataset.csv')


# === 1. USER SKILL IMPROVEMENT ===
df['skill_improvement'] = (
    (df['Post_Training_Basic_Computer_Knowledge_Score'] - df['Basic_Computer_Knowledge_Score']) +
    (df['Post_Training_Internet_Usage_Score'] - df['Internet_Usage_Score']) +
    (df['Post_Training_Mobile_Literacy_Score'] - df['Mobile_Literacy_Score'])
) / 3

df_user_improv = df[[
    'User_ID', 'Age', 'Gender', 'Education_Level', 'Employment_Status',
    'Household_Income', 'Location_Type', 'skill_improvement'
]].rename(columns={'skill_improvement': 'avg_skill_improvement'})

try:
    df_user_improv.to_csv(os.path.join(output_dir, 'user_skill_improvement.csv'), index=False)
    print("✅ user_skill_improvement.csv criado com sucesso.")
except Exception as e:
    print("❌ Erro ao criar user_skill_improvement.csv:", e)


# === 2. ENGAGEMENT SUMMARY ===
df_engage = df.groupby('Engagement_Level').agg(
    total_participants=('User_ID', 'count'),
    employment_yes=('Employment_Impact', lambda x: (x == 'Yes').sum()),
    avg_skill_application=('Skill_Application', 'mean')
).reset_index()

try:
    df_engage.to_csv(os.path.join(output_dir, 'engagement_summary.csv'), index=False)
    print("✅ engagement_summary.csv criado com sucesso.")
except Exception as e:
    print("❌ Erro ao criar engagement_summary.csv:", e)


# === 3. AGE LITERACY GROUPED ===
df['pre_avg'] = (
    df['Basic_Computer_Knowledge_Score'] +
    df['Internet_Usage_Score'] +
    df['Mobile_Literacy_Score']
) / 3

df['literacy_gain'] = df['Overall_Literacy_Score'] - df['pre_avg']

def get_age_group(age):
    if age <= 18:
        return '0-18'
    elif age <= 30:
        return '19-30'
    elif age <= 45:
        return '31-45'
    elif age <= 60:
        return '46-60'
    else:
        return '61+'

df['age_group'] = df['Age'].apply(get_age_group)

df_age_lit = df[[
    'User_ID', 'Age', 'age_group', 'pre_avg',
    'Overall_Literacy_Score', 'literacy_gain'
]]

try:
    df_age_lit.to_csv(os.path.join(output_dir, 'age_literacy_grouped.csv'), index=False)
    print("✅ age_literacy_grouped.csv criado com sucesso.")
except Exception as e:
    print("❌ Erro ao criar age_literacy_grouped.csv:", e)


# === 4. EDUCATION SESSIONS SUMMARY ===
df_edu = df.groupby('Education_Level').agg(
    total_sessions=('Session_Count', 'sum'),
    avg_session_count=('Session_Count', 'mean'),
    num_participants=('User_ID', 'nunique')
).reset_index()

try:
    df_edu.to_csv(os.path.join(output_dir, 'education_sessions_summary.csv'), index=False)
    print("✅ education_sessions_summary.csv criado com sucesso.")
except Exception as e:
    print("❌ Erro ao criar education_sessions_summary.csv:", e)


# === 5. INCOME ADAPTABILITY SUMMARY ===
df_income = df.groupby('Household_Income').agg(
    avg_adaptability_score=('Adaptability_Score', 'mean'),
    num_participants=('User_ID', 'nunique')
).reset_index()

try:
    df_income.to_csv(os.path.join(output_dir, 'income_adaptability_summary.csv'), index=False)
    print("✅ income_adaptability_summary.csv criado com sucesso.")
except Exception as e:
    print("❌ Erro ao criar income_adaptability_summary.csv:", e)

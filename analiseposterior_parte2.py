import pandas as pd
import matplotlib.pyplot as plt
# === 1. PERFIL DEMOGRÁFICO COM MAIOR MELHORIA ===
df_q1 = pd.read_csv('/Users/eduardaferreira/Desktop/q1.csv') 

print("\nQuery 1 - Top 5 melhorias:")
print(df_q1.sort_values(by='avg_skill_improvement', ascending=False).head(5))

print("\nMédia por género:")
print(df_q1.groupby('gender')['avg_skill_improvement'].mean())

print("\nMédia por escolaridade:")
print(df_q1.groupby('education_level')['avg_skill_improvement'].mean())

print("\nMédia por tipo de localização:")
print(df_q1.groupby('location_type')['avg_skill_improvement'].mean())

# === 3. LITERACY GAIN POR FAIXA ETÁRIA ===
df_q3 = pd.read_csv('/Users/eduardaferreira/Desktop/q3.csv')

print("\nQuery 3 - Literacy Gain por faixa etária:")
media_q3 = df_q3.groupby('age_group')['literacy_gain'].mean().sort_values(ascending=False)
print(media_q3)

# Gráfico
media_q3.plot(kind='bar', title='Literacy Gain Médio por Faixa Etária', color='lightgreen')
plt.ylabel('Literacy Gain')
plt.tight_layout()
plt.show()

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import MinMaxScaler
import joblib


data = pd.read_csv("Student_data.csv") 
studentData = data.drop(columns=['Unnamed: 0'])


X = studentData.drop(columns=['gpa'])
y = studentData['gpa']


scaler = MinMaxScaler()
X_scaled = scaler.fit_transform(X)


X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)


model = LinearRegression()
model.fit(X_train, y_train)


joblib.dump(model, 'API/gpa_model.pkl')
joblib.dump(scaler, 'API/scaler.pkl')

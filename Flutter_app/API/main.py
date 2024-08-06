from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import numpy as np

app = FastAPI()

class GPARequest(BaseModel):
    study_hours: float
    other_variable1: float
    other_variable2: float

model = joblib.load('gpa_model.pkl')
scaler = joblib.load('scaler.pkl')

@app.post('/predict')
def predict(data: GPARequest):

    input_data = np.array([[data.study_hours, data.other_variable1, data.other_variable2]])

    input_data_scaled = scaler.transform(input_data)

    prediction = model.predict(input_data_scaled)
    return {"predicted_gpa": prediction[0]}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

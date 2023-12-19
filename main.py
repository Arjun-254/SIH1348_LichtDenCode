from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
from Selenium_testing import perform_search 
app = FastAPI()

class TrainData1(BaseModel):
    train_name: List[str]
    train_no: List[str]
    total_votes: List[str]
    cleanliness: List[str]
    punctuality: List[str]
    food: List[str]
    ticket: List[str]
    safety: List[str]

class TrainData2(BaseModel):
    Type: List[str]
    Zone: List[str]
    From: List[str]
    PFfrom: List[str]
    Dep: List[str]
    AvgDelay: List[str]
    To: List[str]
    PFto: List[str]
    Arr: List[str]

@app.post("/get_train_data")
async def get_train_data(station_1: str, station_2: str):
    # Call your existing function to get train data
    train_data1, train_data2 = perform_search(station_1, station_2)

    # Create instances of the Pydantic models
    response_train_data1 = TrainData1(**train_data1)
    response_train_data2 = TrainData2(**train_data2)

    # Return the data as JSON
    return {"train_data1": response_train_data1.dict(), "train_data2": response_train_data2.dict()}

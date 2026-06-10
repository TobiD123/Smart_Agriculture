from datetime import datetime
from typing import List, Optional

import numpy as np
import pandas as pd
from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from pydantic import BaseModel

from generate_data import create_simulated_data

DATA_PATH = "smart_agriculture_measurements.csv"

app = FastAPI(title="Smart Agriculture API")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/login")

data_frame: Optional[pd.DataFrame] = None


class HealthResponse(BaseModel):
    status: str


class SensorData(BaseModel):
    timestamp: datetime
    soil_moisture_percent: float
    soil_temperature_c: float
    air_temperature_c: float
    air_humidity_percent: float
    ph_value: float
    irrigation_active: bool
    system_status: str


class StatisticsResponse(BaseModel):
    ph_mean: float
    ph_median: float
    ph_variance: float
    ph_std: float
    cp: float
    cpk: float


class AlertResponse(BaseModel):
    timestamp: datetime
    type: str
    severity: str
    message: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str


def load_data() -> pd.DataFrame:
    try:
        df = pd.read_csv(DATA_PATH, parse_dates=["timestamp"])
    except FileNotFoundError:
        df = create_simulated_data(DATA_PATH)

    return df


@app.on_event("startup")
def startup_event():
    global data_frame
    data_frame = load_data()


def calculate_statistics(df: pd.DataFrame) -> dict:
    ph = df["ph_value"]
    lsl = 5.8
    usl = 7.2
    mean_ph = float(ph.mean())
    median_ph = float(ph.median())
    var_ph = float(ph.var(ddof=1))
    std_ph = float(ph.std(ddof=1))
    cp = float((usl - lsl) / (6 * std_ph)) if std_ph > 0 else 0.0
    cpk = float(
        min((usl - mean_ph) / (3 * std_ph), (mean_ph - lsl) / (3 * std_ph))
        if std_ph > 0
        else 0.0
    )

    return {
        "ph_mean": round(mean_ph, 3),
        "ph_median": round(median_ph, 3),
        "ph_variance": round(var_ph, 4),
        "ph_std": round(std_ph, 4),
        "cp": round(cp, 3),
        "cpk": round(cpk, 3),
    }


def verify_token(token: str = Depends(oauth2_scheme)):
    if token != "demo-token":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Ungültiges Token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return token


@app.get("/health", response_model=HealthResponse)
def health():
    return {"status": "ok"}


@app.post("/login", response_model=TokenResponse)
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    if form_data.username != "admin" or form_data.password != "password":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Falsche Anmeldedaten",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return {"access_token": "demo-token", "token_type": "bearer"}


@app.get("/sensors", response_model=List[SensorData])
def sensors(token: str = Depends(verify_token)):
    if data_frame is None:
        raise HTTPException(status_code=500, detail="Daten nicht geladen")
    return data_frame.to_dict(orient="records")


@app.get("/statistics", response_model=StatisticsResponse)
def statistics(token: str = Depends(verify_token)):
    if data_frame is None:
        raise HTTPException(status_code=500, detail="Daten nicht geladen")
    return calculate_statistics(data_frame)


@app.get("/alerts", response_model=List[AlertResponse])
def alerts(token: str = Depends(verify_token)):
    if data_frame is None:
        raise HTTPException(status_code=500, detail="Daten nicht geladen")
    alerts_list = []
    for _, row in data_frame.iterrows():
        if row["system_status"] == "ALERT":
            alerts_list.append(
                {
                    "timestamp": row["timestamp"],
                    "type": "PH_OUT_OF_SPEC",
                    "severity": "HIGH",
                    "message": "pH-Wert außerhalb der Spezifikation",
                }
            )
    return alerts_list

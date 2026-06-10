gimport numpy as np
import pandas as pd
from datetime import datetime, timedelta


def create_simulated_data(output_path: str = "smart_agriculture_measurements.csv", n: int = 120):
    np.random.seed(42)

    start = datetime.now().replace(second=0, microsecond=0)
    timestamps = [start + timedelta(minutes=5 * i) for i in range(n)]

    soil_moisture = np.random.normal(loc=42, scale=6, size=n)
    soil_temperature = np.random.normal(loc=18, scale=2.5, size=n)
    air_temperature = np.random.normal(loc=23, scale=3, size=n)
    air_humidity = np.random.normal(loc=58, scale=8, size=n)
    ph_value = np.random.normal(loc=6.5, scale=0.22, size=n)

    # Einzelne Ausreißer einbauen
    ph_value[40] = 5.4
    ph_value[85] = 7.5

    irrigation_active = soil_moisture < 36
    system_status = np.where(
        (ph_value < 5.8) | (ph_value > 7.2),
        "ALERT",
        "OK",
    )

    df = pd.DataFrame(
        {
            "timestamp": timestamps,
            "soil_moisture_percent": np.round(soil_moisture, 2),
            "soil_temperature_c": np.round(soil_temperature, 2),
            "air_temperature_c": np.round(air_temperature, 2),
            "air_humidity_percent": np.round(air_humidity, 2),
            "ph_value": np.round(ph_value, 2),
            "irrigation_active": irrigation_active,
            "system_status": system_status,
        }
    )

    df.to_csv(output_path, index=False)
    return df


if __name__ == "__main__":
    csv_path = "smart_agriculture_measurements.csv"
    df = create_simulated_data(csv_path)
    print(f"CSV-Datei gespeichert: {csv_path}")
    print(df.head())

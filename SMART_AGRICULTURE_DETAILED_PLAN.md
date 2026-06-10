# Smart Agriculture – Detaillierter Projektplan

Dieses Dokument ergänzt die ursprüngliche `README.md` und enthält eine ausgearbeitete Projektplanung, Datenmodellierung, API-Architektur, Datenanalyse, Cybersecurity-Bewertung und App-Konzept. Die `README.md` bleibt unverändert.

## 1. Projektübersicht

**Projektname:** Smart Agriculture Monitoring

**Zielsetzung:**
Das Ziel ist die Entwicklung eines digitalen Überwachungssystems für ein Gewächshaus, das Sensordaten simuliert, analysiert, über eine REST-API bereitstellt und in einer Flutter-Windows-Desktop-App visualisiert.

**Nutzen:**
- Bessere Transparenz über Umweltbedingungen
- Frühzeitige Erkennung von Prozessabweichungen
- Grundlage für automatisierte Bewässerung und Qualitätskontrolle

## 2. Stakeholder

- Betriebsleiter / Geschäftsführung
- Agraringenieure und Techniker
- IT-Verantwortliche
- Lehrperson und Projektbetreuer
- Endanwender / Gewächshausbetreiber

## 3. Systemgrenzen

### Eingeschlossen
- Simulation von Sensordaten
- Speicherung der Daten als CSV
- Datenanalyse und Prozessfähigkeitsbewertung
- API-Design und optionale FastAPI-Implementierung
- Flutter-Windows-Desktop-Dashboard

### Ausgeschlossen
- Anbindung echter Sensorhardware
- Steuerung physischer Aktoren
- Cloud-Hosting und Containerisierung
- Mobile App (außer Desktop-Prototyp)

## 4. Funktionale Anforderungen

1. Das System erzeugt mindestens 100 simulierte Messdaten.
2. Das System speichert Datensätze als CSV-Datei.
3. Die API liefert aktuelle Sensordaten, Statistiken, Alarme und Systemstatus.
4. Die Desktop-App zeigt aktuelle Werte, Analysekennzahlen und Alerts.
5. Die App gibt Statusinformationen in Form von OK/WARNING/CRITICAL aus.

## 5. Nichtfunktionale Anforderungen

1. Die API-Antworten sollen innerhalb von 500 ms erfolgen.
2. Die Datenaufbereitung ist nachvollziehbar und reproduzierbar.
3. Die Appstruktur ist klar, einfach zu bedienen und für Windows geeignet.
4. Die Dokumentation ist vollständig und enthält Beispiele.
5. Die Lösung folgt den Grundprinzipien von Sicherheit und Eingabevalidierung.

## 6. Arbeitspakete

| AP  | Beschreibung                         | Ergebnis                                  |
|-----|--------------------------------------|-------------------------------------------|
| AP1 | Projektplanung                       | Projektsteckbrief, Zeitplan, Risiken      |
| AP2 | Datengenerierung und Datenmodell     | CSV-Datei mit mindestens 100 Einträgen    |
| AP3 | API-Konzept und FastAPI-Prototyp     | API-Beschreibung, optionaler Code         |
| AP4 | Datenanalyse                         | Kennzahlen, Cp/Cpk, Diagramme             |
| AP5 | Cybersecurity-Review                 | Risikomatrix, Gegenmaßnahmen              |
| AP6 | Flutter Windows Desktop App          | Dashboard-Konzept oder Prototyp           |
| AP7 | Dokumentation und Präsentation       | Abschlussdokument, Präsentationsfolien    |

## 7. Top-3-Risiken

| Risiko                                 | Auswirkung                              | Gegenmaßnahme                               |
|----------------------------------------|-----------------------------------------|---------------------------------------------|
| Zeitmangel bei App-Entwicklung         | Kein vollständiger Prototyp             | MVP-Kernfunktionen priorisieren              |
| Fehlendes Datenmodell                  | Falsche Auswertungen                    | Datenfelder und Spezifikationen früh festlegen |
| Unzureichende API-Sicherheit           | Sicherheitslücken                        | Authentifizierung und Validierung einplanen  |

## 8. Annahmen

- Es werden keine echten Sensoren verwendet.
- Die Daten stammen ausschließlich aus einer Simulation.
- Es wird lokal oder im Schulnetzwerk entwickelt.
- Die App ist für Windows-Desktop ausgelegt.
- Für die Bewertung ist ein Dokumentations- und Präsentationsformat ausreichend.

## 9. Deliverables

- Ausgefüllter Projektsteckbrief
- CSV-Datei mit simulierten Messdaten
- API-Konzept oder FastAPI-Implementierung
- Datenanalyse und Prozessfähigkeitskennzahlen
- Cybersecurity-Matrix mit Gegenmaßnahmen
- Flutter-App-Skizze oder Prototyp
- Präsentation und Abschlussdokumentation

## 10. Datenmodell und Simulation

### Felder

- `timestamp`: Zeitstempel der Messung
- `soil_moisture_percent`: Bodenfeuchte in Prozent
- `soil_temperature_c`: Bodentemperatur in °C
- `air_temperature_c`: Lufttemperatur in °C
- `air_humidity_percent`: Luftfeuchte in Prozent
- `ph_value`: pH-Wert des Bodens
- `irrigation_active`: boolscher Wert für aktive Bewässerung
- `system_status`: `OK`, `ALERT`, `WARNING`

### Qualitätsgrenzen für den pH-Wert

- LSL = 5.8
- Zielwert = 6.5
- USL = 7.2

### Beispielcode zur Datengenerierung

```python
import numpy as np
import pandas as pd
from datetime import datetime, timedelta

np.random.seed(42)

n = 120
start = datetime.now().replace(second=0, microsecond=0)

timestamps = [start + timedelta(minutes=5 * i) for i in range(n)]

soil_moisture = np.random.normal(loc=42, scale=6, size=n)
soil_temperature = np.random.normal(loc=18, scale=2.5, size=n)
air_temperature = np.random.normal(loc=23, scale=3, size=n)
air_humidity = np.random.normal(loc=58, scale=8, size=n)
ph_value = np.random.normal(loc=6.5, scale=0.22, size=n)

# Ausreißer hinzufügen
ph_value[40] = 5.4
ph_value[85] = 7.5

irrigation_active = soil_moisture < 36
system_status = np.where(
    (ph_value < 5.8) | (ph_value > 7.2),
    "ALERT",
    "OK",
)

# Werte runden und klares DataFrame erzeugen

df = pd.DataFrame({
    "timestamp": timestamps,
    "soil_moisture_percent": np.round(soil_moisture, 2),
    "soil_temperature_c": np.round(soil_temperature, 2),
    "air_temperature_c": np.round(air_temperature, 2),
    "air_humidity_percent": np.round(air_humidity, 2),
    "ph_value": np.round(ph_value, 2),
    "irrigation_active": irrigation_active,
    "system_status": system_status,
})

csv_path = "smart_agriculture_measurements.csv"
df.to_csv(csv_path, index=False)
print("CSV-Datei gespeichert:", csv_path)
```

## 11. API-Design

### Basis-URL

`http://localhost:8000`

### Endpunkte

| Methode | Endpunkt      | Beschreibung                                               |
|---------|---------------|------------------------------------------------------------|
| GET     | `/health`     | Prüft den Systemstatus                                       |
| GET     | `/sensors`    | Liefert aktuelle Sensordaten                                 |
| GET     | `/statistics` | Gibt berechnete Kennzahlen zurück                            |
| GET     | `/alerts`     | Liefert aktuelle Warnungen                                   |
| POST    | `/login`      | Authentifizierung und Token-Erstellung                       |

### Beispielantworten

**GET /health**

```json
{ "status": "ok" }
```

**GET /sensors**

```json
[
  {
    "timestamp": "2026-06-01T08:00:00",
    "soil_moisture_percent": 42.12,
    "soil_temperature_c": 18.05,
    "air_temperature_c": 23.10,
    "air_humidity_percent": 57.74,
    "ph_value": 6.48,
    "irrigation_active": false,
    "system_status": "OK"
  }
]
```

**GET /statistics**

```json
{
  "ph_mean": 6.51,
  "ph_std": 0.22,
  "cp": 1.09,
  "cpk": 0.98
}
```

**GET /alerts**

```json
[
  {
    "timestamp": "2026-06-01T09:50:00",
    "type": "PH_OUT_OF_SPEC",
    "severity": "HIGH",
    "message": "pH-Wert außerhalb der Spezifikation"
  }
]
```

### Authentifizierungsmechanismus

- `POST /login` kann ein Demo-Token zurückgeben.
- Für einen Prototypen kann ein statisches Token ausreichen.
- In der echten Anwendung ist ein JWT- oder OAuth-Token sinnvoll.

### FastAPI-Prototyp

```python
from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

app = FastAPI(title="Smart Agriculture API")

class HealthResponse(BaseModel):
    status: str

@app.get("/health", response_model=HealthResponse)
def health():
    return {"status": "ok"}
```

### Zusätzliche Hinweise

- Lade CSV-Daten beim Start.
- Verwende Pydantic zur Validierung.
- Achte auf klare Fehlerantworten.
- Dokumentiere die API mit OpenAPI/Swagger.

## 12. Datenanalyse

### Kennzahlen für den pH-Wert

- Mittelwert
- Median
- Varianz
- Standardabweichung
- Cp
- Cpk

### Formeln

```text
Cp  = (USL - LSL) / (6 * σ)
Cpk = min((USL - μ) / (3 * σ), (μ - LSL) / (3 * σ))
```

Mit:
- `LSL = 5.8`
- `USL = 7.2`
- `μ` = Mittelwert
- `σ` = Standardabweichung

### Beispielcode

```python
LSL = 5.8
USL = 7.2
ph = df["ph_value"]

mean_ph = ph.mean()
median_ph = ph.median()
var_ph = ph.var(ddof=1)
std_ph = ph.std(ddof=1)
cp = (USL - LSL) / (6 * std_ph)
cpk = min((USL - mean_ph) / (3 * std_ph), (mean_ph - LSL) / (3 * std_ph))

result = {
    "mean_ph": round(mean_ph, 3),
    "median_ph": round(median_ph, 3),
    "var_ph": round(var_ph, 4),
    "std_ph": round(std_ph, 4),
    "cp": round(cp, 3),
    "cpk": round(cpk, 3),
}
print(result)
```

### Interpretation

- `Cpk < 1.00`: kritischer Prozess, Nachbesserung notwendig
- `1.00 <= Cpk < 1.33`: grenzwertig, Prozess ist nicht stabil genug
- `Cpk >= 1.33`: Prozess ist fähig

### Visualisierungsvorschläge

- Histogramm des pH-Werts mit LSL/USL
- Zeitverlauf der pH-Werte mit Mittelwertlinie
- Balkendiagramm für Bodenfeuchte, Temperatur und Luftfeuchte

## 13. Cybersecurity Review

### Schwachstellen

1. Fehlende Authentifizierung
2. Fehlende Eingabevalidierung
3. Hardcodierte Secrets
4. Keine HTTPS-Verschlüsselung
5. Fehlendes Logging

### Risikomatrix

| Nr. | Schwachstelle                | Risiko                                                | Eintritt | Auswirkung | Maßnahme                                            |
|-----|-----------------------------|-------------------------------------------------------|----------|------------|-----------------------------------------------------|
| 1   | Keine Authentifizierung     | Unbefugter Zugriff auf API                             | hoch     | hoch       | /login Endpoint, Token-basierte Absicherung         |
| 2   | Keine Eingabevalidierung    | Ungültige oder manipulierte Anfragen                   | mittel   | hoch       | Pydantic-Validation, Anfrage-Schema nutzen          |
| 3   | Hardcodierte Secrets        | Veröffentlichung sensibler Informationen               | mittel   | hoch       | Secrets in Konfigurationsdatei oder Umgebungsvariablen speichern |
| 4   | Keine HTTPS-Verschlüsselung | Datenübertragung kann abgehört werden                  | mittel   | mittel     | HTTPS / TLS einsetzen                               |
| 5   | Kein Logging                | Vorfälle sind schwer nachverfolgbar                    | niedrig  | mittel     | Logging für API-Zugriffe und Fehler einführen       |

### Empfehlungen

- Verwende `https://` für produktive Systeme.
- Schütze sensible Konfigurationsdaten.
- Nutze Validierung auf API-Ebene.
- Implementiere nur den benötigten Umfang an Endpunkten.
- Dokumentiere Sicherheitsmaßnahmen im Abschlussbericht.

## 14. Zwischenpräsentation

### Zielgruppe
- Geschäftsführung des landwirtschaftlichen Betriebs

### Inhalte der Folien

1. Projektziel
2. Systemarchitektur
3. Aktueller Umsetzungsstand
4. Erste Analyseergebnisse
5. Cybersecurity-Risiken
6. Nächste Schritte

### Empfehlungen

- Nutze einfache Diagramme und Tabellen.
- Hebe Kernwerte hervor: pH, Cp/Cpk, Alerts.
- Zeige den Projektstatus deutlich an.
- Formuliere klare nächste Schritte.

## 15. Flutter Windows Desktop App

### Kernfunktionalitäten

- Aktuelle Sensordaten anzeigen
- Analysekennzahlen darstellen
- Warnungen auflisten
- Systemstatus visuell kennzeichnen

### Empfohlene Seiten

1. Dashboard
2. Analyse
3. Alerts / Security
4. Projektinfo

### Beispielstruktur

```dart
Column(
  children: [
    Text("Smart Agriculture Dashboard"),
    Card(child: Text("pH Mittelwert: 6.51")),
    Card(child: Text("Cp: 1.09 | Cpk: 0.98")),
    Text("Status: Warning", style: TextStyle(color: Colors.orange)),
  ],
)
```

### Umsetzungshinweise

- Lade Daten aus der CSV-Datei oder per HTTP von der API.
- Nutze responsive Layouts für Desktop.
- Verwende Farben für Status: grün, gelb, rot.
- Mache die wichtigsten Informationen auf einen Blick sichtbar.

## 16. Abschlussdokumentation

### Pflichtkapitel

1. Projektziel
2. Datenmodell
3. API-Design
4. Datenanalyse
5. Cybersecurity Review
6. Flutter-App
7. Offene Punkte
8. Lessons Learned

### Tipps

- Beschreibe die wichtigsten Entscheidungen.
- Listen verwendete Bibliotheken und Tools auf.
- Dokumentiere Gefundene Probleme und Lösungen.
- Ergänze Screenshots oder Codebeispiele, wenn möglich.

## 17. Abschlusspräsentation & Demo

### Inhalte
- Projektziel
- Architektur
- wichtigste Analyseergebnisse
- Cybersecurity-Findings
- Flutter-App oder App-Konzept
- Lessons Learned

### Möglicher nächster Schritt

- Integration echter Sensoren
- Erweiterte API-Sicherheit
- Cloud-Deployment
- Historische Trendanalyse im Dashboard
- Automatische Benachrichtigungen bei Alerts

## 18. Weiterführende Aufgaben

- Eine echte FastAPI-Implementierung erstellen
- CSV-Daten automatisch per Skript neu generieren
- Eine einfache Datenbank als Backend hinzufügen
- Eine Test-Suite für API und Analyse ergänzen

---

Diese Datei liefert eine ausgearbeitete Anleitung für jeden Abschnitt des Projekts, ohne die ursprüngliche `README.md` zu verändern.

# Projektmanagement-Phasen
(Der Herangehensweise-Leitfaden)

Für diesen Tag durchläufst du die klassischen vier Projektmanagement-Phasen in stark komprimierter Form.

## Phase 1: Initiierung & Planung (08:00 – 08:30)
In dieser Phase definierst du das Was und Warum. Da die Zeit knapp ist, musst du hier sofort Klarheit schaffen.
- Scope definieren (In-Scope vs. Out-of-Scope): Was muss exakt geliefert werden? (Siehe deine Nicht-Ziele Folie).
- Risikomanagement: Identifiziere sofort die größten Stolpersteine (z. B. "FastAPI läuft nicht", "Flutter-Umgebung streikt").
- Deliverable: Der vollständig ausgefüllte Projektsteckbrief.

## Phase 2: Ausführung & Entwicklung (08:30 – 14:45)
Das ist die Kernphase. Hier wird nach dem MVP-Prinzip (Minimum Viable Product) gearbeitet. Entwickle zuerst die Basisfunktionen; verschönere erst, wenn am Ende noch Zeit ist.
- Daten-Layer (08:30 – 09:30): Skript schreiben, das saubere CSV-Daten erzeugt.
- Backend-Layer (09:30 – 10:30): FastAPI aufsetzen. Teste die Endpunkte direkt mit Tools wie Postman oder dem integrierten Swagger-UI.
- Analyse-Layer (10:45 – 11:30): Python-Skript für die statistische Auswertung (Cp/Cpk) und Graphen-Erstellung.
- Frontend-Layer (13:30 – 14:45): Flutter-App anbinden. Erst die Rohdaten anzeigen, danach das UI-Design anpassen.

## Phase 3: Überwachung & Steuerung (Laufend)
Als Einzelkämpfer musst du dich selbst steuern.
- Timeboxing: Wenn du für die FastAPI-Implementierung länger als 60 Minuten brauchst, reduziere den Funktionsumfang (z. B. lass den Zusatz-Endpunkt POST /alerts weg).
- Qualitätssicherung (12:30 – 13:00): Der Cybersecurity Review dient hier als Qualitäts-Gate.

## Phase 4: Abschluss & Übergabe (14:45 – 16:00)
Ein Projekt ist erst fertig, wenn es abgenommen ist.
- Dokumentation: Technische Entscheidungen kurz und prägnant festhalten.
- Präsentation: Den Pitch proben. Zeige nicht nur Code, sondern den Business Value (Nutzen für den Landwirt).
- Deliverable: Abgabefertige ZIP-Datei (Nachname_Vorname_SmartAgriculture.zip).

# Detaillierter Meilensteinplan
Meilensteine (Milestones) sind Fixpunkte im Projekt, an denen ein definiertes Zwischenergebnis (Deliverable) zu 100 % abgeschlossen sein muss.

| Uhrzeit | Meilenstein | Zwingendes Ergebnis |
| --- | --- | --- |
| 08:30 Uhr | MS 1: Projekt-Baseline gesetzt | Projektsteckbrief ist ausgefüllt, Scope und Top-3-Risiken sind dokumentiert. |
| 09:30 Uhr | MS 2: Datenfundament steht | CSV-Datei mit >100 realistischen, simulierten Datensätzen existiert. |
| 10:30 Uhr | MS 3: Backend ist live | FastAPI läuft lokal, Endpunkte (wie /sensors) liefern JSON-Daten zurück. |
| 11:30 Uhr | MS 4: Daten sind validiert | Kennzahlen (Cp/Cpk) sind berechnet, erste Diagramme (Matplotlib/Plotly) sind generiert. |
| 13:00 Uhr | MS 5: Security Review bestanden | Risikomatrix ist erstellt; Management-Review-Folie ist vorbereitet. |
| 14:45 Uhr | MS 6: MVP Frontend ist funktional | Flutter Windows App läuft, ruft API ab und visualisiert Sensordaten. |
| 15:15 Uhr | MS 7: Code Freeze & Doku | Keine Code-Änderungen mehr! Technische Dokumentation ist geschrieben. |
| 16:00 Uhr | MS 8: Projektübergabe | Abschlusspräsentation gehalten, ZIP-Datei fristgerecht abgegeben. |

# Best Practices für deinen Erfolg
- Versionierung (Git): Auch wenn es ein 1-Tages-Projekt ist, mache nach jedem erreichten Meilenstein einen Commit (z. B. `git commit -m "MS 3: FastAPI Backend läuft"`). So kannst du bei Fehlern schnell zurückspringen.
- Done is better than perfect: Verliere dich nicht in Details wie CSS-Farben im Flutter-Dashboard, wenn die Datenanbindung noch nicht steht. Funktion schlägt Design.
- Pausen einhalten: Die Pausen (10:30 und 11:30) sind hart eingeplant. Dein Gehirn braucht diese Erholung für den Nachmittags-Sprint.

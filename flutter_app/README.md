# Smart Agriculture Flutter App

Dieses Flutter-Projekt ist als Windows-Desktop-App ausgelegt und verbindet sich mit der lokalen API unter `http://localhost:8000`.

## Voraussetzungen

- Flutter installiert
- Windows Desktop-Entwicklung in Flutter aktiviert
- Lokaler API-Server läuft auf `http://localhost:8000`

## Setup

1. Öffne ein Terminal im Ordner `flutter_app`.
2. Führe `flutter pub get` aus.
3. Wenn noch kein Flutter-Projekt erstellt wurde, führe `flutter create .` aus.
4. Starte die App mit `flutter run -d windows`.

## Standard-Login

Die App verwendet folgende Standard-Anmeldedaten für `POST /login`:

- Benutzername: `admin`
- Passwort: `password`

## API-Endpunkte

- `POST http://localhost:8000/login`\n- `GET http://localhost:8000/sensors`\n- `GET http://localhost:8000/statistics`\n- `GET http://localhost:8000/alerts`

## Hinweise

- Die App lädt aktuelle Sensordaten, Analysekennzahlen und Warnungen.
- Aus Sicherheitssicht sollten Login-Daten später nicht hartcodiert werden.

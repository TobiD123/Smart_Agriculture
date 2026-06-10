import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SmartAgricultureApp());
}

class SmartAgricultureApp extends StatelessWidget {
  const SmartAgricultureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Agriculture',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiBaseUrl = 'http://localhost:8000';
  bool isLoading = true;
  String statusMessage = 'Starte...';
  List<dynamic> sensors = [];
  Map<String, dynamic> statistics = {};
  List<dynamic> alerts = [];
  String systemStatus = 'UNKNOWN';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        isLoading = true;
        statusMessage = 'Verbinde mit API...';
      });

      final token = await login();
      final data = await Future.wait([
        fetchSensors(token),
        fetchStatistics(token),
        fetchAlerts(token),
      ]);

      final fetchedSensors = data[0] as List<dynamic>;
      final fetchedStats = data[1] as Map<String, dynamic>;
      final fetchedAlerts = data[2] as List<dynamic>;

      setState(() {
        sensors = fetchedSensors;
        statistics = fetchedStats;
        alerts = fetchedAlerts;
        systemStatus = _evaluateSystemStatus();
        statusMessage = 'Daten geladen';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        statusMessage = 'Fehler: $e';
      });
    }
  }

  Future<String> login() async {
    final uri = Uri.parse('$apiBaseUrl/login');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': 'admin',
        'password': 'password',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['access_token'] as String;
    }
    throw Exception('Login fehlgeschlagen: ${response.statusCode}');
  }

  Future<List<dynamic>> fetchSensors(String token) async {
    final uri = Uri.parse('$apiBaseUrl/sensors');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw Exception('Sensors konnten nicht geladen werden');
  }

  Future<Map<String, dynamic>> fetchStatistics(String token) async {
    final uri = Uri.parse('$apiBaseUrl/statistics');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Statistiken konnten nicht geladen werden');
  }

  Future<List<dynamic>> fetchAlerts(String token) async {
    final uri = Uri.parse('$apiBaseUrl/alerts');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw Exception('Warnungen konnten nicht geladen werden');
  }

  String _evaluateSystemStatus() {
    if (alerts.isNotEmpty) {
      return 'CRITICAL';
    }
    if (statistics.containsKey('cpk')) {
      final cpk = statistics['cpk'] as num;
      if (cpk >= 1.33) return 'OK';
      return 'WARNING';
    }
    return 'UNKNOWN';
  }

  Widget _statusChip() {
    final color = systemStatus == 'OK'
        ? Colors.green
        : systemStatus == 'WARNING'
            ? Colors.orange
            : Colors.red;
    return Chip(
      label: Text(systemStatus),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Agriculture Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : loadData,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(statusMessage),
                ],
              ))
            : ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Systemstatus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      _statusChip(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Analysekennzahlen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text('pH Mittelwert: ${statistics['ph_mean'] ?? '-'}'),
                          Text('pH Median: ${statistics['ph_median'] ?? '-'}'),
                          Text('Std. Abw.: ${statistics['ph_std'] ?? '-'}'),
                          Text('Cp: ${statistics['cp'] ?? '-'}'),
                          Text('Cpk: ${statistics['cpk'] ?? '-'}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Aktuelle Sensorwerte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          ...sensors.take(5).map((row) {
                            final sensor = row as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '${sensor['timestamp']} – pH: ${sensor['ph_value']} | Bodenfeuchte: ${sensor['soil_moisture_percent']}%',
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          if (sensors.length > 5) const Text('...mehr Daten verfügbar', style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Warnungen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          if (alerts.isEmpty)
                            const Text('Keine aktuellen Warnungen', style: TextStyle(color: Colors.green))
                          else
                            ...alerts.map((alertRow) {
                              final alert = alertRow as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text('${alert['timestamp']} - ${alert['type']}: ${alert['message']} (${alert['severity']})'),
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

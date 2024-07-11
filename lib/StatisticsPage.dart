import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late DatabaseReference _database;
  Map<String, dynamic> _data = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref().child('System');
    _startFetchingData();
  }

  void _startFetchingData() {
    // Use onValue listener to get real-time updates
    _database.onValue.listen((DatabaseEvent event) {
      var data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _data = data.map((key, value) => MapEntry(key.toString(), value));
        _loading = false;
        // Convert relevant values to integers if they are strings
        _data.forEach((key, value) {
          if (value is String) {
            try {
              _data[key] = int.parse(value);
            } catch (e) {
              print("Error parsing $key: $e");
            }
          }
        });
      });
      _checkTemperature();
    });
  }

  void _checkTemperature() {
    final tempSensor = _data["temp sensor"];
    if (tempSensor != null && tempSensor > 70) {
      // Change threshold to 70
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFireNotification(tempSensor);
      });
    }
  }

  void _showFireNotification(dynamic temperature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'There is a fire in this place as the temperature is $temperature°C'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildText(String label, dynamic value) {
    return Text(
      '  $label = ${value.toString()}',
      style: const TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "  Main Statistics:",
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      color: const Color.fromRGBO(33, 150, 243, 1),
                      width: 390, // Example width constraint
                      height: 550, // Example height constraint
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildText('MQ2 Smoke', _data["mq2_Smoke_sensor"]),
                              buildText('MQ2 Lpg', _data["mq2_lpg_sensor"]),
                              buildText(
                                  'MQ4 Methane', _data["mq4_methane_sensor"]),
                              buildText('MQ4 Hydrogyne',
                                  _data["mq4_hydrogyne_sensor"]),
                              buildText('MQ135 co', _data["mq135_sensor_co"]),
                              buildText('MQ135 co2', _data["mq135_sensor_co2"]),
                              buildText('DHT22 Humidity', _data["dht11sensor"]),
                              buildText('LM35 Temp', _data["temp sensor"]),
                              const Text(
                                '    gps coordinates:',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              buildText('gps_lat', _data["gps_lat"]),
                              buildText('gps_long', _data["gps_log"]),
                              buildText('power state', _data["power_state"]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

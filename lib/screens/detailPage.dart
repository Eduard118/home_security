import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('DH11');
  double _currentTemperature = 16.0;
  int _desiredTemperature = 16;
  int _humidity = 0;

  @override
  void initState() {
    super.initState();
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map;
      setState(() {
        _currentTemperature = _parseTemperature(data['Temperatura'] ?? 16.0);
        _desiredTemperature = (data['DesiredTemperature'] ?? 16).toInt();
        _humidity = (data['Umiditate'] ?? 0).toInt();
      });
    });
  }

  double _parseTemperature(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 16.0;
    }
  }

  void _setDesiredTemperature(int temp) {
    _databaseReference.update({'DesiredTemperature': temp});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Text(
                    'Room Temperature',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Current: ${_currentTemperature.toStringAsFixed(1)}°',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Humidity: $_humidity%',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Adjust Desired Temperature',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                customColors: CustomSliderColors(
                  trackColor: Colors.blue[100]!,
                  progressBarColor: Colors.blueAccent,
                  dotColor: Colors.blueAccent,
                ),
                customWidths: CustomSliderWidths(
                  trackWidth: 8,
                  progressBarWidth: 12,
                  handlerSize: 12,
                ),
                infoProperties: InfoProperties(
                  mainLabelStyle: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  modifier: (double value) {
                    final roundedValue = value.round();
                    return '$roundedValue°';
                  },
                ),
              ),
              min: 16,
              max: 40,
              initialValue: _desiredTemperature.toDouble(),
              onChange: (double value) {
                setState(() {
                  _desiredTemperature = value.round();
                  _setDesiredTemperature(_desiredTemperature);
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add action to power off or any other functionality
              },
              child: Text('Power Off'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), backgroundColor: Colors.redAccent,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'detailPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final databaseReference = FirebaseDatabase.instance.ref().child('sensorData');
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Local state to track previous values
  bool previousFireDetected = false;
  bool previousGasDetected = false;
  bool previousMotionDetected = false;
  bool previousWaterDetected = false;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    monitorDatabaseChanges();
  }

  void monitorDatabaseChanges() {
    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map;

      bool fireDetected = data['fireDetected'] ?? false;
      bool gasDetected = data['gasDetected'] ?? false;
      bool motionDetected = data['motionDetected'] ?? false;
      bool waterDetected = data['waterDetected'] ?? false;

      // Check for changes and send notifications accordingly
      if (fireDetected && !previousFireDetected) {
        _showNotification('Fire Alert', 'Fire detected!');
      }
      if (gasDetected && !previousGasDetected) {
        _showNotification('Gas Alert', 'Gas leak detected!');
      }
      if (motionDetected && !previousMotionDetected) {
        _showNotification('Motion Alert', 'Motion detected!');
      }
      if (waterDetected && !previousWaterDetected) {
        _showNotification('Water Alert', 'Water detected!');
      }

      // Update the local state with current values
      previousFireDetected = fireDetected;
      previousGasDetected = gasDetected;
      previousMotionDetected = motionDetected;
      previousWaterDetected = waterDetected;
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'sensor_alerts_channel', // channelId
      'Sensor Alerts', // channelName
      channelDescription:
      'Notifications for sensor alerts such as fire, gas, motion, and water detection', // channelDescription
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

    ///Read realtime time in realtime database
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Database Example'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage()),
          );
        } ,
        child: const Text('Detalii'),
      ),
      body: StreamBuilder(
        stream: _databaseReference.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
            Map data = snapshot.data!.snapshot.value as Map;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                String key = data.keys.elementAt(index);
                return ListTile(
                  title: Text('$key: ${data[key].toString()}'),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );

  }
}

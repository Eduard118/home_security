import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';
import 'package:test_flutter_v2/globals/globals.dart';

import 'loginPage.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('sensorData');
  double _currentTemperature = 16.0;
  int _desiredTemperature = 16;
  int _humidity = 0;
  bool _activatePir = false;
  bool _fireDetected = false;
  bool _gasDetected = false;
  bool _waterDetected = false;
  late StreamSubscription<DatabaseEvent> _streamSubscription;

  final databaseReferenceNotifications = FirebaseDatabase.instance.ref().child('sensorData');
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Local state to track previous values
  bool previousFireDetected = false;
  bool previousGasDetected = false;
  bool previousMotionDetected = false;
  bool previousWaterDetected = false;

  // User data
  String userName = "";
  String houseAddress = "";
  String houseName = "";
  List<Map<String, String>> emergencyContacts = [];
  final String? userEmail = Globals.usEmail; // Replace with actual email

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _fetchUserData();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      //iOS: IOSInitializationSettings(),
      //macOS: MacOSInitializationSettings()
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    monitorDatabaseChanges();
  }

  void monitorDatabaseChanges() {
    databaseReferenceNotifications.onValue.listen((event) {
      final data = event.snapshot.value as Map;

      bool fireDetected = data['fireDetected'] ?? false;
      bool gasDetected = data['gasDetected'] ?? false;
      bool motionDetected = data['motionDetected'] ?? false;
      bool waterDetected = data['waterDetected'] ?? false;

      // Check for changes and send notifications accordingly
      if (fireDetected && !previousFireDetected) {
        _showNotification('Fire Alert', 'Fire detected!', 'fire');
      }
      if (gasDetected && !previousGasDetected) {
        _showNotification('Gas Alert', 'Gas leak detected!', 'gas');
      }
      if (motionDetected && !previousMotionDetected && _activatePir) {
        _showNotification('Motion Alert', 'Motion detected!', 'motion');
      }
      if (waterDetected && !previousWaterDetected) {
        _showNotification('Water Alert', 'Water detected!', 'water');
      }

      // Update the local state with current values
      previousFireDetected = fireDetected;
      previousGasDetected = gasDetected;
      previousMotionDetected = motionDetected;
      previousWaterDetected = waterDetected;
    });
  }

  Future<void> _showNotification(String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'sensor_alerts_channel', // channelId
      'Sensor Alerts', // channelName
      channelDescription: 'Notifications for sensor alerts such as fire, gas, motion, and water detection', // channelDescription
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
      payload: payload,
    );
  }

  Future<void> _fetchInitialData() async {
    final event = await _databaseReference.once();
    final data = event.snapshot.value;
    if (data != null && data is Map) {
      if (mounted) {
        setState(() {
          _currentTemperature = _parseTemperature(data['temperature'] ?? 16.0);
          _humidity = (data['humidity'] ?? 0).toInt();
          _desiredTemperature = (data['DesiredTemperature'] ?? 16).toInt();
          _activatePir = data['activatePir'] ?? false;
          _fireDetected = data['fireDetected'] ?? false;
          _gasDetected = data['gasDetected'] ?? false;
          _waterDetected = data['waterDetected'] ?? false;
        });
      }
    } else {
      print('Error: Data is null or not a map');
    }

    _streamSubscription = _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        if (mounted) {
          setState(() {
            _currentTemperature = _parseTemperature(data['temperature'] ?? 16.0);
            _humidity = (data['humidity'] ?? 0).toInt();
            _desiredTemperature = (data['DesiredTemperature'] ?? 16).toInt();
            _activatePir = data['activatePir'] ?? false;
            _fireDetected = data['fireDetected'] ?? false;
            _gasDetected = data['gasDetected'] ?? false;
            _waterDetected = data['waterDetected'] ?? false;
          });
        }
      } else {
        if (kDebugMode) {
          print('Error: Data is null or not a map');
        }
      }
    });
  }

  Future<void> _fetchUserData() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userEmail);
    final docSnapshot = await userDoc.get();
    if (docSnapshot.exists) {
      final userData = docSnapshot.data() as Map<String, dynamic>;
      setState(() {
        userName = userData['name'] ?? "";
        houseAddress = userData['houseAddress'] ?? "";
        houseName = userData['houseName'] ?? "";
        if (userData['emergencyContacts'] != null) {
          emergencyContacts = (userData['emergencyContacts'] as Map<String, dynamic>)
              .entries
              .map((entry) => {'name': entry.key, 'phone': entry.value.toString()})
              .toList();
        }
      });
    } else {
      print('User document does not exist');
    }
  }


  Future<void> _updateUserData(String newName, String newHouseAddress, String newHouseName) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userEmail);
    await userDoc.update({
      'name': newName,
      'houseAddress': newHouseAddress,
      'houseName': newHouseName,
    });
    setState(() {
      userName = newName;
      houseAddress = newHouseAddress;
      houseName = newHouseName;
    });
  }

  Future<void> _updateEmergencyContacts(Map<String, String> newContact) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userEmail);
    emergencyContacts.add(newContact);
    final emergencyContactsMap = {for (var contact in emergencyContacts) contact['name']!: contact['phone']!};
    await userDoc.update({
      'emergencyContacts': emergencyContactsMap,
    });
    setState(() {});
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
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

  void _setActivatePir(bool value) {
    _databaseReference.update({'activatePir': value});
  }

  void _showWarningDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog() {
    TextEditingController nameController = TextEditingController(text: userName);
    TextEditingController addressController = TextEditingController(text: houseAddress);
    TextEditingController houseNameController = TextEditingController(text: houseName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User Info'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'House Address'),
                ),
                TextField(
                  controller: houseNameController,
                  decoration: InputDecoration(labelText: 'House Name'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _updateUserData(
                  nameController.text,
                  addressController.text,
                  houseNameController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddEmergencyContactDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Emergency Contact'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _updateEmergencyContacts({
                  'name': nameController.text,
                  'phone': phoneController.text,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyContactsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Emergency Contacts'),
          content: SingleChildScrollView(
            child: Column(
              children: emergencyContacts.map((contact) {
                return ListTile(
                  title: Text(contact['name']!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
                  subtitle: Text(contact['phone']!, style: TextStyle(color: Colors.black54),),
                  trailing: IconButton(
                    icon: const Icon(Icons.phone, color: Colors.blue,),
                    onPressed: () => _makePhoneCall(contact['phone']!),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Icon?> thumbIcon =
    MaterialStateProperty.resolveWith<Icon?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.lock);
        }
        return const Icon(Icons.lock_open_rounded);
      },
    );

    final MaterialStateProperty<Icon?> thumbIconSensors =
    MaterialStateProperty.resolveWith<Icon?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.warning);
        }
        return const Icon(Icons.done);
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => _showLogoutDialog(),
            child: Icon(Icons.exit_to_app, color: Colors.black,)),
        title: Text('Welcome, $userName!', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blueAccent.withOpacity(0.2),
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.8,
              color: Colors.blue.withOpacity(0.1),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Material(
                            elevation: 10,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(70),
                              bottomLeft: Radius.circular(30),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(70),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Temp.',
                                          style: TextStyle(color: Colors.black54, fontSize: 20),
                                        ),
                                        Icon(Icons.ac_unit, color: Colors.black54, size: 20,)
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${_currentTemperature.toStringAsFixed(1)}°C',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Material(
                            elevation: 10,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(70),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(70),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_humidity%',
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40),
                                    ),
                                    const SizedBox(height: 5),
                                    const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Humidity',
                                          style: TextStyle(color: Colors.black54, fontSize: 20),
                                        ),
                                        Icon(Icons.water_drop_outlined, color: Colors.black54, size: 20,)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Row(
                        children: [
                          SizedBox(width: 6,),
                          Icon(Icons.miscellaneous_services),
                          SizedBox(width: 3,),
                          Text(
                            'Services',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Expanded(child: SizedBox(height: 1,))
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                height: 150,
                                width: 170,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: SleekCircularSlider(
                                    appearance: CircularSliderAppearance(
                                      animationEnabled: true,
                                      spinnerMode: false,
                                      customColors: CustomSliderColors(
                                        trackColor: Colors.blue[100]!,
                                        progressBarColor: Colors.blue.withOpacity(0.2),
                                        dotColor: Colors.blue,
                                      ),
                                      customWidths: CustomSliderWidths(
                                        trackWidth: 8,
                                        progressBarWidth: 12,
                                        handlerSize: 12,
                                      ),
                                      infoProperties: InfoProperties(
                                        mainLabelStyle: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                        bottomLabelText: 'Desired \n Temp.',
                                        bottomLabelStyle: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.blue.withOpacity(0.8),
                                        ),
                                        modifier: (double value) {
                                          final roundedValue = value.round();
                                          return '$roundedValue°C';
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
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                height: 150,
                                width: 170,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Motion detector', textAlign: TextAlign.center, style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),),

                                      Switch(
                                        activeColor: Colors.green,
                                        inactiveTrackColor: Colors.red.withOpacity(0.3),
                                        inactiveThumbColor: Colors.red,
                                        thumbIcon: thumbIcon,
                                        value: _activatePir,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _activatePir = value;
                                            _setActivatePir(value);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            //height: 150,
                            width: 350,
                            child: Column(
                              children: [
                                Container(
                                  width: 350,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)
                                      ),
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 2,
                                              color: Colors.blue.withOpacity(0.5)
                                          ))
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 15,),
                                        Text('Home safety', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20),),
                                        Expanded(child: SizedBox(height: 1,)),
                                        Icon(Icons.safety_check, color: Colors.black54,),
                                        SizedBox(width: 25,),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Row(
                                        children: [
                                          const Icon(Icons.local_fire_department, color: Colors.red,),
                                          const SizedBox(width: 4,),
                                          const Text('Fire protection', textAlign: TextAlign.center, style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),),

                                          const Expanded(child: SizedBox(height: 1,)),

                                          Switch(
                                            activeColor: Colors.green,
                                            inactiveTrackColor: _fireDetected ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                                            inactiveThumbColor: _fireDetected ? Colors.red : Colors.green,
                                            thumbIcon: thumbIconSensors,
                                            value: _fireDetected,
                                            onChanged: null,
                                          ),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          const Icon(Icons.water_drop, color: Colors.blue,),
                                          const SizedBox(width: 4,),
                                          const Text('Anti-flood system', textAlign: TextAlign.center, style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),),

                                          const Expanded(child: SizedBox(height: 1,)),

                                          Switch(
                                            activeColor: Colors.green,
                                            inactiveTrackColor: _waterDetected ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                                            inactiveThumbColor: _waterDetected ? Colors.red : Colors.green,
                                            thumbIcon: thumbIconSensors,
                                            value: _waterDetected,
                                            onChanged: null,
                                          ),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          const Icon(Icons.gas_meter, color: Colors.green,),
                                          const SizedBox(width: 4,),
                                          const Text('Gas detector', textAlign: TextAlign.center, style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),),

                                          const Expanded(child: SizedBox(height: 1,)),

                                          Switch(
                                            activeColor: Colors.green,
                                            inactiveTrackColor: _gasDetected ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                                            inactiveThumbColor: _gasDetected ? Colors.red : Colors.green,
                                            thumbIcon: thumbIconSensors,
                                            value: _gasDetected,
                                            onChanged: null,
                                          ),
                                        ],
                                      ),

                                      if(_activatePir)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                          child: Container(
                                            height: 1,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),

                                      if(_activatePir)
                                        Row(
                                          children: [
                                            const Icon(Icons.security, color: Colors.purple,),
                                            const SizedBox(width: 4,),
                                            const Text('Motion monitor', textAlign: TextAlign.center, style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            ),),

                                            const Expanded(child: SizedBox(height: 1,)),

                                            Switch(
                                              activeColor: Colors.green,
                                              inactiveTrackColor: previousMotionDetected ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                                              inactiveThumbColor: previousMotionDetected ? Colors.red : Colors.green,
                                              thumbIcon: thumbIconSensors,
                                              value: previousMotionDetected,
                                              onChanged: null,
                                            ),
                                          ],
                                        ),

                                      //SizedBox(height: 300,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 200,)
                    ],
                  ),
                ),
              ),
            ),
            Container(
                height: MediaQuery.sizeOf(context).height * 0.1,
                width: MediaQuery.sizeOf(context).width,
                color: Colors.blue.withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.home, color: Colors.black54,),
                              Text(
                                houseName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                            ],),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: VerticalDivider(
                        thickness: 2,
                        color: Colors.black12,
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.45,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, color: Colors.black54,),
                              Text(
                                houseAddress,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],),
                        ),
                      ),
                    )
                  ],
                )
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        //label: Text('Emergency'),
        backgroundColor: Colors.white,
        closeDialOnPop: true,
        direction: SpeedDialDirection.up,
        animatedIcon: AnimatedIcons.menu_home,
        elevation: 10,
        //activeLabel: Text('Emergency'),
        children: [
          SpeedDialChild(
            child: Icon(Icons.warning, color: Colors.red,),
            label: 'Warnings',
            onTap: () {
              List<String> warnings = [];

              if (_fireDetected) {
                warnings.add('Fire detected! Evacuate the area immediately and call the fire department.');
              }
              if (_gasDetected) {
                warnings.add('Gas leak detected! Leave the area immediately and call the gas company.');
              }
              if (_waterDetected) {
                warnings.add('Water detected! Turn off the main water supply and check for leaks.');
              }
              if (_activatePir && previousMotionDetected) { // Assuming motion detection is tied to the PIR activation
                warnings.add('Motion detected! Check your security cameras and ensure the area is secure.');
              }

              String message = warnings.isNotEmpty
                  ? warnings.join('\n\n')
                  : 'No warnings detected.';

              _showWarningDialog('Warning', message);
            },
          ),

          SpeedDialChild(
            child: Icon(Icons.edit, color: Colors.blue,),
            label: 'Edit Info',
            onTap: () => _showEditDialog(),
          ),

          SpeedDialChild(
            child: Icon(Icons.contact_phone,  color: Colors.blue,),
            label: 'My Contacts',
            onTap: () => _showEmergencyContactsDialog(),
          ),

          SpeedDialChild(
            child: Icon(Icons.add_call,  color: Colors.blue,),
            label: 'Add Contacts',
            onTap: () => _showAddEmergencyContactDialog(),
          ),

          SpeedDialChild(
            child: Icon(Icons.local_police, color: Colors.blue,),
            label: 'Call Police',
            onTap: () => _callPolice(),
          ),
        ],
      ),
    );
  }

  void _callPolice() {
    // Implement your logic to call the police here
    print("Calling police...");
  }
}

// Create a global key to access the navigator context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    home: DetailPage(),
  ));
}

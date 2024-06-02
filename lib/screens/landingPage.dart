import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'detailPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

    ///Read realtime time in realtime database
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Database Example'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage()),
          );
        } ,
        child: Text('Detalii'),
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
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );

    ///Read realtime firestore database
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("test_collection")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if(!snapshot.hasData){
              return const CircularProgressIndicator();
            }
            final userSnapshot = snapshot.data?.docs;
            if (userSnapshot!.isEmpty) {
              return const Text("no data");
            }
            return ListView.builder(
                itemCount: userSnapshot.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    /*leading: CircleAvatar(
                      child: userSnapshot[index]["test"],
                    ),*/
                    title: Text(userSnapshot[index]["test_field"]),
                  );
                });
          }),
    );
  }
}

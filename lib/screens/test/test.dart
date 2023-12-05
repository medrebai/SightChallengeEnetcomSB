import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  DatabaseReference dbRef = FirebaseDatabase(databaseURL: 'https://sightfinal-default-rtdb.firebaseio.com/').reference();
  int? id;
  @override
  void initState() {
    super.initState();
    readData();
  }

void readData() {
  dbRef.child('app/ID').onValue.listen((event) {
    final snapshot = event.snapshot;
    if (snapshot.exists) {
      setState(() {
        id = snapshot.value as int?;
      });
    } else {
      print('No data available.');
    }
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Database Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Value: ${id ?? 'Not available'}'),
          ],
        ),
      ),
    );
  }
}

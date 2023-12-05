import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sightfinal/constants/routes.dart';
import 'package:sightfinal/screens/graph.dart';
import 'package:sightfinal/screens/splitscreen/splitscreen.dart';
import 'package:sightfinal/screens/water_management_screen/graph2.dart';
import 'package:sightfinal/util/smart_devices_box.dart';

class WaterManagementPage extends StatefulWidget {
  const WaterManagementPage({Key? key}) : super(key: key);

  @override
  _WaterManagementPageState createState() => _WaterManagementPageState();
}

class _WaterManagementPageState extends State<WaterManagementPage> {
  DatabaseReference dbRef = FirebaseDatabase(databaseURL: 'https://sightfinal-default-rtdb.firebaseio.com/').reference();
  double? flowRate;
  String? waterQuality;
  double? waterFlow;

  List myWaterDevices = [
    ["Pump", "lib/icons/water-pump.png", true],
    ["Watering", "lib/icons/irrigation-system.png", false],
    ["Water Heater", "lib/icons/water-heater.png", false],
    ["Dishwasher", "lib/icons/dishwasher.png", false],
  ];

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() {
  dbRef.child('app/FlowRate').onValue.listen((event) {
    final snapshot = event.snapshot;
    if (snapshot.exists) {
      setState(() {
        flowRate = (snapshot.value as num)?.toDouble();
      });
    } else {
      print('No FlowRate data available.');
    }
  });

    dbRef.child('app/WaterQuality').onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        setState(() {
          waterQuality = snapshot.value as String?;
        });
      } else {
        print('No WaterQuality data available.');
      }
    });

    dbRef.child('app/WaterFlow').onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        setState(() {
          waterFlow = snapshot.value as double?;
        });
      } else {
        print('No WaterFlow data available.');
      }
    });
  }

  void waterSwitchChanged(bool value, int index) {
    setState(() {
      myWaterDevices[index][2] = value;
    });

    final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    if (value == true) {
      databaseReference.child('app/waterDevice${index + 1}').set(1);
    } else {
      databaseReference.child('app/waterDevice${index + 1}').set(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // menu icon
                    Icon(
                      Icons.menu,
                      color: Colors.grey[800],
                      size: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const SizedBox(width: 1),
                    CupertinoButton(
                      child: const Icon(
                        Icons.graphic_eq_outlined,
                        size: 45,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Routes.instance.push(widget: Stats1(), context: context);
                      },
                    ),
                    // account icon
                    CupertinoButton(
                      onPressed: () {
                        Routes.instance.push(
                            widget: ConsumptionManagementPage(),
                            context: context);
                      },
                      child: const Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Here, You Manage your",
                      style: GoogleFonts.openSans(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      'Water',
                      style: GoogleFonts.bebasNeue(
                        fontSize: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Flow Rate: ${flowRate ?? 'Not available'}',
                      style: GoogleFonts.openSans(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      'Water Quality: ${waterQuality ?? 'Not available'}',
                      style: GoogleFonts.openSans(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      'Water Flow: ${waterFlow ?? 'Not available'}',
                      style: GoogleFonts.openSans(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      'The Consumption is above the average (posibility of water leak)',
                      style: GoogleFonts.openSans(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Text(
                  "Your Water Devices",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  return SmartDeviceBox(
                    smartDeviceName: myWaterDevices[index][0],
                    iconPath: myWaterDevices[index][1],
                    powerOn: myWaterDevices[index][2],
                    onChanged: (value) => waterSwitchChanged(value, index),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

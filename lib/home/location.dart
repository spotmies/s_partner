import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:im_animations/im_animations.dart';
import 'package:spotmies_partner/login/legal_doc.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  var latitude = "";
  var longitude = "";
  String add1 = "";
  String add2 = "";
  String add3 = "";

  //function for location
  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lastPosition = await Geolocator.getLastKnownPosition();
    print(lastPosition);

    String lat = '${position.latitude}';
    String long = '${position.longitude}';

    print('$lat,$long');

    setState(() {
      latitude = '${position.latitude}';
      longitude = '${position.longitude}';
    });
  }

  @override
  void initState() {
    super.initState();
    getAddressofLocation();
  }

  getAddressofLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      add1 = addresses.first.featureName;
      add2 = addresses.first.addressLine;
      add3 = addresses.first.locality;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text('Set Loction', style: TextStyle(color: Colors.black)),
        elevation: 0,
        actions: [
          (getCurrentLocation == null)
              ? Text('No Data')
              : TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('partner')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .update({
                      'location.latitude': latitude,
                      'location.longitude': longitude,
                      'location.add1': add2,
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => Addimage()),
                        (route) => false);
                  },
                  child: Text('SAVE'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: ColorSonarDemo(),
              radius: 50.0,
            ),
            // SizedBox(height: 70,),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[100],
                    blurRadius: 5.0,
                  )
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Address:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('$latitude,$longitude'),
                  Text(add2),
                ],
              ),
            ),
            //  FlatButton(
            //   onPressed: () async {
            //     //(latitude=null)? CircularProgressIndicator():
            //   },
            //   color: Colors.blue[700],
            //   child: Text(
            //     'Get Location',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            ElevatedButton.icon(
              
                //color: Colors.blue[700],
                onPressed: () {
                  getCurrentLocation();
                  getAddressofLocation();
                },
                icon: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
                label:
                    Text('Get Location', style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}

class ColorSonarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ColorSonar(
          contentAreaRadius: 48.0,
          waveFall: 15.0,
          innerWaveColor: Colors.grey[100],
          middleWaveColor: Colors.grey[200],
          outerWaveColor: Colors.grey[100],
          waveMotion: WaveMotion.synced,
          child: CircleAvatar(
            child: Icon(
              Icons.location_on,
              size: 46,
              color: Colors.blue,
            ),
            backgroundColor: Colors.white,
            radius: 48.0,
          ),
        ),
      ),
    );
  }
}

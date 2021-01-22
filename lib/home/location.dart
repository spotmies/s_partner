import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotmies_partner/home/home.dart';

//import 'package:location/location.dart';
// var lPath;
// Future<void> data() async {
//   lPath = FirebaseFirestore.instance
//       .collection('partner')
//       .doc(FirebaseAuth.instance.currentUser.uid);
// }

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          // Container(
          //   height: 20,
          //   width: double.infinity,
          //   color: Colors.amber,
          // ),
          TextButton(
              onPressed: () {
                //lantitude and longitude
                FirebaseFirestore.instance
                    .collection('partner')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .update({
                  'location.latitude': latitude,
                  'location.longitude': longitude,
                  'location.add1':add1,
                  'location.add2':add2,
                });
                //address
              
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Home()),
                    (route) => false);
              },
              child: Text('SAVE'))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 46,
              color: Colors.blue[700],
            ),
            Text(
              'Get Location',
              style: TextStyle(fontSize: 20),
            ),
            Text('$latitude,$longitude'),
            FlatButton(
              onPressed: () async {
                getCurrentLocation();
                getAddressofLocation();
              },
              color: Colors.blue[700],
              child: Text(
                'Get Current Location',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(add1),
            Text(add2),
           // Text(add3)

            // SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:im_animations/im_animations.dart';
import 'package:spotmies_partner/home/home.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  double latitude;
  double longitude;
  String add1 = "";
  String add2 = "";
  String add3 = "";
  Set<Marker> _marker = {};
  BitmapDescriptor mapMarker;

  //function for location

  @override
  void initState() {
    super.initState();
    getAddressofLocation();
    setCustomMarker();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    getAddressofLocation();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[900],
        title: Text(
          'Set Loction',
        ),
        elevation: 0,
      ),
      body: GoogleMap(
          onMapCreated: onmapcreated,
          markers: _marker,
          myLocationButtonEnabled: true,
          // myLocationEnabled: true,
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 15,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[900],
        onPressed: () {
          FirebaseFirestore.instance
              .collection('partner')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .update({
            'location.latitude': latitude,
            'location.longitude': longitude,
            'location.add1': add2,
          });
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => Home()), (route) => false);
        },
        icon: Icon(Icons.gps_fixed),
        label: Text("Save Location"),
      ),
    );
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lastPosition = await Geolocator.getLastKnownPosition();
    print(lastPosition);

    String lat = '${position.latitude}';
    String long = '${position.longitude}';

    print('$lat,$long');

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
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
      add3 = addresses.first.subLocality;
    });
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'lib/assets/icon.png');
  }

  void onmapcreated(GoogleMapController controller) {
    setState(() {
      _marker.add(Marker(
          // draggable: true,
          // onDragEnd: ((newPostion) {
          //   setState(() {
          //     latitude = newPostion.latitude;
          //     longitude = newPostion.longitude;
          //     print('$latitude, $longitude');
          //   });
          // }),
          icon: mapMarker,
          markerId: MarkerId('id-1'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: add3,
            snippet: '$latitude,$longitude',
          )));
    });
  }
}

// class ColorSonarDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: ColorSonar(
//           contentAreaRadius: 48.0,
//           waveFall: 15.0,
//           innerWaveColor: Colors.grey[100],
//           middleWaveColor: Colors.grey[200],
//           outerWaveColor: Colors.grey[100],
//           waveMotion: WaveMotion.synced,
//           child: CircleAvatar(
//             child: Icon(
//               Icons.location_on,
//               size: 46,
//               color: Colors.blue,
//             ),
//             backgroundColor: Colors.white,
//             radius: 48.0,
//           ),
//         ),
//       ),
//     );
//   }
// }

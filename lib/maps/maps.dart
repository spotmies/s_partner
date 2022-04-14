// import 'dart:developer';

// import 'package:flutter/material.dart';
// // import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
// import 'package:spotmies_partner/reusable_widgets/geo_coder.dart';
// import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
// import 'package:spotmies_partner/utilities/snackbar.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Maps extends StatefulWidget {
//   final Map? coordinates;
//   final bool? isNavigate;
//   final Function? onComplete;
//   Maps({this.coordinates, this.isNavigate = true, this.onComplete});
//   @override
//   _MapsState createState() => _MapsState();
// }

// class _MapsState extends State<Maps> {
//   TextEditingController searchController = TextEditingController();
//   // Map coordinates;
//   Map<String, double> generatedCoordinates = {"lat": 0.00, "log": 0.00};

//   // _MapsState(this.coordinates);
//   GlobalKey<FormState> formkey = GlobalKey<FormState>();
//   GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
//   GoogleMapController? googleMapController;
//   Position? position;
//   double? lat;
//   double? long;
//   String? addressline = "";
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//   void getmarker(double lat, double long) {
//     MarkerId markerId = MarkerId(lat.toString() + long.toString());
//     Marker _marker = Marker(
//         markerId: markerId,
//         position: LatLng(lat, long),
//         onTap: () async {
//           final coordinated = widget.coordinates!.isEmpty
//               ? Coordinates(position!.latitude, position!.longitude)
//               : Coordinates(widget.coordinates?['latitude'],
//                   widget.coordinates?['logitude']);
//           var address =
//               await Geocoder.local.findAddressesFromCoordinates(coordinated);
//           var firstAddress = address.first.addressLine;

//           setState(() {
//             lat = widget.coordinates!.isEmpty
//                 ? position?.latitude
//                 : widget.coordinates?['latitude'];
//             long = widget.coordinates!.isEmpty
//                 ? position?.latitude
//                 : widget.coordinates?['logitude'];
//             addressline = firstAddress;
//           });
//           widget.coordinates!.isEmpty
//               ? bottomAddressSheet(position!.latitude, position!.longitude)
//               : bottomAddressSheet(widget.coordinates?['latitude'],
//                   widget.coordinates?['logitude']);
//         },
//         draggable: true,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         infoWindow: InfoWindow(snippet: 'Address'));
//     setState(() {
//       markers[markerId] = _marker;
//     });
//   }

//   void getCurrentLocation() async {
//     // ignore: unused_local_variable
//     LocationPermission permission;
    
//     permission = await Geolocator.requestPermission();
//     Position currentPosition =
//         await GeolocatorPlatform.instance.getCurrentPosition();
//     setState(() {
//       position = currentPosition;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _hight = MediaQuery.of(context).size.height -
//         MediaQuery.of(context).padding.top -
//         kToolbarHeight;
//     final _width = MediaQuery.of(context).size.width;
//     if (position == null)
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     return Scaffold(
//       key: scaffoldkey,
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         child: Stack(alignment: Alignment.topCenter, children: [
//           GoogleMap(
//             onTap: (tapped) async {
//               final coordinated =
//                   Coordinates(tapped.latitude, tapped.longitude);
//               var address = await Geocoder.local
//                   .findAddressesFromCoordinates(coordinated);
//               var firstAddress = address.first.addressLine;
//               if (markers.isNotEmpty) markers.clear();
//               if (markers.isEmpty) getmarker(tapped.latitude, tapped.longitude);

//               setState(() {
//                 lat = tapped.latitude;
//                 long = tapped.longitude;
//                 addressline = firstAddress;
//               });
//               bottomAddressSheet(lat!, long!);
//             },
//             // mapType: MapType.satellite,

//             buildingsEnabled: true,
//             compassEnabled: false,
//             trafficEnabled: true,
//             myLocationButtonEnabled: true,

//             onMapCreated: (GoogleMapController controller) {
//               setState(() {
//                 googleMapController = controller;
//               });
//             },
//             initialCameraPosition: CameraPosition(
//                 target: widget.coordinates!.isEmpty
//                     ? navigateMaps(widget.coordinates?['latitude'],
//                         widget.coordinates?['logitude'])
//                     //LatLng(coordinates['latitude'], coordinates['logitude'])
//                     : navigateMaps(position?.latitude, position?.longitude),
//                 zoom: 17),
//             markers: Set<Marker>.of(markers.values),
//           ),
//           Positioned(
//               top: _hight * 0.07,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.only(
//                       left: _width * 0.05, right: _width * 0.03),
//                   height: _hight * 0.07,
//                   width: _width * 0.9,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.grey[300]!,
//                             blurRadius: 5,
//                             spreadRadius: 3)
//                       ],
//                       borderRadius: BorderRadius.circular(15)),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextWid(
//                         text: 'Search',
//                         size: _width * 0.05,
//                         color: Colors.grey[500]!,
//                       ),
//                       Icon(
//                         Icons.search,
//                         color: Colors.grey[500]!,
//                       ),
//                     ],
//                   ),
//                 ),
//               ))
//         ]),
//       ),
//     );
//   }

//   navigateMaps(lati, logi) {
//     // if (markers.isNotEmpty) markers.clear();
//     if (markers.isEmpty) getmarker(lati, logi);
//     return LatLng(lati, logi);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   bottomAddressSheet(double lat, double long) {
//     final hight = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     log("lat long $lat $long $generatedCoordinates");
//     generatedCoordinates['lat'] = lat;
//     generatedCoordinates['log'] = long;
//     showModalBottomSheet(
//         context: context,
//         elevation: 22,
//         isScrollControlled: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(20),
//           ),
//         ),
//         builder: (BuildContext context) {
//           return Container(
//             height: hight * 0.35,
//             child: Column(
//               children: [
//                 Container(
//                   height: hight * 0.27,
//                   padding: EdgeInsets.all(width * 0.05),
//                   child: ListView(
//                     children: [
//                       TextWid(
//                         text: 'Your Address:',
//                         size: width * 0.06,
//                         weight: FontWeight.w600,
//                         flow: TextOverflow.visible,
//                       ),
//                       SizedBox(
//                         height: hight * 0.01,
//                       ),
//                       TextWid(
//                         text: addressline!,
//                         size: width * 0.055,
//                         weight: FontWeight.w600,
//                         flow: TextOverflow.visible,
//                         color: Colors.grey[700]!,
//                       ),
//                       TextWid(
//                         text: lat.toString() + ", " + long.toString(),
//                         size: width * 0.055,
//                         weight: FontWeight.w600,
//                         flow: TextOverflow.visible,
//                         color: Colors.grey[700]!,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButtonWidget(
//                       minWidth: width * 0.3,
//                       height: hight * 0.05,
//                       bgColor: Colors.indigo[50]!,
//                       buttonName: 'Close',
//                       textColor: Colors.grey[900]!,
//                       borderRadius: 15.0,
//                       textSize: width * 0.04,
//                       allRadius: true,
//                       leadingIcon: Icon(
//                         Icons.clear,
//                         size: width * 0.04,
//                         color: Colors.grey[900],
//                       ),
//                       borderSideColor: Colors.indigo[50]!,
//                       onClick: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     widget.isNavigate!
//                         ? ElevatedButtonWidget(
//                             minWidth: width * 0.5,
//                             height: hight * 0.05,
//                             bgColor: SpotmiesTheme.primary,
//                             onClick: () {
//                               try {
//                                 launch(
//                                     'https://www.google.com/maps/search/?api=1&query=$lat,$long');
//                               } catch (e) {}
//                             },
//                             buttonName: 'Navigate',
//                             textColor: Colors.white,
//                             allRadius: true,
//                             borderRadius: 15.0,
//                             textSize: width * 0.04,
//                             trailingIcon: Icon(
//                               Icons.near_me,
//                               size: width * 0.03,
//                               color: Colors.white,
//                             ),
//                             borderSideColor: SpotmiesTheme.primary,
//                           )
//                         : ElevatedButtonWidget(
//                             minWidth: width * 0.5,
//                             height: hight * 0.05,
//                             bgColor: SpotmiesTheme.primary,
//                             onClick: () {
//                               if (widget.onComplete == null)
//                                 return snackbar(
//                                     context, "something went wrong");
//                               widget.onComplete!(generatedCoordinates);
//                               // Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) => AccountType(
//                               //               coordinates: generatedCoordinates,
//                               //               phoneNumber: widget.phoneNumber,
//                               //             )));
//                             },
//                             buttonName: 'Save',
//                             textColor: Colors.white,
//                             allRadius: true,
//                             borderRadius: 15.0,
//                             textSize: width * 0.04,
//                             trailingIcon: Icon(
//                               Icons.gps_fixed,
//                               size: width * 0.03,
//                               color: Colors.white,
//                             ),
//                             borderSideColor: SpotmiesTheme.primary,
//                           )
//                   ],
//                 )
//               ],
//             ),
//           );
//         });
//   }
// }

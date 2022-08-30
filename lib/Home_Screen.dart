import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class Home extends StatefulWidget {
 static const String routName ='nsjakhkj';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSubscription.cancel();
  }
  Set<Marker> markers={

};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
    var usermarker=Marker(markerId: MarkerId('User position'),
      position:LatLng(locationData?.latitude??deflat, locationData?.longitude??deflong), );
    markers.add(usermarker);
  }
  void updatelocation(LatLng latLng)async{
    var usermarker=Marker(markerId: MarkerId('User position'),
      position:latLng, );
    markers.add(usermarker);
    setState(() {

    });
    final GoogleMapController controller = await _controller.future;
    var newcamera=CameraPosition(target:latLng,tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(newcamera));
   // location.changeSettings(accuracy: LocationAccuracy.high,interval: 1000);

  }

  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  LocationData? locationData;
  bool serviceEnabled=false;
  late StreamSubscription<LocationData>streamSubscription;
  late PermissionStatus permissionGranted;
double deflat =31.1021061;
double deflong =31.6895531;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.1021061, 31.6895531),
    zoom: 14.4746,
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(31.1021061, 31.6895531),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('Location',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: markers,
        onTap: (latlong){
          updatelocation(latlong);
        },
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: _goToTheLake,
          label: Text('To the lake!'),
          icon: Icon(Icons.directions_boat),
        ),
    );
  }




  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

 void getUserLocation()async{
   bool getpermision= await permision();
   bool getservice = await service();
   if (!getpermision)return;
   if(!getservice)return;
   if(getservice && getpermision){
     locationData= await location.getLocation();
     print('${locationData?.latitude} &&${locationData?.longitude}');
     streamSubscription=location.onLocationChanged.listen((newlocation){
       locationData=newlocation;
       updatelocation(LatLng(locationData?.latitude??deflat,locationData?.longitude??deflong));
       // setState(() {
       //
       // });
     });
   }
 }

 Future<bool> permision()async{

   permissionGranted = await location.hasPermission();
   if (permissionGranted == PermissionStatus.denied) {
     permissionGranted = await location.requestPermission();
   }
       return permissionGranted == PermissionStatus.granted;


 }

Future<bool> service ()async{
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    // if (!serviceEnabled) {
    //   return;
    // }
  }
  return serviceEnabled;
}
}
//AIzaSyDwoaW2KxvXlza2rLvbk-b96qR-Rhb7_gw
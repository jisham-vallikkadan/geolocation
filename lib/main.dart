import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Gpslocation(),
    );
  }
}

class Gpslocation extends StatefulWidget {
  const Gpslocation({Key? key}) : super(key: key);

  @override
  State<Gpslocation> createState() => _GpslocationState();
}

class _GpslocationState extends State<Gpslocation> {

  var latitue='';
  var longitue='';
  var attitud='';
  var addres='';
  var speed='';

  Future<void> updateposition()async{
    Position position=await _determinePosition();
    List data=await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        print('lovation got it');
        latitue=position.latitude.toString();
        longitue=position.longitude.toString();
        attitud=position.altitude.toString();
        // speed=position.speed.toString();
        // addres=data[0]['Country'].toString();
print(data[0]);
        addres='${data[0].subLocality}';
      });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                 setState(() {
                   updateposition();
                   print('searching');
                 });
                },
                icon: Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.red,
                )),
            Text('${addres}',style: TextStyle(fontSize: 25),),
            SizedBox(height: 19,),
            Text('${latitue}',style: TextStyle(fontSize: 25),),
            SizedBox(height: 19,),
            Text('${longitue}',style: TextStyle(fontSize: 25),),
            SizedBox(height: 19,),
            Text('${attitud}',style: TextStyle(fontSize: 25),),
            SizedBox(height: 19,),
            Text('${speed}',style: TextStyle(fontSize: 25),)
          ],
        ),
      ),
    );
  }
}

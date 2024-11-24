import 'package:cargo_app/features/screen/homepage_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/controllers/TrackFreight_controller.dart';
import '../authentication/models/usertracking_model.dart';
import 'package:flutter_open_street_map/flutter_open_street_map.dart';

class TrackFreightScreen extends StatefulWidget {
  String? id;
  final String freightName;
  final String freightId;
  final Map<String, dynamic> vendorDetails;

  TrackFreightScreen({
    required this.id,
    required this.freightName,
    required this.freightId,
    required this.vendorDetails,
  });

  @override
  State<TrackFreightScreen> createState() => _TrackFreightScreenState();
}

class _TrackFreightScreenState extends State<TrackFreightScreen> {
  bool isLoading = false;
  double? latitude;
  double? longitude;
  String? locationMessage;



  Future<void> _onTrackFreight() async {
    setState(() {
      isLoading = true;
      locationMessage = '';
    });

    try {
      // Use widget.id here
      TrackFreightController controller = TrackFreightController();
      TrackinguserModel trackingData =
      await controller.fetchTrackingDetails(widget.id ?? ''); // Use widget.id instead of widget.freightId

      double fetchedLatitude = trackingData.tracker.location.coordinates[0];
      double fetchedLongitude = trackingData.tracker.location.coordinates[1];

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrackFreightMapScreen(
            latitude: fetchedLatitude,
            longitude: fetchedLongitude,
            userLatitude: position.latitude,
            userLongitude: position.longitude,
          ),
        ),
      );

      // After 15 seconds, fetch the location again
      Future.delayed(Duration(seconds: 15), () async {
        Position newPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          latitude = newPosition.latitude;
          longitude = newPosition.longitude;
        });
      });

    } catch (error) {
      setState(() {
        isLoading = false;
        locationMessage = 'Failed to fetch location data';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    var vendorDetails = widget.vendorDetails; // Get the vendor details

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/cargologo.png',
                    height: 60,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Shipping. Easier!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your Carrier',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Freight: ${widget.freightName}', // Display the passed freight name
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Vendor Details Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFreightDetailRow('Driver Name', vendorDetails['name'] ?? 'N/A'),
                  _buildFreightDetailRow('Company Name', vendorDetails['companyName'] ?? 'N/A'),
                  _buildFreightDetailRow('Fleet Size', vendorDetails['fleetSize'] ?? 'N/A'),
                  _buildFreightDetailRow('Address', vendorDetails['address'] ?? 'N/A'),
                  _buildFreightDetailRow('Commercial Number', vendorDetails['commercialNumber'] ?? 'N/A'),
                  _buildFreightDetailRow('Email', vendorDetails['email'] ?? 'N/A'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Driver Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFreightDetailRow('Driver Number', vendorDetails['phone'] ?? 'N/A'),
                  _buildFreightDetailRow('License Number', 'DL123456789'),
                  _buildFreightDetailRow('Registration', 'D7142348'),
                  _buildFreightDetailRow('Truck License Plate', 'SYA 2845'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08085A),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _onTrackFreight,
                  child: Text(
                    'Track Freight',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFreightDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class TrackFreightMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double userLatitude;
  final double userLongitude;

  TrackFreightMapScreen({
    required this.latitude,
    required this.longitude,
    required this.userLatitude,
    required this.userLongitude,
  });

  @override
  _TrackFreightMapScreenState createState() => _TrackFreightMapScreenState();
}

class _TrackFreightMapScreenState extends State<TrackFreightMapScreen> {
  late double latitude;
  late double longitude;
  late double userLatitude;
  late double userLongitude;

  @override
  void initState() {
    super.initState();
    latitude = widget.latitude;
    longitude = widget.longitude;
    userLatitude = widget.userLatitude;
    userLongitude = widget.userLongitude;
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      print("Location permission is permanently denied. Please enable it in settings.");
      _showPermissionDialog();
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          userLatitude = position.latitude;
          userLongitude = position.longitude;
        });
      } else {
        print("Location permission is denied.");
      }
    } else {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Permission Denied'),
        content: Text('Location permission has been permanently denied. Please enable it in your device settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Geolocator.openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Freight Location"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Freight Location:\nLatitude: $latitude\nLongitude: $longitude",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Your Location:\nLatitude: $userLatitude\nLongitude: $userLongitude",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 500,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(latitude, longitude),
                  zoom: 12.0,
                  minZoom: 2.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(latitude, longitude),
                        builder: (ctx) => Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(userLatitude, userLongitude),
                        builder: (ctx) => Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [
                          LatLng(latitude, longitude), // Freight location
                          LatLng(userLatitude, userLongitude), // User location
                        ],
                        strokeWidth: 4.0,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
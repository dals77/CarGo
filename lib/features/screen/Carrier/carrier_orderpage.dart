import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../authentication/controllers/carrier_get_orders_controller.dart';
import '../../authentication/controllers/statuschanged_controller.dart';
import '../../authentication/models/carrier_orders_model.dart';
import 'package:http/http.dart' as http;


class CarrierOrdersScreen extends StatefulWidget {


  @override
  State<CarrierOrdersScreen> createState() => _CarrierOrdersScreenState();
}



class _CarrierOrdersScreenState extends State<CarrierOrdersScreen> {
  String userName = '';
  final CarrierOrdersController controller = Get.put(CarrierOrdersController());

  @override
  void initState() {
    super.initState();
    _loadUserName();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshOrders(); // Call this after the first build is complete
    });
  }


  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
    });
  }

  Future<void> _refreshPage() async {
     controller.refreshOrders(); // Manually refresh data
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(''),

        backgroundColor: Colors.white,
      ),
      body: Column(
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
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Hello, $userName!',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPage,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.carrierOrders.value == null) {
                  return Center(child: Text("No data available"));
                } else {
                  return ListView.builder(
                    itemCount: controller.carrierOrders.value!.shipments.length,
                    itemBuilder: (context, index) {
                      final shipment = controller.carrierOrders.value!.shipments[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => OrderDetailsPage(shipment: shipment)); // Pass shipment data
                        },
                        child: _buildFreightCard(
                          'assets/cargologo.png',
                          shipment.freightShipped,
                          'DHL',
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}


Widget _buildFreightCard(String imageUrl, String title, String company,) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Freight image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),

          // Text information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Freight title
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),

                // Company name
                Text(
                  company,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}






class OrderDetailsPage extends StatefulWidget {
  final Shipment shipment;

  OrderDetailsPage({required this.shipment});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String userName = '';
  double? latitude;
  double? longitude;
  bool isOrderAccepted = false;
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _getCurrentLocation();
    if (widget.shipment.status == 'Accept') {
      setState(() {
        isOrderAccepted = true;
      });
    }
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      print("Location permission is permanently denied.");
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print("Location permission is denied.");
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    latitudeController.text = latitude.toString();
    longitudeController.text = longitude.toString();
  }

  Future<void> _sendLocationToApi() async {
    if (latitude == null || longitude == null) {
      print("Unable to get the current location.");
      return;
    }

    final url = 'http://16.170.129.175/api/admin/track/create-track';
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'long': longitude,
      'lat': latitude,
      'orderId': widget.shipment.id,
    });

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 201) {
      print("Location sent successfully!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location sent successfully!")));
    } else {
      print("Failed to send location: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to send location")));
    }
  }

  final ShipmentstatusController _shipmentController = ShipmentstatusController();

  void _handleOrderAction(String action) async {
    // Pass shipment.id to the controller
    await _shipmentController.updateShipmentStatus(action, widget.shipment.id);

    // You can add any feedback to the user (SnackBar, etc.)
    String message = '';
    if (action == 'Accept') {
      message = 'Order Accepted';
    } else if (action == 'Decline') {
      message = 'Order Declined';
    } else if (action == 'Shipped') {
      message = 'Order Shipped';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


  Future<void> _showDeclineConfirmationDialog() async {
    bool? confirmDecline = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you really want to decline this order?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close dialog with 'No'
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Close dialog with 'Yes'
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );

    // If user confirmed to decline, navigate to CarrierOrdersScreen
    if (confirmDecline == true) {
      _handleOrderAction('Decline');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CarrierOrdersScreen(), // Replace with your screen widget
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            // Logo and tagline
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
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Greeting and Order Info
            Text(
              'Hello, $userName!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),

            // Open Order Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        'assets/user_avatar.png',
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Open Order',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF08085A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.shipment.freightShipped, // Display customer name
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Customer',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Pickup Location
            Text(
              'Pickup',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF08085A),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${widget.shipment.pickingUpFrom.city} - ${widget.shipment.pickingUpFrom.district} - ${widget.shipment.pickingUpFrom.zipCode}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    String pickupAddress = "${widget.shipment.pickingUpFrom.city}-${widget.shipment.pickingUpFrom.district}-${widget.shipment.pickingUpFrom.zipCode}";
                    _openMap(pickupAddress);  // Open pickup location on map
                  },
                  child: Text(
                    'View Map',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Arrow Icon
            Center(
              child: Icon(Icons.arrow_downward, color: Colors.grey),
            ),
            SizedBox(height: 16),

            // Delivery Location
            Text(
              'Delivery',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF08085A),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${widget.shipment.deliveryTo.city} - ${widget.shipment.deliveryTo.district} - ${widget.shipment.deliveryTo.zipCode}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    String deliveryAddress = "${widget.shipment.deliveryTo.city}-${widget.shipment.deliveryTo.district}-${widget.shipment.deliveryTo.zipCode}";
                    _openMap(deliveryAddress);  // Open delivery location on map
                  },
                  child: Text(
                    'View Map',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Sending Information
            Text(
              'Sending',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF08085A),
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.shipment.freightDescription, // Display sending information
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Accept and Decline buttons or End Order button
            isOrderAccepted
                ? SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF08085A),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  _handleOrderAction('shipped');
                },
                child: Text(
                  'End Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
                : Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF08085A),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      await _sendLocationToApi();
                      String deliveryAddress =
                          "${widget.shipment.deliveryTo.city}-${widget.shipment.deliveryTo.district}-${widget.shipment.deliveryTo.zipCode}";
                      _openMap(deliveryAddress);
                      _handleOrderAction('Accept');
                      setState(() {
                        isOrderAccepted = true;
                      });
                      Future.delayed(Duration(seconds: 15), () async {
                        await _sendLocationToApi();
                      });
                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _showDeclineConfirmationDialog(); // Show confirmation dialog
                    },
                    child: Text(
                      'Decline',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Open a location in the map
  void _openMap(String address) async {
    final formattedAddress = Uri.encodeFull(address); // Ensure the address is correctly encoded
    final googleMapsUrl = 'https://www.google.com/maps/search/?q=$formattedAddress';
    final googleMapsPackage = 'com.google.android.apps.maps';  // The package name for Google Maps app on Android

    if (Platform.isAndroid) {
      // Attempt to open the Maps app using a specific package for Android
      final url = 'google.navigation:q=$formattedAddress';
      if (await canLaunch(url)) {
        await launch(url);
      } else if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);  // Fallback to opening the link in the browser
      } else {
        throw 'Could not open the map in Google Maps.';
      }
    } else if (Platform.isIOS) {
      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Could not open the map on iOS.';
      }
    } else {
      throw 'Unsupported platform';
    }
  }
}
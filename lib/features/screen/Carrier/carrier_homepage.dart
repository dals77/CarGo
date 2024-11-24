import 'package:cargo_app/features/screen/Carrier/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../websocket.dart';
import 'carrier_orderpage.dart';
import 'orderhistory.dart';

class CarrierHomePage extends StatefulWidget {
  @override
  State<CarrierHomePage> createState() => _CarrierHomePageState();
}

class _CarrierHomePageState extends State<CarrierHomePage> {
  String userName = '';
  // final WebSocketService webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }



  @override
  void dispose() {
    // Close WebSocket connection when the screen is disposed
    // webSocketService.disconnect();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );

            },
            icon: Icon(Icons.settings, color: Colors.grey),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     webSocketService.connect();
          //   },
          //   child: Text('Send Message'),
          // ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              // Logo and tagline
              Column(
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
              SizedBox(height: 32),

              // User greeting
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello, $userName!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Open Orders button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarrierOrdersScreen(),
                    ),
                  );
                },
                child: _buildOptionCard(
                  icon: Icons.inventory_2_outlined,
                  label: 'Open Orders',
                ),
              ),
              SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryPage(),
                    ),
                  );
                },
                child: _buildOptionCard(
                  icon: Icons.history_outlined,
                  label: 'Order History',
                ),
              ),

              Spacer(),

              // Footer message
              Center(
                child: Text(
                  'With CARGO, Carriers Keep More ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({required IconData icon, required String label}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.grey),
            SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

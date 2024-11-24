import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripDetailsPage extends StatefulWidget {

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}


class _TripDetailsPageState extends State<TripDetailsPage> {

  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                        'assets/cargologo.png', // Replace with your logo asset
                        height: 60,
                      ),
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
                    color: Color(0xFF08085A),
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
                        Expanded(
                          child: Column(
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
                                'Mohamed Saleh',
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
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Call customer action
                          },
                          icon: Icon(Icons.phone, color: Color(0xFF08085A)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Pickup Details
                Text(
                  'Pickup Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF08085A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Al-Olaya Street, Riyadh',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // TODO: View instruction action
                      },
                      icon: Icon(Icons.edit, color: Color(0xFF08085A)),
                      label: Text(
                        'View Instruction',
                        style: TextStyle(color: Color(0xFF08085A)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: View map action
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
                  child: Icon(Icons.compare_arrows, color: Colors.blue.shade900),
                ),
                SizedBox(height: 16),

                // Delivery Details
                Text(
                  'Delivery Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF08085A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'King Fahd Road, Jeddah.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // TODO: View instruction action
                      },
                      icon: Icon(Icons.edit, color: Colors.blue.shade900),
                      label: Text(
                        'View Instruction',
                        style: TextStyle(color: Color(0xFF08085A)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: View map action
                      },
                      child: Text(
                        'View Map',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Recipient Contact
                Text(
                  'Recipient Contact',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Ibrahim Hamd',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: Call recipient action
                      },
                      icon: Icon(Icons.phone, color: Colors.blue.shade900),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Sending and Returning Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sending',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF08085A),
                          ),
                        ),
                        Text(
                          'Documents 3kg',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Returning',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF08085A),
                          ),
                        ),
                        Text(
                          'Documents 3kg',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Start Trip Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08085A), // Start Trip button color
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Start trip action
                  },
                  child: Center(
                    child: Text(
                      'Start Trip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

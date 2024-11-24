import 'package:cargo_app/features/screen/Carrier/profiledit_page.dart';
import 'package:cargo_app/features/screen/Carrier/user/profiledituser_page.dart';
import 'package:cargo_app/features/screen/Carrier/vendorcontact_page.dart';
import 'package:cargo_app/features/screen/homepage_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../authentication/controllers/deactivate_controller.dart';
import '../../authentication/screens/login/login_page.dart';
import '../userchangepassword_page.dart';
import 'carrier_homepage.dart';
import 'changecarrierpassword_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  final ProfiledeativateuserController _profileController = Get.put(ProfiledeativateuserController());


  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
    });
    print('Loaded username: $userName');
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarrierHomePage()),
              );
            },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),

                // Profile Image and Greeting
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/user_avatar.png'),
                ),
                SizedBox(height: 12),
                Text(
                  'Hello, $userName!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 24),

                // Account Setting List
                _buildSettingItem(
                  icon: Icons.settings,
                  title: 'Account Setting',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  icon: Icons.lock,
                  title: 'Change Password',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarrierChangePassword(),
                      ),
                    );
                    // Navigate to change password
                  },
                ),
                _buildSettingItem(
                  icon: Icons.message,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactUsVendorScreen(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24),
                Divider(color: Colors.grey.shade300),
                SizedBox(height: 16),

                // Logout and Deactivate Account
                _buildOptionItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();

                    // Remove specific key (_id) from SharedPreferences
                    await prefs.remove('userId');

                    // Optionally, clear other user-related data as well
                    await prefs.remove('authToken');
                    await prefs.remove('userName');
                    await prefs.remove('phone');
                    await prefs.remove('email');
                    await prefs.remove('commercialNumber');
                    await prefs.remove('fleetSize');
                    await prefs.remove('companyName');
                    await prefs.remove('address');

                    // Navigate back to the login page after logout
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                    );
                  },
                ),

                _buildOptionItem(
                  icon: Icons.cancel,
                  title: 'Deactivate Account',
                  onTap: () {
                    Get.defaultDialog(
                      title: 'Deactivate Account',
                      middleText: 'Are you sure you want to deactivate your account?',
                      textCancel: 'Cancel',
                      textConfirm: 'Yes',
                      confirmTextColor: Colors.white,
                      onConfirm: () async {
                        // Close the dialog before the API call
                        Get.back();


                        try {
                          await _profileController.vendorIddeactivateAccount();

                          // Show success message and close the loader
                          Get.back(); // Close the loading dialog
                          Get.snackbar(
                            'Success',
                            'Your account has been deactivated.',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        } catch (error) {
                          // Handle error and close the loader
                          Get.back(); // Close the loading dialog
                          Get.snackbar(
                            'Error',
                            'Failed to deactivate account. Please try again.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                    );
                  },
                ),

                SizedBox(height: 232),

                // Footer Text
                Center(
                  child: Text(
                    'With CARGO, Carriers Keep More',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create setting item widgets
  Widget _buildSettingItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF08085A),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // Helper method to create option item widgets
  Widget _buildOptionItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}

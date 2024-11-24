import 'package:cargo_app/features/screen/Carrier/profiledit_page.dart';
import 'package:cargo_app/features/screen/Carrier/user/profiledituser_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../authentication/controllers/deactivate_controller.dart';
import '../../../authentication/screens/login/login_page.dart';
import '../../homepage_page.dart';
import '../../userchangepassword_page.dart';
import 'contactuser_page.dart';

class ProfileUserPage extends StatefulWidget {
  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
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
    print('Loaded username: $userName');
  }

  final ProfiledeativateuserController _profileController = Get.put(ProfiledeativateuserController());


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
              MaterialPageRoute(builder: (context) => HomePage()),
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
                        builder: (context) => ProfileUserScreen(),
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
                        builder: (context) => UserChangePassword(),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  icon: Icons.message,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactUsScreen(),
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
                    await prefs.clear();

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
                        await _profileController.deactivateAccount();

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

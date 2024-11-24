import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../authentication/controllers/profilevendorupdate_controller.dart';

class CarrierChangePassword extends StatefulWidget {
  @override
  _CarrierChangePasswordState createState() => _CarrierChangePasswordState();
}

class _CarrierChangePasswordState extends State<CarrierChangePassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  bool isOldPasswordVisible = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final ProfileVendorController _profileController = Get.put(ProfileVendorController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Image(
              height: 150,
              width: 210,
              fit: BoxFit.contain,
              image: AssetImage('assets/cargologo.png'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Change Password?',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF08085A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter Your Old Password',
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: oldPasswordController,
                obscureText: !isOldPasswordVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      isOldPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isOldPasswordVisible = !isOldPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // New Password Field
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter Your New Password',
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: newPasswordController,
                obscureText: !isNewPasswordVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isNewPasswordVisible = !isNewPasswordVisible;
                      });
                    },
                  ),
                  labelText: '',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Confirm Password Field
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Confirm Your New Password',
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                  labelText: '',
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Update Password Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please fill in all password fields',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    if (newPasswordController.text != confirmPasswordController.text) {
                      Get.snackbar(
                        'Error',
                        'Passwords do not match',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    // Call the updateVendor method to update the password
                    _profileController.updatepasswordVendor(
                      newPasswordController: newPasswordController,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF08085A),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Obx(() => _profileController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Change Password', style: TextStyle(color: Colors.white))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../authentication/controllers/carrier_signup_controller.dart';
import '../../authentication/screens/onboarding_page.dart';

class CarrierProfileScreen extends StatefulWidget {
  @override
  _CarrierProfileScreenState createState() => _CarrierProfileScreenState();
}

class _CarrierProfileScreenState extends State<CarrierProfileScreen> {
  final CarrierProfileController controller = Get.put(CarrierProfileController());
  bool isTruckChecked = false;
  bool isVanChecked = false;
  bool isOtherChecked = false;
  TextEditingController _otherVehicleController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool obscureConfirmPassword = true;
  bool obscurePassword = true;

  // Method to save data to SharedPreferences
  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driverName', controller.nameController.text);
    await prefs.setString('companyName', controller.companyNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => OnboardPage()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Image.asset(
                        'assets/cargologo.png',
                        height: 60,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Set Up Your Carrier Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 2,
                        width: 80,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                // Form Fields
                _buildTextField(controller: controller.nameController, label: "Enter your Name"),
                SizedBox(height: 16),
                _buildPhoneNumberField(controller: controller.phoneController),
                SizedBox(height: 16),
                _buildTextField(controller: controller.emailController, label: "Enter your email address"),
                SizedBox(height: 16),
                _buildTextField(controller: controller.companyNameController, label: "Company Name"),
                SizedBox(height: 16),
                _buildTextField(controller: controller.commercialNumberController, label: "Commercial Registration Number"),
                SizedBox(height: 16),
                _buildTextField(controller: controller.addressController, label: "Address (Street, City, Province, Zip Code)"),
                SizedBox(height: 16),
                _buildTextField(controller: controller.fleetSizeController, label: "Fleet Size (Number of vehicles)"),
                SizedBox(height: 16),
                // Password Field
                _buildPasswordField(controller: controller.passwordController),

                SizedBox(height: 16),

                Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Confirm password",
                        labelStyle: TextStyle(color: Colors.black),
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        } else if (value != controller.passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                SizedBox(height: 24),
                // Upload Insurance Documents
                _buildUploadField(
                  label: "Upload Insurance Documents",
                  image: _insuranceDocument,
                  onImageSelected: (image) {
                    setState(() {
                      _insuranceDocument = image;
                      print('Selected image path: ${image!.path}');
                    });
                  },
                ),
                SizedBox(height: 16),
                // Certifications or Licenses
                _buildUploadField(
                  label: "Certifications or Licenses",
                  image: _certifications,
                  onImageSelected: (image) {
                    setState(() {
                      _certifications = image;
                    });
                  },
                ),
                SizedBox(height: 16),
                // Vehicle Types
                _buildVehicleTypeSection(),
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () async {
                    if (_insuranceDocument == null || _certifications == null) {
                      Get.snackbar(
                        'Missing Required Documents',
                        'Please upload both insurance documents and certifications.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    } else if (controller.passwordController.text.isEmpty) {
                      Get.snackbar(
                        'Password Error',
                        'Password cannot be empty.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    } else if (!_validatePassword(controller.passwordController.text)) {
                      Get.snackbar(
                        'Password Error',
                        'Password must start with a capital letter and contain "@"',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    } else {
                      // Print each field to verify data before API call
                      print("Name: ${controller.nameController.text}");
                      print("Phone Number: ${controller.phoneController.text}");
                      print("Email: ${controller.emailController.text}");
                      print("Company Name: ${controller.companyNameController.text}");
                      print("Commercial Number: ${controller.commercialNumberController.text}");
                      print("Address: ${controller.addressController.text}");
                      print("Fleet Size: ${controller.fleetSizeController.text}");
                      print("Password: ${controller.passwordController.text}");
                      print("Insurance Document Path: ${_insuranceDocument?.path}");
                      print("Certifications Document Path: ${_certifications?.path}");
                      print("Selected Vehicle Type(s): Truck: $isTruckChecked, Van: $isVanChecked, Other: $isOtherChecked");
                      if (isOtherChecked) print("Other Vehicle Type: ${_otherVehicleController.text}");

                      await _saveProfileData();
                      controller.createVendor();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF08085A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white)),
                )),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Function to validate the password
  bool _validatePassword(String password) {
    final regex = RegExp(r'^[A-Z].*@');
    return regex.hasMatch(password);
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: UnderlineInputBorder(),
      ),
    );
  }


  Widget _buildPhoneNumberField({required TextEditingController controller}) {
    final CarrierProfileController carrierController = Get.put(CarrierProfileController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                const Text('+966'),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: carrierController.phoneController,
              decoration: const InputDecoration(
                labelText: "Enter your phone number",
                labelStyle: TextStyle(color: Colors.black),
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Only allow digits
                LengthLimitingTextInputFormatter(9), // Limit to 9 digits
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone Number is required';
                } else if (value.length != 9) {
                  return 'Phone Number must be 9 digits';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }


  final ImagePicker _picker = ImagePicker();
  XFile? _insuranceDocument;
  XFile? _certifications;
  XFile? _selectedImage;

  Widget _buildUploadField({required String label, required XFile? image, required Function(XFile?) onImageSelected}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            IconButton(
              onPressed: () async {
                final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  onImageSelected(pickedImage);
                } else {
                  print('No image selected');
                }
              },
              icon: Icon(Icons.cloud_upload_outlined, color: Colors.grey),
            ),
          ],
        ),
        // Show the selected image if available
        if (image != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.file(
              File(image.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

  // Password validation method
  String? _validatePasswords(String value) {
    final regex = RegExp(r'^[A-Z].*@');
    if (!regex.hasMatch(value)) {
      return 'Password must start with a capital letter and contain "@"';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }


  Widget _buildPasswordField({required TextEditingController controller}) {

    String? _passwordErrorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscurePassword, // Use the state variable for visibility
          decoration: InputDecoration(
            labelText: "Enter your password",
            labelStyle: TextStyle(color: Colors.black),
            border: const UnderlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              _passwordErrorMessage = _validatePasswords(value); // Validate password
            });
          },
        ),
        if (_passwordErrorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _passwordErrorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildVehicleTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Types",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        SizedBox(height: 8),
        _buildCheckboxListTile(
          label: "Truck",
          description: "Description",
          value: isTruckChecked,
          onChanged: (value) {
            setState(() {
              isTruckChecked = value ?? false;
            });
          },
        ),
        _buildCheckboxListTile(
          label: "Van",
          description: "Description",
          value: isVanChecked,
          onChanged: (value) {
            setState(() {
              isVanChecked = value ?? false;
            });
          },
        ),
        _buildCheckboxListTile(
          label: "Other",
          description: "Description",
          value: isOtherChecked,
          onChanged: (value) {
            setState(() {
              isOtherChecked = value ?? false;
            });
          },
        ),
        if (isOtherChecked) _buildTextField(controller: _otherVehicleController, label: "Please specify"),
      ],
    );
  }

  Widget _buildCheckboxListTile({required String label, required String description, required bool value, required ValueChanged<bool?>? onChanged}) {
    return CheckboxListTile(
      title: Text(label),
      subtitle: Text(description),
      value: value,
      onChanged: onChanged,
    );
  }
}

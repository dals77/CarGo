import 'dart:io';
import 'package:cargo_app/features/screen/Carrier/profile_page.dart';
import 'package:cargo_app/features/screen/Carrier/user/profileuser_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../authentication/controllers/profileuserupdate_controller.dart';


class ProfileUserScreen extends StatefulWidget {
  @override
  _ProfileUserScreenState createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  String? userName;
  String? phone;
  String? email;
  String? companyName;
  String? commercialNumber;
  String? address;
  String? fleetSize;

  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _commercialNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _fleetSizeController = TextEditingController();
  final ProfileController _profileController = Get.put(ProfileController());


  bool isTruckChecked = false;
  bool isVanChecked = false;
  bool isOtherChecked = false;
  TextEditingController _otherVehicleController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool obscureConfirmPassword = true;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    loadUserData();

  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
      phone = prefs.getString('phone');
      email = prefs.getString('email');
      companyName = prefs.getString('companyName');
      commercialNumber = prefs.getString('commercialNumber');
      address = prefs.getString('address');
      fleetSize = prefs.getString('fleetSize');

      // Set the text controllers with the loaded values
      _nameController.text = userName ?? '';
      _phoneController.text = phone ?? '';
      _emailController.text = email ?? '';
      _companyNameController.text = companyName ?? '';
      _commercialNumberController.text = commercialNumber ?? '';
      _addressController.text = address ?? '';
      _fleetSizeController.text = fleetSize ?? '';
    });
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
                            onPressed: () async {
                              final updatedUserName = await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileUserPage()),
                              );
                              if (updatedUserName != null) {
                                setState(() {
                                  userName = updatedUserName;
                                  _nameController.text = userName ?? '';
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Image.asset(
                        'assets/icon.png',
                        height: 60,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Accounts Settings',
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
                _buildTextField(label: "Enter your Name", controller: _nameController),
                SizedBox(height: 16),
                // Phone Number Field
                _buildPhoneNumberField(controller: _phoneController),
                SizedBox(height: 16),
                _buildTextField(label: "Enter your email address", controller: _emailController),

                SizedBox(height: 16),

                // Other UI components...
                Obx(() => _profileController.isLoading.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () async {
                    await _profileController.updateUser(
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF08085A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save the Changes',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
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
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Enter your phone number",
                labelStyle: TextStyle(color: Colors.black),
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
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

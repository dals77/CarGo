import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileVendorController extends GetxController {
var isLoading = false.obs;
var errorMessage = ''.obs;

Future<String> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken') ?? '';
}

// Inside ProfileVendorController

  Future<void> updateVendor({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController companyNameController,
    required TextEditingController commercialNumberController,
    required TextEditingController addressController,
    required TextEditingController fleetSizeController,
  }) async {
    String token = await getAuthToken();

    isLoading.value = true;
    errorMessage.value = '';

    final url = Uri.parse('http://16.170.129.175/api/admin/vendor/update-vendor/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Create a body map for the request
    final Map<String, dynamic> body = {};

    if (nameController.text.isNotEmpty) body['name'] = nameController.text;
    if (emailController.text.isNotEmpty) body['email'] = emailController.text;
    if (phoneController.text.isNotEmpty) body['phone'] = phoneController.text;
    if (commercialNumberController.text.isNotEmpty) body['commercialNumber'] = commercialNumberController.text;
    if (addressController.text.isNotEmpty) body['address'] = addressController.text;
    if (companyNameController.text.isNotEmpty) body['companyName'] = companyNameController.text;
    if (fleetSizeController.text.isNotEmpty) body['fleetSize'] = fleetSizeController.text;


    try {
      final response = await http.put(url, headers: headers, body: jsonEncode(body));
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String message = data['message'] ?? 'Profile updated successfully';
        Get.snackbar(
          'Success',
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = 'Failed to update profile. Status code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatepasswordVendor({
    required TextEditingController newPasswordController,
  }) async {
    String token = await getAuthToken();

    isLoading.value = true;
    errorMessage.value = '';

    final url = Uri.parse('http://16.170.129.175/api/admin/vendor/update-vendor/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Create a body map for the request, now only including the new password
    final Map<String, dynamic> body = {};

    if (newPasswordController.text.isNotEmpty) {
      body['password'] = newPasswordController.text;
    }

    try {
      final response = await http.put(url, headers: headers, body: jsonEncode(body));
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String message = data['message'] ?? 'Password updated successfully';
        Get.snackbar(
          'Success',
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = 'Failed to update password. Status code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

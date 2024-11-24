import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
var isLoading = false.obs;
var errorMessage = ''.obs;

Future<String> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken') ?? '';
}

Future<void> updateUser({
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController phoneController,
}) async {
  String token = await getAuthToken();

  isLoading.value = true;
  errorMessage.value = '';

  final url = Uri.parse('http://16.170.129.175/api/user/update-user/');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Only include fields that have non-empty values
  final Map<String, dynamic> body = {};
  if (nameController.text.isNotEmpty) body['name'] = nameController.text;
  if (emailController.text.isNotEmpty) body['email'] = emailController.text;
  if (phoneController.text.isNotEmpty) body['phone'] = phoneController.text;

  try {
    final response = await http.put(url, headers: headers, body: jsonEncode(body));
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Check if the response status is 200 and contains the expected success message
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String message = data['message'] ?? 'Profile updated successfully'; // Get success message
      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white
      );
    } else {
      // Handle non-200 responses
      errorMessage.value = 'Failed to update profile. Status code: ${response.statusCode}';
    }
  } catch (e) {
    errorMessage.value = 'An error occurred: $e';
    print('Exception: $e');
  } finally {
    isLoading.value = false;
  }
}
}

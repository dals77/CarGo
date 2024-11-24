import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? '';
  }
  Future<void> changePassword(String oldPassword, String newPassword) async {
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields', backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      String token = await getAuthToken();

      final response = await http.put(
        Uri.parse('http://16.170.129.175/api/user/update-user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'oldPassword': oldPassword,  // Ensure this is the correct field name
          'password': newPassword,      // Use 'password' instead of 'newPassword'
        }),
      );

      final responseData = json.decode(response.body);
      print('Response status: ${response.statusCode}'); // Log status
      print('Response body: ${response.body}'); // Log full response body

      if (response.statusCode == 200 && responseData['message'] == 'User updated successfully') {
        Get.snackbar(
          'Success',
          'Password changed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Failed to change password',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../screen/Carrier/carrier_homepage.dart';
import '../../screen/homepage_page.dart';

class LoginController extends GetxController {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var staySignedIn = false.obs;

  Future<void> loginUser() async {
    isLoading(true);
    errorMessage('');
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage('Email and password cannot be empty');
      Get.snackbar(
        'Error',
        'Email and password cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      isLoading(false);
      return;
    }

    final url = Uri.parse('http://16.170.129.175/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"email": email, "password": password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        String token = data['token'] ?? '';
        String userId = data['user']?['_id'] ?? '';
        String message = data['message'] ?? '';
        String userType = data['user']?['type'] ?? '';
        String status = data['user']?['status'] ?? '';
        String name = data['user']?['name'] ?? '';
        String phone = data['user']?['phone'] ?? '';
        String email = data['user']?['email'] ?? '';
        String commercialNumber = data['user']?['commercialNumber'] ?? '';
        String fleetSize = data['user']?['fleetSize'] ?? '';
        String companyName = data['user']?['companyName'] ?? '';
        String address = data['user']?['address'] ?? '';

        // Save the token and other user details in SharedPreferences

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        await prefs.setString('userId', userId);
        await prefs.setString('userName', name);
        await prefs.setString('phone', phone);
        await prefs.setString('email', email);
        await prefs.setString('commercialNumber', commercialNumber);
        await prefs.setString('fleetSize', fleetSize);
        await prefs.setString('companyName', companyName);
        await prefs.setString('address', address);

        print('Saved username: ${prefs.getString('userName')}');

        if (status == 'active') {
          if (message == "User logged in successfully") {
            Get.snackbar(
              'Success',
              message,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );

            // Navigate to the appropriate page based on userType

            if (userType == 'vendor') {
              Get.offAll(() => CarrierHomePage());
            } else if (userType == 'user') {
              Get.offAll(() => HomePage());
            } else {
              errorMessage('Login failed: Invalid user type.');
            }
          }
        } else if (status == 'inactive') {
          // Show popup if account status is inactive
          Get.snackbar(
            'Account Inactive',
            'Your account is inactive. Please contact support.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        final errorResponse = json.decode(response.body);
        errorMessage(errorResponse['message'] ?? 'Login failed');
        Get.snackbar(
          'Error',
          errorResponse['message'] ?? 'Login failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      errorMessage('An error occurred: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading(false);
    }
  }

}

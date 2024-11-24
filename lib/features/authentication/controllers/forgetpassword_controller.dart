import 'package:cargo_app/features/authentication/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../screen/recoverforgetpassword_page.dart';

class ForgetPasswordController extends GetxController {
  // Reactive variables
  var email = ''.obs;
  var otp = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;


  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // API base URL
  final String apiBaseUrl = 'http://16.170.129.175/api/auth/';

  // Function to send the email for recovery
  Future<void> sendEmail() async {
    isLoading(true);
    errorMessage('');
    try {
      final response = await http.post(
        Uri.parse('${apiBaseUrl}forget-password'),
        body: json.encode({'email': email.value}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Success - proceed to verify OTP screen
        Get.to(() => VerifyOtpPage()); // Navigate to OTP verification screen
      } else {
        // Handle errors from API response
        errorMessage('Error: ${response.body}');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  // Function to verify OTP
  Future<void> verifyOtp() async {
    isLoading(true);
    errorMessage('');
    try {
      final response = await http.post(
        Uri.parse('${apiBaseUrl}verify-otp'),
        body: json.encode({'email': email.value, 'otp': otp.value}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // OTP verified, proceed to reset password
        Get.to(() => ResetPasswordPage()); // Navigate to password reset page
      } else {
        // Handle errors from API response
        errorMessage('Invalid OTP');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  // Function to reset password
  Future<void> resetPassword() async {
    isLoading(true);
    errorMessage('');
    try {
      // Ensure the new password and confirm password match
      if (newPassword.value != confirmPassword.value) {
        errorMessage('Passwords do not match');
        return;
      }

      // Prepare the request data
      final requestData = {
        'email': email.value,
        'otp': otp.value,
        'newPassword': newPassword.value,
        'confirmPassword': confirmPassword.value,
      };

      // Make the API call to reset the password
      final response = await http.post(
        Uri.parse('${apiBaseUrl}reset-password'),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
      print('${response.body}');

      if (response.statusCode == 200) {
        // Password reset successful, navigate back to login or success screen
        Get.to(() => LoginPage()); // Navigate to password reset page
      } else {
        // Handle errors from API response
        errorMessage('Error: ${response.body}');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

}

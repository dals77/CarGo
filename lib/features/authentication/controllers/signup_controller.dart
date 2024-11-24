import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../screen/verifytextfields_page.dart';
import '../../screen/welcome_page.dart';
import '../screens/login/login_page.dart';

class SignUpController extends GetxController {
  // Observables to manage loading state and error messages
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // OTP related variables
  var generatedOTP = ''.obs;

  /// Generates a 4-digit OTP
  String generate4DigitOTP() {
    final Random _random = Random();
    return (_random.nextInt(9000) + 1000).toString(); // Ensures a 4-digit number
  }

  /// Sends a verification email with the 4-digit OTP
  Future<bool> sendVerificationEmail(String recipientEmail, BuildContext context) async {
    String otp = generate4DigitOTP();
    generatedOTP.value = otp;

    try {
      // Your email content including the OTP
      final String emailContent = """
      
      Dear User,

      Please use the following OTP to verify your account:

      **OTP: $otp**

      This OTP is valid for 10 minutes.

      Best Regards,
      Team Cargo
      """;

      // Configure the SMTP server
      final smtpServer = gmail('ukashaaziz0@gmail.com', 'dhne vmba nkva xiyf');

      // Create the message
      final message = Message()
        ..from = Address('ukashaaziz0@gmail.com', 'Cargo')
        ..recipients.add(recipientEmail)
        ..subject = 'Cargo Registration Confirmation'
        ..text = emailContent;

      // Send the email
      await send(message, smtpServer);

      // Optionally, you can print or log the sent OTP for debugging
      print('OTP Sent: $otp');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification email sent. Please check your inbox.'),
        ),
      );

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending verification email: $e'),
        ),
      );
      return false;
    }
  }

  /// Handles user sign-up and sends OTP if successful
  Future<void> signUpUser({
    required String firstName,
    required String lastName,
    required String company,
    required String email,
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    // Combine first and last name for the 'name' field
    String fullName = '$firstName $lastName';

    isLoading.value = true;
    errorMessage.value = '';

    final url = Uri.parse('http://16.170.129.175/api/auth/signup');

    final body = jsonEncode({
      "name": fullName,
      "email": email,
      "password": password,
      "phone": phone,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful sign-up
        bool emailSent = await sendVerificationEmail(email, context);
        if (emailSent) {
          // Navigate to OTP Verification Page
          Get.to(() => VerifytextfieldsPage());
        } else {
          // If email sending failed, you can choose to navigate back or show an error
        }
      } else {
        // Handle errors based on response
        final responseData = jsonDecode(response.body);
        errorMessage.value = responseData['message'] ?? 'Failed to sign up. Please try again.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any other errors
      errorMessage.value = 'An error occurred. Please try again later.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Verifies the entered OTP
  void verifyOTP(String enteredOTP, BuildContext context) {
    if (enteredOTP == generatedOTP.value) {
      Get.snackbar(
        'Success',
        'User Created Successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Navigate to the Login Page
      Get.offAll(() => WelcomePage());
    } else {
      Get.snackbar(
        'Error',
        'Invalid OTP. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

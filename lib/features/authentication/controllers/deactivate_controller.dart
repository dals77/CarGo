import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfiledeativateuserController extends GetxController {
  var isLoading = false.obs;

  Future<void> deactivateAccount() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    isLoading.value = true;
    try {
      final url = Uri.parse('http://16.170.129.175/api/admin/user/update-user-status/$userId');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': 'active'}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Get.snackbar(
          'Success',
          'Your account has been deactivated',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to deactivate account: ${response.reasonPhrase}',
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

  Future<void> vendorIddeactivateAccount() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    isLoading.value = true;
    try {
      final url = Uri.parse('http://16.170.129.175/api/admin/vendor/update-vendor-status/$userId');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': 'active'}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Get.snackbar(
          'Success',
          'Your account has been deactivated',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to deactivate account: ${response.reasonPhrase}',
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authentication/screens/login/login_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120,),
            // Logo and Heading
            Column(
              children: [
                Image.asset(
                  'assets/cargologo.png',
                  height: 100,
                ),
                SizedBox(height: 8),
                Text(
                  'Shipping. Easier!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Mission Statement
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Our Mission is to connect the Shipper directly with the Carrier in an effective and efficient way!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 40),
            // Button
            SizedBox(
              width: 350,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAll(() => LoginPage());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: const Color(0xFF08085A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Let's Get Started!",
                  style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Spacer(),
            // Footer Text
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text.rich(
                TextSpan(
                  text: 'With ',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  children: [
                    TextSpan(
                      text: 'CARGO, ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),
                    TextSpan(
                      text: 'Carriers Keep More',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

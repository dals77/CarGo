import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF08085A),
        title: const Text('Privacy Policy & Terms of Use',style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF08085A),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'At CARGO, we are committed to protecting your privacy. This Privacy Policy outlines the '
              'types of personal information that we collect, how it is used, and the measures we take to '
              'safeguard your information.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Data Collection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF08085A),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We collect personal information such as name, email address, and phone number to provide '
              'you with the best possible service. Your data will be used solely for the purpose of '
              'communication, support, and improving our services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF08085A),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'By using CARGO’s services, you agree to abide by the following terms. All content on our '
              'platform is provided for informational purposes and may not be redistributed without our '
              'consent. We reserve the right to terminate accounts for violation of our policies.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Disclaimer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF08085A),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'CARGO does not assume responsibility for any inaccuracies in the data provided. Users '
              'are advised to verify information before acting on it. We are not liable for any damages '
              'incurred through the use of our services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Updates to This Policy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF08085A),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We may update this Privacy Policy and Terms of Use periodically. Any changes will be '
              'reflected on this page. We encourage users to review this page regularly.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/authentication/screens/verifytextfields_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../authentication/controllers/signup_controller.dart';
import '../authentication/screens/login/login_page.dart';

class VerifytextfieldsPage extends StatefulWidget {
  const VerifytextfieldsPage({super.key});

  @override
  State<VerifytextfieldsPage> createState() => _VerifytextfieldsPageState();
}

class _VerifytextfieldsPageState extends State<VerifytextfieldsPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _pinControllers =
  List.generate(4, (_) => TextEditingController());

  // Access the SignUpController
  final SignUpController _signUpController = Get.find<SignUpController>();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Function to handle OTP verification
  void _verifyOTP() {
    String enteredOTP = _pinControllers.map((e) => e.text).join();
    if (enteredOTP.length < 4) {
      Get.snackbar(
        'Error',
        'Please enter the 4-digit OTP.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Call the verifyOTP function from the controller
    _signUpController.verifyOTP(enteredOTP, context);
  }

  void _navigateToLogin() {
    Get.offAll(() => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: _navigateToLogin,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    Image(
                      height: 150,
                      width: 210,
                      fit: BoxFit.contain,
                      image: const AssetImage(
                        'assets/cargologo.png',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Verify Account',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF08085A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Aligning "Enter Pin" to the left
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Enter OTP',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // OTP Entry Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _pinControllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 3) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'We have sent a 4-digit OTP to your email to verify it’s you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Verify Account Button with subtle curve (radius: 5)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF08085A),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Verify Account',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 150),

              // Text at the bottom
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16, color: Color(0xFF09007D)),
                    children: <TextSpan>[
                      TextSpan(text: 'With '),
                      TextSpan(
                        text: 'CARGO',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: ', Carriers Keep More '),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

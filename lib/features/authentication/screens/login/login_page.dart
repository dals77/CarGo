import 'package:cargo_app/features/authentication/screens/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cargo_app/utils/constants/app_images.dart';
import '../../controllers/login_controller.dart';
import '../forgetpasword/forgetpassword_page.dart';
import '../signup/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());
  bool obscurePassword = true; // Define the password visibility state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => OnboardPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Image(
                height: 150,
                width: 210,
                fit: BoxFit.contain,
                image: AssetImage(AppImages.AppLogo2),
              ),
              const SizedBox(height: 10),
              const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF08085A),
                ),
              ),
              const SizedBox(height: 20),

              // Email and Password Fields
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF08085A),
                    ),
                  ),
                  TextField(
                    controller: loginController.emailController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF08085A)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF08085A),
                    ),
                  ),
                   TextField(
                      controller: loginController.passwordController,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Color(0xFF08085A)),
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF08085A),
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword; // Toggle password visibility
                            });
                          },
                        ),
                      ),
                      obscureText: obscurePassword, // Bind to obscurePassword
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Stay Signed In and Forgot Password Row
              Row(
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Obx(() {
                      return Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        value: loginController.staySignedIn.value, // Bind to staySignedIn
                        onChanged: (bool? value) {
                          if (value != null) {
                            loginController.staySignedIn.value = value; // Toggle staySignedIn state
                          }
                        },
                        activeColor: const Color(0xFF08085A),
                        checkColor: Colors.white,
                      );
                    }),
                  ),
                  const Text(
                    'Stay Signed In',
                    style: TextStyle(
                      color: Color(0xFF08085A),
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(() => ForgetpasswordPage());
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF08085A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Log In Button with GetX Obx for loading state
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: loginController.isLoading.value
                        ? null
                        : () {
                      print('selected');
                      loginController.loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: const Color(0xFF08085A),
                    ),
                    child: loginController.isLoading.value
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Log In',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 5),

              // Sign Up Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t Have an Account?",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF08085A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),

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

import 'package:cargo_app/features/screen/verifytextfields_page.dart';
import 'package:flutter/material.dart';
import '../authentication/screens/login/login_page.dart';

class VerifyaccountPage extends StatefulWidget {
  const VerifyaccountPage({super.key});

  @override
  State<VerifyaccountPage> createState() => _VerifyaccountPageState();
}

class _VerifyaccountPageState extends State<VerifyaccountPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
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
              const SizedBox(height: 20),
              const Text(
                'Verify your account using email or phone:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              // Email and Phone Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => VerifytextfieldsPage()),
                        );
                        },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEBFF),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFCEC9FF),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.email,
                              size: 30,
                              color: Color(0xFF08085A),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF08085A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 300),

              // Text at the bottom
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Color(0xFF09007D)),
                    children: <TextSpan>[
                      const TextSpan(text: 'With '),
                      const TextSpan(
                        text: 'CARGO',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const TextSpan(text: ', Carriers Keep More '),
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

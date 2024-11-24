import 'package:cargo_app/features/screen/Carrier/carrier_homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/authentication/screens/login/login_page.dart';
import 'features/authentication/screens/onboarding_page.dart';
import 'features/authentication/screens/signup/signup_page.dart';
import 'features/screen/homepage_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboard',
      getPages: [
        GetPage(name: '/onboard', page: () => OnboardPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/signup', page: () => SignUpPage()),
        GetPage(name: '/CarrierHomePage', page: () => CarrierHomePage()),
      ],
    );
  }
}

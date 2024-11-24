import 'package:cargo_app/features/screen/homepage_page.dart';
import 'package:cargo_app/features/screen/packagesdetail_page.dart';
import 'package:flutter/material.dart';

class PackagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/cargologo.png',
                        height: 60,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Shipping. Easier!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Package Title
                Text(
                  'PACKAGES',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 20),

                // Package Cards
                _buildPackageCard(
                  title: 'BASIC PACKAGE',
                  subtitle: '(3 Months)',
                  price: '30,500 SAR',
                  features: [
                    "Advanced Matching Algorithm",
                    "Criteria-based matching (cargo type, weight, distance, cost)",
                    "Email Support: Support for user inquiries during business hours",
                    "Shipment Limit: Up to 50 shipments per month",
                  ],
                  context: context,
                ),
                SizedBox(height: 16),
                _buildPackageCard(
                  title: 'STANDARD PACKAGE',
                  subtitle: '(6 Months)',
                  price: '80,500 SAR',
                  features: [
                    "Advanced Matching Algorithm",
                    "Criteria-based matching (cargo type, weight, distance, cost)",
                    "24/7 Chat Support",
                    "Real-time assistance available for urgent inquiries",
                    "Shipment Limit: Up to 150 shipments per month",
                  ],
                  context: context,
                ),
                SizedBox(height: 16),
                _buildPackageCard(
                  title: 'PREMIUM PACKAGE',
                  subtitle: '(12 Months)',
                  price: '120,000 SAR',
                  features: [
                    "Advanced Matching Algorithm",
                    "Criteria-based matching (cargo type, weight, distance, cost)",
                    "Dedicated Account Manager: Personalized support for onboarding and ongoing assistance",
                    "Priority Support: Faster response times for inquiries and issues",
                    "Unlimited Shipments: No restrictions on the number of shipments",
                  ],
                  context: context,
                ),

                SizedBox(height: 20),

                // Footer Text
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
      ),
    );
  }

  Widget _buildPackageCard({
    required String title,
    required String subtitle,
    required String price,
    required List<String> features,
    required BuildContext context,
  }) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          // Navigate to PricingPackagesScreen and pass the package details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PricingPackagesScreen(
                title: title,
                price: price,
                features: features,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFEFEFFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3C94),
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A3C94),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

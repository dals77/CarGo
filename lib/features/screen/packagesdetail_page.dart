import 'package:cargo_app/features/screen/packages_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

  class PricingPackagesScreen extends StatefulWidget {
  final String title;
  final String price;
  final List<String> features;

  PricingPackagesScreen({
    required this.title,
    required this.price,
    required this.features,
  });

  @override
  State<PricingPackagesScreen> createState() => _PricingPackagesScreenState();
}

class _PricingPackagesScreenState extends State<PricingPackagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     _showPaymentDialog(context);
          //   },
          //   child: Text(
          //     'Payment',
          //     style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
          //   ),
          // ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
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
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                _buildPackageCard(title: widget.price, features: widget.features),
                SizedBox(height: 40),
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


  void _showCustomPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFEFEFFF), // Light purple background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'COMING SOON...',
              style: TextStyle(
                color: Color(0xFF4A3C94),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Order more, Pay less\nStay tuned for updates!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PackagesScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2B1A70), // Dark blue background
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Take a Peak!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF76211), // Orange background
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPackageCard({required String title, required List<String> features}) {
    return GestureDetector(
      onTap: () {
        _showCustomPopup(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 8),
            ...features.map(
                  (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    XFile? selectedImage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Payment Instructions'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Account Number: 12345678\nPlease send the amount to this account.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.upload),
                  label: Text('Upload Screenshot'),
                  onPressed: () async {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        selectedImage = image;
                      });
                    }
                  },
                ),
                if (selectedImage != null) ...[
                  SizedBox(height: 16),
                  Text('Selected Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Image.file(
                    File(selectedImage!.path),
                    height: 100,
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the initial dialog
                  _showSuccessDialog(context); // Show success popup
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Make this dialog modal as well
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Screenshot uploaded successfully!'),
        actions: [
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the success dialog
            },
          ),
        ],
      ),
    );
  }
}

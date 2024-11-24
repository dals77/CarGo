import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'paymentsuccessfully_page.dart';

class PaymentDetailsPage extends StatefulWidget {
  @override
  _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardOwnerNameController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();
  final TextEditingController cvvCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo and Heading
                Column(
                  children: [
                    Image.asset(
                      'assets/cargologo.png',
                      height: 80,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Shipping. Easier!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                // Form Fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField(
                      'CARD NUMBER:',
                      cardNumberController,
                    ),
                    buildTextField(
                      'CARD OWNER NAME:',
                      cardOwnerNameController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            'EXPIRATION DATE:',
                            expirationDateController,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: buildTextField(
                            'CVV CODE:',
                            cvvCodeController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 32),
                // Confirm Payment Button
                SizedBox(
                  width: 350,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {

                        // Navigate to PaymentSuccessfulPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentSuccessfulPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Confirm Payment",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),
                // Payment Methods
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Mastercard.png', // Replace with your payment method icon paths
                      height: 40,
                    ),
                    SizedBox(width: 16),
                    Image.asset(
                      'assets/Visa.png',
                      height: 40,
                    ),
                    SizedBox(width: 16),
                    Image.asset(
                      'assets/Group 35.png',
                      height: 40,
                    ),
                    SizedBox(width: 16),
                    Image.asset(
                      'assets/Group 42.png',
                      height: 40,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Footer Text
                Text.rich(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

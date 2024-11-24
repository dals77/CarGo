import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authentication/controllers/forgetpassword_controller.dart';

class RecoverEmailPage extends StatelessWidget {
  final ForgetPasswordController controller = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const Image(
              height: 150,
              width: 210,
              fit: BoxFit.contain,
              image: AssetImage('assets/cargologo.png'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF08085A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter Your Email',
                  style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                onChanged: (value) => controller.email.value = value,
                decoration: const InputDecoration(
                  hintText: '',
                ),
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.sendEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08085A),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Recover Account',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            )),
            if (controller.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class VerifyOtpPage extends StatelessWidget {
  final ForgetPasswordController controller = Get.find();
  final List<TextEditingController> _pinControllers = List.generate(4, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // OTP Input Boxes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1, // Border width
                        ),
                        borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                      ),
                      child: TextField(
                        controller: _pinControllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '', // Hides the counter (e.g., "1/1")
                          border: InputBorder.none, // Removes the default border
                        ),
                        onChanged: (value) {
                          // Automatically move to next field
                          if (value.length == 1 && index < 3) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),

            SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                // Collect the OTP from the text fields and call verifyOtp
                controller.otp.value = _pinControllers.map((controller) => controller.text).join();
                controller.verifyOtp();
              },
              child: Text('Verify OTP'),
            )),
            if (controller.errorMessage.isNotEmpty)
              Text(
                controller.errorMessage.value,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}



class ResetPasswordPage extends StatelessWidget {
  final ForgetPasswordController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => controller.newPassword.value = value,
              decoration: InputDecoration(
                hintText: 'Enter new password',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) => controller.confirmPassword.value = value,
              decoration: InputDecoration(
                hintText: 'Confirm new password',
              ),
            ),
            SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: controller.resetPassword,
              child: Text('Reset Password'),
            )),
            if (controller.errorMessage.isNotEmpty)
              Text(
                controller.errorMessage.value,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

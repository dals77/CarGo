import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../authentication/controllers/carrier_get_orders_controller.dart';
import '../../authentication/controllers/carrierorderhistory_controller.dart';

class OrderHistoryPage extends StatelessWidget {

  final CarrierHistoryOrdersController  carrierOrdersController = Get.put(CarrierHistoryOrdersController());

  @override
  Widget build(BuildContext context) {

    carrierOrdersController.refreshOrders();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Logo and tagline
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/cargologo.png',
                        height: 60,
                      ),
                      const Text(
                        'Shipping. Easier!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Order History Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(Icons.history, color: Colors.blue.shade900),
                    title: const Text(
                      'Order History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF08085A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Observe and build list of carrier orders dynamically
                Obx(() {
                  if (carrierOrdersController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (carrierOrdersController.carrierOrders.value == null) {
                    return Center(
                      child: Text(
                        'No orders available.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: carrierOrdersController.carrierOrders.value!.shipments.length,
                      itemBuilder: (context, index) {
                        final order = carrierOrdersController.carrierOrders.value!.shipments[index];

                        String freightShipped = order.freightShipped ?? 'N/A';
                        String location = [
                          order.pickingUpFrom.city,
                          order.pickingUpFrom.district,
                          order.pickingUpFrom.zipCode,
                        ].where((element) => element.isNotEmpty).join(", ");

                        String date = order.pickUpDate?.toIso8601String().split("T").first ?? 'N/A';

                        return _buildOrderItem(
                          freightShipped: freightShipped,
                          location: location,
                          date: date,
                        );
                      },
                    );
                  }
                }),

                const SizedBox(height: 280),

                // Footer
                Center(
                  child: Text(
                    'With CARGO, Carriers Keep More',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create order item widgets
  Widget _buildOrderItem({required String freightShipped, required String location, required String date}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(Icons.location_on, color: Color(0xFF08085A)),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              freightShipped,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              location,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
        subtitle: Text(
          date,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

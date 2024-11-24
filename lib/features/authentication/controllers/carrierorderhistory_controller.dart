import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/carrier_orders_model.dart';

class CarrierHistoryOrdersController extends GetxController {
  var isLoading = false.obs;
  var carrierOrders = Rxn<CarrierOrders>();
  String apiUrl = 'http://16.170.129.175/api/admin/vendor/get-vendor-shipments/';

  @override
  void onInit() {
    super.onInit();
    // Try to fetch orders when the controller initializes
    fetchCarrierhistoryOrders();
  }

  // Method to fetch carrier orders
  Future<void> fetchCarrierhistoryOrders() async {
    if (carrierOrders.value != null) {
      // Data already fetched, skip the API call
      isLoading(false);
      return;
    }

    isLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null && userId.isNotEmpty) {
        final url = Uri.parse('$apiUrl$userId');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Parse the JSON response and update the carrierOrders variable
          carrierOrders.value = carrierOrdersFromJson(response.body);

          // Update the UI by notifying GetX listeners
          update();  // Make sure GetX listens for changes and refreshes UI
        } else {
          Get.snackbar("Error", "Failed to load data: ${response.statusCode}");
        }
      } else {
        Get.snackbar("Error", "User ID not found. Please log in again.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }

  // Refresh data explicitly
  void refreshOrders() {
    carrierOrders.value = null;  // Reset the orders before fetching again
    fetchCarrierhistoryOrders();
  }

  @override
  void onClose() {
    super.onClose();
    // You can clear or reset states here if needed
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shipfreightget_model.dart';

class ShipmentgetController extends GetxController {
  var shipments = <ShipmentElement>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? '';
  }

  Future<void> fetchShipments() async {
    String token = await getAuthToken();
    isLoading.value = true;
    errorMessage.value = '';

    final String apiUrl = 'http://16.170.129.175/api/user/shipmentform/shipments';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        final shipmentsResponse = Shipment.fromJson(parsedJson);
        shipments.value = shipmentsResponse.shipments!;

        if (shipments.isEmpty) {
          errorMessage.value = 'No shipments available';
        }
      } else {
        errorMessage.value = 'You Do Not Have Any Shipments Currently';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }
}

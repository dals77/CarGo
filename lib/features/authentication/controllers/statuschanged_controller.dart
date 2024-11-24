import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShipmentstatusController {
  final String apiUrl = 'http://16.170.129.175/api/admin/shipmentform/update-ship-status/';

  // Method to update shipment status
  Future<void> updateShipmentStatus(String status, String shipmentId) async {
    final response = await http.put(
      Uri.parse('$apiUrl$shipmentId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'status': status,
      }),
    );
    print('${shipmentId}');
    print('${response.body} ${response.statusCode}');

    if (response.statusCode == 200) {
      // Successfully updated status
      print('Shipment status updated to: $status');
    } else {
      // Handle failure response
      print('Failed to update shipment status');
    }
  }
}

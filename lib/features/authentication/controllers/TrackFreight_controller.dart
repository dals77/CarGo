import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/usertracking_model.dart';

class TrackFreightController {
  // Update the method to accept shipmentId as a parameter
  Future<TrackinguserModel> fetchTrackingDetails(String shipmentId) async {
    final url = 'http://16.170.129.175/api/admin/track/get-track/$shipmentId';  // Use the shipmentId in the URL
    final response = await http.get(Uri.parse(url));

    print('${response.body}');
    print('${shipmentId}');
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return trackinguserModelFromJson(response.body);
    } else {
      // If the server does not return a 200 OK response, throw an exception
      throw Exception('Failed to load tracking data');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/tracking_model.dart';

class TrackShipmentController {
  // API endpoint
  final String apiUrl = 'http://16.170.129.175/api/admin/track/create-track';

  Future<void> createTrack(TrackShipmentRequest request) async {
    try {
      // Make the API call
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode(request.toJson()), // Convert request to JSON
      );

      if (response.statusCode == 200) {
        // If the server returns a successful response
        print('Track Created Successfully: ${response.body}');
      } else {
        // If the server returns an error
        throw Exception('Failed to create track: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any error that occurs during the API call
      print('Error creating track: $error');
    }
  }
}

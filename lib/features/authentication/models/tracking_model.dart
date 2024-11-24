class TrackShipmentRequest {
  final double lat;
  final double long;
  final String orderId;

  TrackShipmentRequest({
    required this.lat,
    required this.long,
    required this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
      'orderId': orderId,
    };
  }
}

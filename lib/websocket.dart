// import 'package:geolocator/geolocator.dart';
//
// class WebSocketService {
//   late IO.Socket socket;
//
//   WebSocketService() {
//     socket = IO.io('ws://16.170.129.175', {
//       'transports': ['websocket'],
//       'autoConnect': false, // Set to false to avoid automatic connection
//     });
//   }
//
//   // Connect to the WebSocket server
//   void connect() {
//     socket.connect();
//     socket.on('connect', (_) {
//       print('Connected to WebSocket server');
//     });
//
//     // Listen for 'welcome' messages from the backend
//     socket.on('welcome', (data) {
//       print('Received welcome message: $data');
//     });
//
//     // Listen for other events like 'vendorLocationUpdate' and 'userLocationUpdate'
//     socket.on('vendorLocationUpdate', (data) {
//
//       print('Vendor location update: $data');
//
//     });
//
//     socket.on('userLocationUpdate', (data) {
//       print('User location update: $data');
//     });
//   }
//
//   // Send a message to the server
//   void sendMessage(String message) {
//     socket.emit('message', message);
//   }
//
//   // Register the user/vendor on the server
//   void register(String type, String id) {
//     socket.emit('register', {'type': type, 'id': id});
//   }
//
//   // Track location updates
//   Future<void> trackLocation(String type, String id) async {
//     try {
//       // Get the current position using Geolocator with high accuracy
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       // Construct the location data to be sent to the WebSocket server
//       Map<String, dynamic> location = {
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//       };
//
//       // Emit the location to the WebSocket server using the 'track' event
//       socket.emit('track', {
//         'type': type,
//         'id': id,
//         'location': location,
//       });
//
//
//       print('Sent location: $location');
//     } catch (e) {
//       print('Failed to get location: $e');
//     }
//   }
//
//
//   // Disconnect the WebSocket connection
//   void disconnect() {
//     socket.disconnect();
//   }
// }
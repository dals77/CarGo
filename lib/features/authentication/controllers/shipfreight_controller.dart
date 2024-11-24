import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';  // for image picking
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../screen/homepage_page.dart';
import '../../screen/payment_page.dart';

class ShipmentController extends GetxController {
  // Controllers for form fields

  // Existing controllers
  final TextEditingController freightShippedController = TextEditingController();
  final TextEditingController carrierRequirementController = TextEditingController();
  final TextEditingController freightDescriptionController = TextEditingController();

  // New controllers for pickup location
  final TextEditingController pickUpCityController = TextEditingController();
  final TextEditingController pickUpDistrictController = TextEditingController();
  final TextEditingController pickUpZipCodeController = TextEditingController();

  final TextEditingController deliveryCityController = TextEditingController();
  final TextEditingController deliveryDistrictController = TextEditingController();
  final TextEditingController deliveryZipCodeController = TextEditingController();

  var selectedVendorId = ''.obs;
  var isLoading = false.obs;

  final pickUpDateController = TextEditingController();
  final deliveryDateController = TextEditingController();

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? '';
  }

  var selectedCity = ''.obs;
  var selectedDistrict = ''.obs;

  var selectedPickupCity = ''.obs;
  var selectedPickupDistrict = ''.obs;



// List of cities
  final cities = [
    'Riyadh',
    'Jeddah',
    'Makkah',
    'Madinah',
    'Dammam',
    'Al Khobar',
    'Abha',
    'Tabuk',
    'Taif',
    'Al Ahsa'
  ];

  // Map of cities and their respective districts
  final Map<String, List<String>> cityDistricts = {
    'Riyadh': [
      'Al Olaya', 'Al Murabba', 'Al Malaz', 'Al Muhammadiyah', 'Diplomatic Quarter (DQ)',
      'Al Yasmin', 'Hittin', 'Al Rabwah', 'Al Sulimaniyah', 'Al Nakheel', 'Al Hamra', 'Qurtubah'
    ],
    'Jeddah': [
      'Al Hamra', 'Al Andalus', 'Al Rawdah', 'Al Salamah', 'Al Khalidiyah',
      'Al Shati', 'Al Muhammadiyah', 'Al Basateen', 'Al Zahra', 'Al Safa', 'Al Aziziyah', 'Al Rehab'
    ],
    'Makkah': [
      'Al Aziziyah', 'Al Shoqiyah', 'Al Awali', 'Al Rusaifa', 'Al Nassim', 'Al Maabdah',
      'Al Zahra', 'Al Kaakiya', 'Al Nakasa', 'Jarwal'
    ],
    'Madinah': [
      'Al Haram', 'Al Uyun', 'Al Aziziyah', 'Quba', 'Al Khalidiyah', 'Al Aqiq', 'Al Awali',
      'Bani Khidrah', 'Al Iskan', 'Al Shuraybat'
    ],
    'Dammam': [
      'Al Faisaliyah', 'Al Shati', 'Al Rakah', 'Al Khalidiyah', 'Al Anoud', 'Al Mazruiyah',
      'Al Murjan', 'Al Badiyah', 'Al Muhammadiyah', 'Al Fursan'
    ],
    'Al Khobar': [
      'Al Khobar Al Shamalia', 'Al Aqrabiyah', 'Al Rawabi', 'Al Olaya', 'Al Hamra',
      'Al Rakah Al Janubiyah', 'Al Yarmouk', 'Al Thuqbah', 'Al Khuzama', 'Al Sahafa'
    ],
    'Abha': [
      'Al Sadd', 'Al Shamasan', 'Al Manhal', 'Al Dabab', 'Al Rabwah', 'Al Khasha', 'Al Nasr',
      'Al Maqar', 'Al Ward', 'Al Mahalah'
    ],
    'Tabuk': [
      'Al Nuzhah', 'Al Muruj', 'Al Rawabi', 'Al Andalus', 'Al Ulaya', 'Al Qadisiyah', 'Al Rabi',
      'Al Wurud', 'Al Muhajir', 'Al Amwaj'
    ],
    'Taif': [
      'Al Shifa', 'Al Hada', 'Al Faisaliyah', 'Al Ruddaf', 'Al Khalidiyah', 'Al Rehab', 'Al Salamah',
      'Al Naseem', 'Al Shuhada', 'Al Wadi'
    ],
    'Al Ahsa': [
      'Al Mubarraz', 'Al Hofuf', 'Al Uqair', 'Al Shubah', 'Al Qara', 'Al Jishshah', 'Al Oyoon',
      'Al Khars', 'Al Samra', 'Al Manar'
    ],
  };

  List<String> get districts => cityDistricts[selectedCity.value] ?? [];


  final Map<String, List<String>> PickupcityDistricts = {
    'Riyadh': [
      'Al Olaya', 'Al Murabba', 'Al Malaz', 'Al Muhammadiyah', 'Diplomatic Quarter (DQ)',
      'Al Yasmin', 'Hittin', 'Al Rabwah', 'Al Sulimaniyah', 'Al Nakheel', 'Al Hamra', 'Qurtubah'
    ],
    'Jeddah': [
      'Al Hamra', 'Al Andalus', 'Al Rawdah', 'Al Salamah', 'Al Khalidiyah',
      'Al Shati', 'Al Muhammadiyah', 'Al Basateen', 'Al Zahra', 'Al Safa', 'Al Aziziyah', 'Al Rehab'
    ],
    'Makkah': [
      'Al Aziziyah', 'Al Shoqiyah', 'Al Awali', 'Al Rusaifa', 'Al Nassim', 'Al Maabdah',
      'Al Zahra', 'Al Kaakiya', 'Al Nakasa', 'Jarwal'
    ],
    'Madinah': [
      'Al Haram', 'Al Uyun', 'Al Aziziyah', 'Quba', 'Al Khalidiyah', 'Al Aqiq', 'Al Awali',
      'Bani Khidrah', 'Al Iskan', 'Al Shuraybat'
    ],
    'Dammam': [
      'Al Faisaliyah', 'Al Shati', 'Al Rakah', 'Al Khalidiyah', 'Al Anoud', 'Al Mazruiyah',
      'Al Murjan', 'Al Badiyah', 'Al Muhammadiyah', 'Al Fursan'
    ],
    'Al Khobar': [
      'Al Khobar Al Shamalia', 'Al Aqrabiyah', 'Al Rawabi', 'Al Olaya', 'Al Hamra',
      'Al Rakah Al Janubiyah', 'Al Yarmouk', 'Al Thuqbah', 'Al Khuzama', 'Al Sahafa'
    ],
    'Abha': [
      'Al Sadd', 'Al Shamasan', 'Al Manhal', 'Al Dabab', 'Al Rabwah', 'Al Khasha', 'Al Nasr',
      'Al Maqar', 'Al Ward', 'Al Mahalah'
    ],
    'Tabuk': [
      'Al Nuzhah', 'Al Muruj', 'Al Rawabi', 'Al Andalus', 'Al Ulaya', 'Al Qadisiyah', 'Al Rabi',
      'Al Wurud', 'Al Muhajir', 'Al Amwaj'
    ],
    'Taif': [
      'Al Shifa', 'Al Hada', 'Al Faisaliyah', 'Al Ruddaf', 'Al Khalidiyah', 'Al Rehab', 'Al Salamah',
      'Al Naseem', 'Al Shuhada', 'Al Wadi'
    ],
    'Al Ahsa': [
      'Al Mubarraz', 'Al Hofuf', 'Al Uqair', 'Al Shubah', 'Al Qara', 'Al Jishshah', 'Al Oyoon',
      'Al Khars', 'Al Samra', 'Al Manar'
    ],
  };

  List<String> get Pickupdistricts => PickupcityDistricts[selectedPickupCity.value] ?? [];

  // Get list of districts based on selected city


  var pickUpLocation = {}.obs;

  void updatePickUpLocation() {
    pickUpLocation.value = {
      "city": selectedPickupCity.trim(),
      "district": selectedPickupDistrict.trim(),
      "zipCode": pickUpZipCodeController.text.trim(),
    };
  }

  void updateDeliveryLocation() {
    deliveryLocation.value = {
      "city": selectedCity.trim(),
      "district": selectedDistrict.trim(),
      "zipCode": deliveryZipCodeController.text.trim(),
    };
  }

  var deliveryLocation = {}.obs;
  var freightImages = <XFile>[].obs;
  var selectedImages = <File>[].obs;

  // Method to pick freight images
  Future<void> pickFreightImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      for (var pickedFile in pickedFiles) {
        selectedImages.add(File(pickedFile.path));
      }
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }


  void clearForm() {
    // Clear all text controllers
    freightShippedController.clear();
    carrierRequirementController.clear();
    freightDescriptionController.clear();
    pickUpCityController.clear();
    pickUpDistrictController.clear();
    pickUpZipCodeController.clear();
    deliveryCityController.clear();
    deliveryDistrictController.clear();
    deliveryZipCodeController.clear();
    pickUpDateController.clear();
    deliveryDateController.clear();
    selectedVendorId.value = '';
    selectedCity.value = '';
    selectedDistrict.value = '';
    selectedPickupCity.value = '';
    selectedPickupDistrict.value = '';


    // Clear images
    selectedImages.clear();
  }





  Future<void> postFreightData(BuildContext context) async {

    isLoading.value = true; // Start loading

    updatePickUpLocation(); // Ensure pick-up location is updated
    updateDeliveryLocation(); // Ensure delivery location is updated

    String token = await getAuthToken();
    final url = Uri.parse('http://16.170.129.175/api/user/shipmentform/create-shipment');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    // Add text fields to the request
    request.fields['freightShipped'] = freightShippedController.text.trim();
    request.fields['carrierRequirement'] = carrierRequirementController.text.trim();
    request.fields['pickingUpFrom'] = jsonEncode(pickUpLocation.value);
    request.fields['deliveryTo'] = jsonEncode(deliveryLocation.value);
    request.fields['pickUpDate'] = pickUpDateController.text.trim();
    request.fields['deliveryDateBy'] = deliveryDateController.text.trim();
    request.fields['freightDescription'] = freightDescriptionController.text.trim();
    request.fields['vendorId'] = selectedVendorId.value;


    // Add images to the request if any
    for (var image in selectedImages) {
      request.files.add(
        await http.MultipartFile.fromPath('freightImages[]', image.path),
      );
    }

    try {
      updatePickUpLocation();
      updateDeliveryLocation();

      String token = await getAuthToken();
      final url = Uri.parse('http://16.170.129.175/api/user/shipmentform/create-shipment');

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      // Add only text fields to the request for now
      request.fields['freightShipped'] = freightShippedController.text.trim();
      request.fields['carrierRequirement'] = carrierRequirementController.text.trim();
      request.fields['pickingUpFrom'] = jsonEncode(pickUpLocation.value);
      request.fields['deliveryTo'] = jsonEncode(deliveryLocation.value);
      request.fields['pickUpDate'] = pickUpDateController.text.trim();
      request.fields['deliveryDateBy'] = deliveryDateController.text.trim();
      request.fields['freightDescription'] = freightDescriptionController.text.trim();
      request.fields['vendorId'] = selectedVendorId.value; // Add the selected vendorId


      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      isLoading.value = false;
      clearForm();

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Freight posted successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentDetailsPage(),
          ),
        );

      } else {
        print('Failed Response Body: $responseBody'); // Debugging response body
        Get.snackbar('Error', 'Failed to post freight: $responseBody',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

}

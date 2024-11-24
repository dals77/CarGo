import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/carrierget_model.dart';

class VendorController extends GetxController {
  var vendors = <Vendor>[].obs;
  var isLoading = true.obs;
  var selectedVendorId = ''.obs;



  // Fetch vendors from the API
  Future<void> fetchVendors() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('http://16.170.129.175/api/admin/vendor/get-vendors'));

      if (response.statusCode == 200) {
        CarrierModel carrierModel = carrierModelFromJson(response.body);
        vendors.assignAll(carrierModel.vendors);
      } else {
        Get.snackbar('Error', 'Failed to load vendors. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectVendor(String vendorId) {
    selectedVendorId.value = vendorId;
  }


}

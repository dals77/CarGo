import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../authentication/controllers/carrierget_controller.dart';
import '../authentication/controllers/shipfreight_controller.dart';
import 'homepage_page.dart';

class ShipFreightScreen extends StatefulWidget {
  @override
  State<ShipFreightScreen> createState() => _ShipFreightScreenState();
}

class _ShipFreightScreenState extends State<ShipFreightScreen> {
  // Initialize the ShipmentController
  final ShipmentController shipmentController = Get.put(ShipmentController());
  VendorController vendorController = Get.find<VendorController>();


  final Map<String, Map<String, String>> freightOptions = {
    'Select The Freight Type': {
      'freightTotal': '0',
      'shipperPays': '0',
      'carrierPays': '0'
    },
    'Car': {
      'freightTotal': '1000.00',
      'shipperPays': '9.95',
      'carrierPays': '9.95'
    },
    'Furniture': {
      'freightTotal': '500.00',
      'shipperPays': '7.50',
      'carrierPays': '7.50'
    },
    'Electronics': {
      'freightTotal': '1200.00',
      'shipperPays': '12.95',
      'carrierPays': '12.95'
    },
    'Machinery': {
      'freightTotal': '2000.00',
      'shipperPays': '15.95',
      'carrierPays': '15.95'
    },
    'Clothing': {
      'freightTotal': '300.00',
      'shipperPays': '5.95',
      'carrierPays': '5.95'
    },
    'Household Items': {
      'freightTotal': '800.00',
      'shipperPays': '8.95',
      'carrierPays': '8.95'
    },
    'Other': {
      'freightTotal': '600.00',
      'shipperPays': '6.95',
      'carrierPays': '6.95'
    },
  };

  String? selectedFreightType;


  @override
  void initState() {
    super.initState();
    vendorController.fetchVendors();
    selectedFreightType = freightOptions.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.to(() => HomePage());
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/cargologo.png',
                    height: 50,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Shipping. Easier!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ship Freight',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF08085A),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            // Textfields and dropdowns
            buildSectionTitle('Freight to be Shipped:'),
            buildTextField(
                'e.g: Lexus', shipmentController.freightShippedController),
            buildSectionTitle('Select Carrier Company:'),
            // buildTextField(
            //   '',
            //   shipmentController.carrierRequirementController,
            // ),
            VendorDropdown(),
            buildSectionTitle('Picking Up From:'),
            buildLocationWithLabels(),
            buildSectionTitle('Delivery To:'),
            buildDeliveryLocationWithLabels(),
            buildSectionTitle('Pick-Up Date:'),
            ElevatedButton(
              onPressed: () =>
                  selectDate(context, shipmentController.pickUpDateController),
              child: Text('Select Pick-Up Date'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: shipmentController.pickUpDateController,
              decoration: InputDecoration(
                hintText: 'Pick-Up Date',
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              readOnly: true,
            ),

            buildSectionTitle('Delivery Date By:'),
            ElevatedButton(
              onPressed: () =>
                  selectDate(
                      context, shipmentController.deliveryDateController),
              child: Text('Select Delivery Date'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: shipmentController.deliveryDateController,
              decoration: InputDecoration(
                hintText: 'Delivery Date',
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              readOnly: true,
            ),
            buildSectionTitle('Freight Description:'),
            buildTextField(
                'Type of product, number of packages, Weight (in lbs or kg), etc..',
                shipmentController.freightDescriptionController),

            SizedBox(height: 16),

            buildFreightTypeDropdown(),

            SizedBox(height: 16),
            buildSectionTitle('Freight Image(s):'),
            buildImageUploadButton(),
            SizedBox(height: 16),
            buildFreightCostDetails(),
            SizedBox(height: 16),
            buildPostFreightButton(),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Payment Method: Cash upon delivery',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'With CARGO, Carriers Keep More',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF08085A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context,
      TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  Widget buildTextField(String hintText, TextEditingController controller,
      {List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      inputFormatters: inputFormatters,
    );
  }



  Widget buildDeliveryLocationWithLabels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: buildFieldLabel('City')),
            SizedBox(width: 8),
            Expanded(child: buildFieldLabel('District')),
            SizedBox(width: 8),
            Expanded(child: buildFieldLabel('Zip Code')),
          ],
        ),
        Row(
          children: [
            // City Dropdown
            Expanded(
              child: Obx(() => DropdownButton<String>(
                value: shipmentController.selectedCity.value.isEmpty ? null : shipmentController.selectedCity.value,
                hint: Text('Select City'),
                isExpanded: true,
                items: shipmentController.cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  shipmentController.selectedCity.value = value!;
                  shipmentController.selectedDistrict.value = '';
                },
              )),
            ),
            SizedBox(width: 8),
            // District Dropdown
            Expanded(
              child: Obx(() => DropdownButton<String>(
                value: shipmentController.selectedDistrict.value.isEmpty ? null : shipmentController.selectedDistrict.value,
                hint: Text('Select District',style: TextStyle(fontSize: 15),),
                isExpanded: true,
                items: shipmentController.districts.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) {
                  shipmentController.selectedDistrict.value = value!;
                },
              )),
            ),
            SizedBox(width: 8),
            // Zip Code TextField
            Expanded(
              child: buildTextField(
                '',
                shipmentController.deliveryZipCodeController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget buildLocationWithLabels() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: buildFieldLabel('City')),
            SizedBox(width: 8),
            Expanded(child: buildFieldLabel('District')),
            SizedBox(width: 8),
            Expanded(child: buildFieldLabel('Zip Code')),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Obx(() => DropdownButton<String>(
                value: shipmentController.selectedPickupCity.value.isEmpty ? null : shipmentController.selectedPickupCity.value,
                hint: Text('Select City'),
                isExpanded: true,
                items: shipmentController.cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  shipmentController.selectedPickupCity.value = value!;
                  shipmentController.selectedPickupDistrict.value = '';
                },
              )),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Obx(() => DropdownButton<String>(
                value: shipmentController.selectedPickupDistrict.value.isEmpty ? null : shipmentController.selectedPickupDistrict.value,
                hint: Text('Select District',style: TextStyle(fontSize: 15),),
                isExpanded: true,
                items: shipmentController.Pickupdistricts.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) {
                  shipmentController.selectedPickupDistrict.value = value!;
                },
              )),
            ),
            SizedBox(width: 8),
            Expanded(
                child: buildTextField(
                  '',
                  shipmentController.pickUpZipCodeController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  Widget buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildImageUploadButton() {
    return Column(
      children: [
        // Display the selected images
        Obx(() {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // Prevent scrolling
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns
              childAspectRatio: 1,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: shipmentController.selectedImages.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      shipmentController.selectedImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: GestureDetector(
                      onTap: () {
                        shipmentController.removeImage(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }),

        SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            shipmentController.pickFreightImages();
          },
          child: Text('+ Add more'),
        ),
      ],
    );
  }

  Widget buildFreightTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Select Freight Type:'),
        DropdownButton<String>(
          value: selectedFreightType,
          onChanged: (String? newValue) {
            setState(() {
              selectedFreightType = newValue!;
            });
          },
          items: freightOptions.keys.map<DropdownMenuItem<String>>((
              String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down),
          underline: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildFreightCostDetails() {
    // Get the selected freight type details
    final freightDetails = freightOptions[selectedFreightType];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCostRow('Delivery Freight Total:',
              '${freightDetails?['freightTotal']} SAR'),
          buildCostRow('Shipper Pays CarGo:',
              '${freightDetails?['shipperPays']} SAR'),
          buildCostRow('Carrier Pays CarGo:',
              '${freightDetails?['carrierPays']} SAR'),
          buildCostRow(
            'Net Pay to Carrier:',
            '${(double.parse(freightDetails?['freightTotal'] ?? '0') -
                (double.parse(freightDetails?['shipperPays'] ?? '0') +
                    double.parse(freightDetails?['carrierPays'] ?? '0')))
                .toStringAsFixed(2)} SAR',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget buildCostRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }


  Widget buildPostFreightButton() {
    return Obx(() {
      return Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF08085A),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (shipmentController.selectedVendorId.value.isEmpty) {
                Get.snackbar('Error', 'Please select a vendor first.',
                    backgroundColor: Colors.red, colorText: Colors.white);
                return;
              }
              shipmentController.postFreightData(context);
            },
            child: shipmentController.isLoading.value
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
                : Text(
              'Post Freight',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      );
    });
  }
}


  class VendorDropdown extends StatelessWidget {
  final VendorController vendorController = Get.put(VendorController());
  final ShipmentController shipmentController = Get.find<ShipmentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (vendorController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      // Find the selected vendor by ID, if exists
      String? selectedVendorId = shipmentController.selectedVendorId.value;
      var selectedVendor = vendorController.vendors
          .firstWhereOrNull((vendor) => vendor.id == selectedVendorId);

      String selectedVendorName = selectedVendor != null ? selectedVendor.name : 'Select Vendor';

      return DropdownButton<String>(
        value: vendorController.vendors.any((vendor) => vendor.id == selectedVendorId)
            ? selectedVendorId
            : null,
        hint: Text(selectedVendorName),
        items: vendorController.vendors.map((vendor) {
          return DropdownMenuItem<String>(
            value: vendor.id,
            child: Text('${vendor.name} - ${vendor.companyName}'),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            vendorController.selectVendor(value);
            shipmentController.selectedVendorId.value = value; // Update vendorId
            print("Selected Vendor ID: ${shipmentController.selectedVendorId.value}"); // Print the vendor ID
          }
        },
      );
    });
  }
}



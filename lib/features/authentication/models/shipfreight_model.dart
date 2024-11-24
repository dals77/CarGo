class ShipmentRequest {
  String freightShipped;
  String carrierRequirements;
  Location pickingUpFrom;
  Location deliveryTo;
  String pickUpDate;
  String deliveryDateBy;
  String freightDescription;
  List<String> freightImages;

  ShipmentRequest({
    required this.freightShipped,
    required this.carrierRequirements,
    required this.pickingUpFrom,
    required this.deliveryTo,
    required this.pickUpDate,
    required this.deliveryDateBy,
    required this.freightDescription,
    required this.freightImages,
  });

  Map<String, dynamic> toJson() {
    return {
      'freightShipped': freightShipped,
      'carrierRequirements': carrierRequirements,
      'pickingUpFrom': pickingUpFrom.toJson(),
      'deliveryTo': deliveryTo.toJson(),
      'pickUpDate': pickUpDate,
      'deliveryDateBy': deliveryDateBy,
      'freightDescription': freightDescription,
      'freightImages': freightImages,
    };
  }
}

class Location {
  String city;
  String district;
  String zipCode;

  Location({
    required this.city,
    required this.district,
    required this.zipCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'district': district,
      'zipCode': zipCode,
    };
  }
}

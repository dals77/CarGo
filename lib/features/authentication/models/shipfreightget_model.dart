import 'dart:convert';

Shipment shipmentFromJson(String str) => Shipment.fromJson(json.decode(str));

String shipmentToJson(Shipment data) => json.encode(data.toJson());

class Shipment {
  List<ShipmentElement>? shipments;

  Shipment({
    required this.shipments,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
    shipments: json["shipments"] == null
        ? []
        : List<ShipmentElement>.from(
        json["shipments"].map((x) => ShipmentElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "shipments": shipments == null
        ? []
        : List<dynamic>.from(shipments!.map((x) => x.toJson())),
  };
}

class ShipmentElement {
  DeliveryTo? pickingUpFrom;
  DeliveryTo? deliveryTo;
  String? id;
  String? freightShipped;
  String? userId;
  VendorId? vendorId;
  String? status;
  DateTime? pickUpDate;
  DateTime? deliveryDateBy;
  String? freightDescription;
  List<String>? freightImages;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ShipmentElement({
    required this.pickingUpFrom,
    required this.deliveryTo,
    required this.id,
    required this.freightShipped,
    required this.userId,
    required this.vendorId,
    required this.status,
    required this.pickUpDate,
    required this.deliveryDateBy,
    required this.freightDescription,
    required this.freightImages,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ShipmentElement.fromJson(Map<String, dynamic> json) => ShipmentElement(
    pickingUpFrom: json["pickingUpFrom"] == null
        ? null
        : DeliveryTo.fromJson(json["pickingUpFrom"]),
    deliveryTo: json["deliveryTo"] == null
        ? null
        : DeliveryTo.fromJson(json["deliveryTo"]),
    id: json["_id"],
    freightShipped: json["freightShipped"],
    userId: json["userId"],
    vendorId: json["vendorId"] == null
        ? null
        : VendorId.fromJson(json["vendorId"]),
    status: json["status"],
    pickUpDate: json["pickUpDate"] == null
        ? null
        : DateTime.parse(json["pickUpDate"]),
    deliveryDateBy: json["deliveryDateBy"] == null
        ? null
        : DateTime.parse(json["deliveryDateBy"]),
    freightDescription: json["freightDescription"],
    freightImages: json["freightImages"] == null
        ? []
        : List<String>.from(json["freightImages"].map((x) => x)),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "pickingUpFrom": pickingUpFrom?.toJson(),
    "deliveryTo": deliveryTo?.toJson(),
    "_id": id,
    "freightShipped": freightShipped,
    "userId": userId,
    "vendorId": vendorId?.toJson(),
    "status": status,
    "pickUpDate": pickUpDate?.toIso8601String(),
    "deliveryDateBy": deliveryDateBy?.toIso8601String(),
    "freightDescription": freightDescription,
    "freightImages": freightImages == null
        ? []
        : List<dynamic>.from(freightImages!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class DeliveryTo {
  String? city;
  String? district;
  String? zipCode;

  DeliveryTo({
    required this.city,
    required this.district,
    required this.zipCode,
  });

  factory DeliveryTo.fromJson(Map<String, dynamic> json) => DeliveryTo(
    city: json["city"],
    district: json["district"],
    zipCode: json["zipCode"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "district": district,
    "zipCode": zipCode,
  };
}

class VendorId {
  String? id;
  String? name;
  String? email;
  String? type;
  String? status;
  String? phone;
  dynamic image;
  String? fleetSize;
  String? companyName;
  String? address;
  String? commercialNumber;
  DateTime? date;
  int? v;

  VendorId({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.status,
    required this.phone,
    required this.image,
    required this.fleetSize,
    required this.companyName,
    required this.address,
    required this.commercialNumber,
    required this.date,
    required this.v,
  });

  factory VendorId.fromJson(Map<String, dynamic> json) => VendorId(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    type: json["type"],
    status: json["status"],
    phone: json["phone"],
    image: json["image"],
    fleetSize: json["fleetSize"],
    companyName: json["companyName"],
    address: json["address"],
    commercialNumber: json["commercialNumber"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "type": type,
    "status": status,
    "phone": phone,
    "image": image,
    "fleetSize": fleetSize,
    "companyName": companyName,
    "address": address,
    "commercialNumber": commercialNumber,
    "date": date?.toIso8601String(),
    "__v": v,
  };
}

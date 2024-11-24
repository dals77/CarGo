// To parse this JSON data, do
//
//     final carrierOrders = carrierOrdersFromJson(jsonString);

import 'dart:convert';

CarrierOrders carrierOrdersFromJson(String str) => CarrierOrders.fromJson(json.decode(str));

String carrierOrdersToJson(CarrierOrders data) => json.encode(data.toJson());

class CarrierOrders {
    List<Shipment> shipments;
    Pagination pagination;

    CarrierOrders({
        required this.shipments,
        required this.pagination,
    });

    factory CarrierOrders.fromJson(Map<String, dynamic> json) => CarrierOrders(
        shipments: List<Shipment>.from(json["shipments"].map((x) => Shipment.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "shipments": List<dynamic>.from(shipments.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Pagination {
    int page;
    int limit;
    int total;
    bool hasNextPage;

    Pagination({
        required this.page,
        required this.limit,
        required this.total,
        required this.hasNextPage,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
        hasNextPage: json["hasNextPage"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "hasNextPage": hasNextPage,
    };
}

class Shipment {
    DeliveryTo pickingUpFrom;
    DeliveryTo deliveryTo;
    String id;
    String freightShipped;
    String userId;
    String vendorId;
    String status;
    DateTime pickUpDate;
    DateTime deliveryDateBy;
    String freightDescription;
    dynamic freightImages;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Shipment({
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

    factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
        pickingUpFrom: DeliveryTo.fromJson(json["pickingUpFrom"]),
        deliveryTo: DeliveryTo.fromJson(json["deliveryTo"]),
        id: json["_id"],
        freightShipped: json["freightShipped"],
        userId: json["userId"],
        vendorId: json["vendorId"],
        status: json["status"],
        pickUpDate: DateTime.parse(json["pickUpDate"]),
        deliveryDateBy: DateTime.parse(json["deliveryDateBy"]),
        freightDescription: json["freightDescription"],
        freightImages: json["freightImages"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "pickingUpFrom": pickingUpFrom.toJson(),
        "deliveryTo": deliveryTo.toJson(),
        "_id": id,
        "freightShipped": freightShipped,
        "userId": userId,
        "vendorId": vendorId,
        "status": status,
        "pickUpDate": pickUpDate.toIso8601String(),
        "deliveryDateBy": deliveryDateBy.toIso8601String(),
        "freightDescription": freightDescription,
        "freightImages": freightImages,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

class DeliveryTo {
    String city;
    String district;
    String zipCode;

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

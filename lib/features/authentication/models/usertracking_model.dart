// To parse this JSON data, do
//
//     final trackinguserModel = trackinguserModelFromJson(jsonString);

import 'dart:convert';

TrackinguserModel trackinguserModelFromJson(String str) => TrackinguserModel.fromJson(json.decode(str));

String trackinguserModelToJson(TrackinguserModel data) => json.encode(data.toJson());

class TrackinguserModel {
    String message;
    Tracker tracker;

    TrackinguserModel({
        required this.message,
        required this.tracker,
    });

    factory TrackinguserModel.fromJson(Map<String, dynamic> json) => TrackinguserModel(
        message: json["message"],
        tracker: Tracker.fromJson(json["tracker"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "tracker": tracker.toJson(),
    };
}

class Tracker {
    Location location;
    String id;
    OrderId orderId;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Tracker({
        required this.location,
        required this.id,
        required this.orderId,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory Tracker.fromJson(Map<String, dynamic> json) => Tracker(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        orderId: OrderId.fromJson(json["orderId"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "_id": id,
        "orderId": orderId.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

class Location {
    String type;
    List<double> coordinates;

    Location({
        required this.type,
        required this.coordinates,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}

class OrderId {
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

    OrderId({
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

    factory OrderId.fromJson(Map<String, dynamic> json) => OrderId(
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

import 'dart:convert';

// Function to parse JSON
CarrierModel carrierModelFromJson(String str) => CarrierModel.fromJson(json.decode(str));

// Function to convert CarrierModel to JSON
String carrierModelToJson(CarrierModel data) => json.encode(data.toJson());

class CarrierModel {
    List<Vendor> vendors;
    Pagination pagination;

    CarrierModel({
        required this.vendors,
        required this.pagination,
    });

    // Factory method to create CarrierModel from JSON
    factory CarrierModel.fromJson(Map<String, dynamic> json) => CarrierModel(
        vendors: List<Vendor>.from(json["vendors"].map((x) => Vendor.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    // Method to convert CarrierModel to JSON
    Map<String, dynamic> toJson() => {
        "vendors": List<dynamic>.from(vendors.map((x) => x.toJson())),
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

    // Factory method to create Pagination from JSON with null checks
    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"] ?? 1, // Default to 1 if null
        limit: json["limit"] ?? 10, // Default to 10 if null
        total: json["total"] ?? 0, // Default to 0 if null
        hasNextPage: json["hasNextPage"] ?? false, // Default to false if null
    );

    // Method to convert Pagination to JSON
    Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "hasNextPage": hasNextPage,
    };
}

class Vendor {
    String id;
    String name;
    String email;
    String type;
    String status;
    String phone;
    String? image; // Nullable field
    String fleetSize;
    String companyName;
    String address;
    String commercialNumber;
    DateTime date;
    int v;

    Vendor({
        required this.id,
        required this.name,
        required this.email,
        required this.type,
        required this.status,
        required this.phone,
        this.image, // Nullable field
        required this.fleetSize,
        required this.companyName,
        required this.address,
        required this.commercialNumber,
        required this.date,
        required this.v,
    });

    // Factory method to create Vendor from JSON with null checks
    factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["_id"] ?? '', // Default to empty string if null
        name: json["name"] ?? '', // Default to empty string if null
        email: json["email"] ?? '', // Default to empty string if null
        type: json["type"] ?? '', // Default to empty string if null
        status: json["status"] ?? '', // Default to empty string if null
        phone: json["phone"] ?? '', // Default to empty string if null
        image: json["image"], // Keep it nullable, can be null
        fleetSize: json["fleetSize"] ?? '', // Default to empty string if null
        companyName: json["companyName"] ?? '', // Default to empty string if null
        address: json["address"] ?? '', // Default to empty string if null
        commercialNumber: json["commercialNumber"] ?? '', // Default to empty string if null
        date: json["date"] != null ? DateTime.parse(json["date"]) : DateTime.now(), // Default to now if null
        v: json["__v"] ?? 0, // Default to 0 if null
    );

    // Method to convert Vendor to JSON
    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "type": type,
        "status": status,
        "phone": phone,
        "image": image, // Keep it nullable
        "fleetSize": fleetSize,
        "companyName": companyName,
        "address": address,
        "commercialNumber": commercialNumber,
        "date": date.toIso8601String(),
        "__v": v,
    };
}

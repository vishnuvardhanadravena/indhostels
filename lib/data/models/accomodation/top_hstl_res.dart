class AccomdationTopHstl {
  bool? success;
  int? statuscode;
  int? page;
  int? totalPages;
  List<TopHstlData>? data;

  AccomdationTopHstl({
    this.success,
    this.statuscode,
    this.page,
    this.totalPages,
    this.data,
  });

  AccomdationTopHstl.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    page = json['page'];
    totalPages = json['totalPages'];

    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((e) => TopHstlData.fromJson(e))
          .toList();
    }
  }
}

class TopHstlData {
  String? id;
  String? propertyName;
  String? propertyDescription;
  String? propertyType;
  String? categoryName;

  Location? location;

  List<String>? amenities;
  List<String>? roomTypes;
  List<String>? imagesUrl;

  HostDetails? hostDetails;

  List<PricingData>? pricingData;

  bool? tax;
  int? taxAmount;
  bool? isVerified;
  int? bookingCount;

  String? isBestFor;
  List<String>? nearby;

  double? averageRating;
  int? totalRatings;

  TopHstlData({
    this.id,
    this.propertyName,
    this.propertyDescription,
    this.propertyType,
    this.categoryName,
    this.location,
    this.amenities,
    this.roomTypes,
    this.imagesUrl,
    this.hostDetails,
    this.pricingData,
    this.tax,
    this.taxAmount,
    this.isVerified,
    this.bookingCount,
    this.isBestFor,
    this.nearby,
    this.averageRating,
    this.totalRatings,
  });

  TopHstlData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    propertyName = json['property_name'];
    propertyDescription = json['property_description'];
    propertyType = json['property_type'];
    categoryName = json['category_name'];

    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;

    amenities = json['amenities'] != null
        ? List<String>.from(json['amenities'])
        : [];

    roomTypes = json['room_types'] != null
        ? List<String>.from(json['room_types'])
        : [];

    imagesUrl = json['images_url'] != null
        ? List<String>.from(json['images_url'])
        : [];

    hostDetails = json['host_details'] != null
        ? HostDetails.fromJson(json['host_details'])
        : null;

    if (json['pricingData'] != null) {
      pricingData = (json['pricingData'] as List)
          .map((e) => PricingData.fromJson(e))
          .toList();
    }

    tax = json['tax'];
    taxAmount = json['tax_amount'];
    isVerified = json['isverified'];

    bookingCount = json['bookingcount'] ?? json[' bookingcount'];

    isBestFor = json['isbestfor'];

    nearby =
        json['nearby'] != null ? List<String>.from(json['nearby']) : [];

    totalRatings = json['totalRatings'];

    if (json['averageRating'] != null) {
      averageRating = (json['averageRating'] as num).toDouble();
    }
  }
}

class Location {
  String? city;
  String? area;
  String? address;
  String? locationurl;

  Location({this.city, this.area, this.address, this.locationurl});

  Location.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    area = json['area'];
    address = json['address'];
    locationurl = json['locationurl'];
  }
}

class HostDetails {
  String? hostName;
  String? hostContact;

  HostDetails({this.hostName, this.hostContact});

  HostDetails.fromJson(Map<String, dynamic> json) {
    hostName = json['host_name'];
    hostContact = json['host_contact'];
  }
}

class PricingData {
  String? id;
  String? accommodationId;
  String? roomId;
  List<Pricing>? pricing;

  PricingData({
    this.id,
    this.accommodationId,
    this.roomId,
    this.pricing,
  });

  PricingData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    accommodationId = json['accommodation_id'];
    roomId = json['room_id'];

    if (json['pricing'] != null) {
      pricing =
          (json['pricing'] as List).map((e) => Pricing.fromJson(e)).toList();
    }
  }
}

class Pricing {
  int? price;
  String? priceType;
  String? id;

  Pricing({this.price, this.priceType, this.id});

  Pricing.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    priceType = json['price_type'];
    id = json['_id'];
  }
}
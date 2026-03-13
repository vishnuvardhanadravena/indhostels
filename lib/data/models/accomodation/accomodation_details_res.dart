class AcommodationDetailsRes {
  bool? success;
  int? statuscode;
  String? message;
  Acommodation? data;
  // List<Null>? relatedAccommodations;

  AcommodationDetailsRes({
    this.success,
    this.statuscode,
    this.message,
    this.data,
    // this.relatedAccommodations
  });

  AcommodationDetailsRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    message = json['message'];
    data = json['data'] != null
        ? new Acommodation.fromJson(json['data'])
        : null;
    // if (json['relatedAccommodations'] != null) {
    //   relatedAccommodations = <Null>[];
    //   json['relatedAccommodations'].forEach((v) {
    //     relatedAccommodations!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statuscode'] = this.statuscode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    // if (this.relatedAccommodations != null) {
    //   data['relatedAccommodations'] =
    //       this.relatedAccommodations!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Acommodation {
  String? sId;
  String? propertyName;
  String? propertyDescription;
  String? propertyType;
  String? categoryName;
  Location? location;
  List<String>? amenities;
  List<String>? roomTypes;
  String? checkInTime;
  String? checkOutTime;
  String? cancellationPolicy;
  HostDetails? hostDetails;
  List<String>? imagesUrl;
  List<RoomId>? roomId;
  bool? tax;
  int? taxAmount;
  bool? isverified;
  int? bookingcount;
  String? isbestfor;
  List<String>? nearby;
  String? vendorId;
  double? avgRating;
  int? totalRatings;

  Acommodation({
    this.sId,
    this.propertyName,
    this.propertyDescription,
    this.propertyType,
    this.categoryName,
    this.location,
    this.amenities,
    this.roomTypes,
    this.checkInTime,
    this.checkOutTime,
    this.cancellationPolicy,
    this.hostDetails,
    this.imagesUrl,
    this.roomId,
    this.tax,
    this.taxAmount,
    this.isverified,
    this.bookingcount,
    this.isbestfor,
    this.nearby,
    this.vendorId,
    this.avgRating,
    this.totalRatings,
  });

  Acommodation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    propertyName = json['property_name'];
    propertyDescription = json['property_description'];
    propertyType = json['property_type'];
    categoryName = json['category_name'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    amenities = json['amenities'].cast<String>();
    roomTypes = json['room_types'].cast<String>();
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    cancellationPolicy = json['cancellation_policy'];
    hostDetails = json['host_details'] != null
        ? new HostDetails.fromJson(json['host_details'])
        : null;
    imagesUrl = json['images_url'].cast<String>();
    if (json['room_id'] != null) {
      roomId = <RoomId>[];
      json['room_id'].forEach((v) {
        roomId!.add(new RoomId.fromJson(v));
      });
    }
    tax = json['tax'];
    taxAmount = json['tax_amount'];
    isverified = json['isverified'];
    bookingcount = json['bookingcount'];
    isbestfor = json['isbestfor'];
    nearby = json['nearby'].cast<String>();
    vendorId = json['vendor_id'];
    avgRating = (json['avgRating'] as num?)?.toDouble();
    totalRatings = json['totalRatings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['property_name'] = this.propertyName;
    data['property_description'] = this.propertyDescription;
    data['property_type'] = this.propertyType;
    data['category_name'] = this.categoryName;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['amenities'] = this.amenities;
    data['room_types'] = this.roomTypes;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['cancellation_policy'] = this.cancellationPolicy;
    if (this.hostDetails != null) {
      data['host_details'] = this.hostDetails!.toJson();
    }
    data['images_url'] = this.imagesUrl;
    if (this.roomId != null) {
      data['room_id'] = this.roomId!.map((v) => v.toJson()).toList();
    }
    data['tax'] = this.tax;
    data['tax_amount'] = this.taxAmount;
    data['isverified'] = this.isverified;
    data['bookingcount'] = this.bookingcount;
    data['isbestfor'] = this.isbestfor;
    data['nearby'] = this.nearby;
    data['vendor_id'] = this.vendorId;
    data['avgRating'] = this.avgRating;
    data['totalRatings'] = this.totalRatings;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['area'] = this.area;
    data['address'] = this.address;
    data['locationurl'] = this.locationurl;
    return data;
  }
}

class HostDetails {
  String? hostContact;
  String? hostName;

  HostDetails({this.hostContact, this.hostName});

  HostDetails.fromJson(Map<String, dynamic> json) {
    hostContact = json['host_contact'];
    hostName = json['host_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['host_contact'] = this.hostContact;
    data['host_name'] = this.hostName;
    return data;
  }
}

class RoomId {
  String? sId;
  String? roomType;
  int? bedsAvailable;
  int? noOfGuests;
  int? noOfChildrens;
  List<String>? roomAmenities;
  List<String>? roomImagesUrl;
  String? roomDescription;
  int? roomsAvailable;
  String? accommodationId;
  List<Bookings>? bookings;
  PricingId? pricingId;

  RoomId({
    this.sId,
    this.roomType,
    this.bedsAvailable,
    this.noOfGuests,
    this.noOfChildrens,
    this.roomAmenities,
    this.roomImagesUrl,
    this.roomDescription,
    this.roomsAvailable,
    this.accommodationId,
    this.bookings,
    this.pricingId,
  });

  RoomId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roomType = json['room_type'];
    bedsAvailable = json['beds_available'];
    noOfGuests = json['no_of_guests'];
    noOfChildrens = json['no_of_childrens'];
    roomAmenities = json['room_amenities'].cast<String>();
    roomImagesUrl = json['room_images_url'].cast<String>();
    roomDescription = json['room_description'];
    roomsAvailable = json['rooms_available'];
    accommodationId = json['accommodation_id'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(new Bookings.fromJson(v));
      });
    }
    pricingId = json['pricing_id'] != null
        ? new PricingId.fromJson(json['pricing_id'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['room_type'] = this.roomType;
    data['beds_available'] = this.bedsAvailable;
    data['no_of_guests'] = this.noOfGuests;
    data['no_of_childrens'] = this.noOfChildrens;
    data['room_amenities'] = this.roomAmenities;
    data['room_images_url'] = this.roomImagesUrl;
    data['room_description'] = this.roomDescription;
    data['rooms_available'] = this.roomsAvailable;
    data['accommodation_id'] = this.accommodationId;
    if (this.bookings != null) {
      data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    }
    if (this.pricingId != null) {
      data['pricing_id'] = this.pricingId!.toJson();
    }
    return data;
  }
}

class Bookings {
  String? checkInDate;
  String? checkOutDate;
  String? sId;

  Bookings({this.checkInDate, this.checkOutDate, this.sId});

  Bookings.fromJson(Map<String, dynamic> json) {
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['_id'] = this.sId;
    return data;
  }
}

class PricingId {
  String? sId;
  String? accommodationId;
  String? roomId;
  List<Pricing>? pricing;

  PricingId({this.sId, this.accommodationId, this.roomId, this.pricing});

  PricingId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    accommodationId = json['accommodation_id'];
    roomId = json['room_id'];
    if (json['pricing'] != null) {
      pricing = <Pricing>[];
      json['pricing'].forEach((v) {
        pricing!.add(new Pricing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['accommodation_id'] = this.accommodationId;
    data['room_id'] = this.roomId;
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pricing {
  int? price;
  String? priceType;
  String? sId;

  Pricing({this.price, this.priceType, this.sId});

  Pricing.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    priceType = json['price_type'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['price_type'] = this.priceType;
    data['_id'] = this.sId;
    return data;
  }
}

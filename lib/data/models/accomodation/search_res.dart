class SerachByCatRes {
  bool? success;
  int? statuscode;
  String? message;
  List<Data>? data;
  Filters? filters;
  int? totalaccommodations;
  Pagination? pagination;

  SerachByCatRes({
    this.success,
    this.statuscode,
    this.message,
    this.data,
    this.filters,
    this.totalaccommodations,
    this.pagination,
  });

  SerachByCatRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    filters = json['filters'] != null
        ? new Filters.fromJson(json['filters'])
        : null;
    totalaccommodations = json['totalaccommodations'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statuscode'] = this.statuscode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.filters != null) {
      data['filters'] = this.filters!.toJson();
    }
    data['totalaccommodations'] = this.totalaccommodations;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
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
  List<PricingIds>? pricingIds;
  bool? isverified;
  int? bookingcount;
  String? isbestfor;
  List<String>? nearby;
  String? vendorId;
  double? averageRating;
  int? totalRating;
  String? hostContact;
  // int? bookingcount;
  bool? dealOfTheDay;
  int? dealOfferPercent;

  Data({
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
    this.pricingIds,
    this.isverified,
    this.bookingcount,
    this.isbestfor,
    this.nearby,
    this.vendorId,
    this.averageRating,
    this.totalRating,
    this.hostContact,
    // this.bookingcount,
    this.dealOfTheDay,
    this.dealOfferPercent,
  });

  Data.fromJson(Map<String, dynamic> json) {
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
    if (json['pricing_ids'] != null) {
      pricingIds = <PricingIds>[];
      json['pricing_ids'].forEach((v) {
        pricingIds!.add(new PricingIds.fromJson(v));
      });
    }
    isverified = json['isverified'];
    bookingcount = json['bookingcount'];
    isbestfor = json['isbestfor'];
    nearby = json['nearby'].cast<String>();
    vendorId = json['vendor_id'];
    averageRating = (json['averageRating'] as num?)?.toDouble();
    totalRating = json['totalRating'];
    hostContact = json['host_contact'];
    bookingcount = json[' bookingcount'];
    dealOfTheDay = json['deal_of_the_day'];
    dealOfferPercent = json['deal_offer_percent'];
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
    if (this.pricingIds != null) {
      data['pricing_ids'] = this.pricingIds!.map((v) => v.toJson()).toList();
    }
    data['isverified'] = this.isverified;
    data['bookingcount'] = this.bookingcount;
    data['isbestfor'] = this.isbestfor;
    data['nearby'] = this.nearby;
    data['vendor_id'] = this.vendorId;
    data['averageRating'] = this.averageRating;
    data['totalRating'] = this.totalRating;
    data['host_contact'] = this.hostContact;
    data[' bookingcount'] = this.bookingcount;
    data['deal_of_the_day'] = this.dealOfTheDay;
    data['deal_offer_percent'] = this.dealOfferPercent;
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
  String? createdAt;
  String? updatedAt;
  int? iV;

  PricingId({
    this.sId,
    this.accommodationId,
    this.roomId,
    this.pricing,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['accommodation_id'] = this.accommodationId;
    data['room_id'] = this.roomId;
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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

class PricingIds {
  String? sId;
  String? accommodationId;
  String? roomId;
  List<Pricing>? pricing;

  PricingIds({this.sId, this.accommodationId, this.roomId, this.pricing});

  PricingIds.fromJson(Map<String, dynamic> json) {
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

class Filters {
  List<String>? roomTypes;
  List<String>? amenities;
  List<String>? location;
  List<String>? category;
  int? minPrice;
  int? maxPrice;

  Filters({
    this.roomTypes,
    this.amenities,
    this.location,
    this.category,
    this.minPrice,
    this.maxPrice,
  });

  Filters.fromJson(Map<String, dynamic> json) {
    roomTypes = json['room_types'].cast<String>();
    amenities = json['amenities'].cast<String>();
    location = json['location'].cast<String>();
    category = json['category'].cast<String>();
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_types'] = this.roomTypes;
    data['amenities'] = this.amenities;
    data['location'] = this.location;
    data['category'] = this.category;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    return data;
  }
}

class Pagination {
  int? page;
  int? limit;

  Pagination({this.page, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}

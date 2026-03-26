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
        data!.add(Data.fromJson(v));
      });
    }
    filters = json['filters'] != null
        ? Filters.fromJson(json['filters'])
        : null;
    totalaccommodations = json['totalaccommodations'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statuscode'] = statuscode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (filters != null) {
      data['filters'] = filters!.toJson();
    }
    data['totalaccommodations'] = totalaccommodations;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
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
        ? Location.fromJson(json['location'])
        : null;
    amenities = json['amenities'].cast<String>();
    roomTypes = json['room_types'].cast<String>();
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    cancellationPolicy = json['cancellation_policy'];
    hostDetails = json['host_details'] != null
        ? HostDetails.fromJson(json['host_details'])
        : null;
    imagesUrl = json['images_url'].cast<String>();
    if (json['room_id'] != null) {
      roomId = <RoomId>[];
      json['room_id'].forEach((v) {
        roomId!.add(RoomId.fromJson(v));
      });
    }
    tax = json['tax'];
    taxAmount = json['tax_amount'];
    if (json['pricing_ids'] != null) {
      pricingIds = <PricingIds>[];
      json['pricing_ids'].forEach((v) {
        pricingIds!.add(PricingIds.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['property_name'] = propertyName;
    data['property_description'] = propertyDescription;
    data['property_type'] = propertyType;
    data['category_name'] = categoryName;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['amenities'] = amenities;
    data['room_types'] = roomTypes;
    data['check_in_time'] = checkInTime;
    data['check_out_time'] = checkOutTime;
    data['cancellation_policy'] = cancellationPolicy;
    if (hostDetails != null) {
      data['host_details'] = hostDetails!.toJson();
    }
    data['images_url'] = imagesUrl;
    if (roomId != null) {
      data['room_id'] = roomId!.map((v) => v.toJson()).toList();
    }
    data['tax'] = tax;
    data['tax_amount'] = taxAmount;
    if (pricingIds != null) {
      data['pricing_ids'] = pricingIds!.map((v) => v.toJson()).toList();
    }
    data['isverified'] = isverified;
    data['bookingcount'] = bookingcount;
    data['isbestfor'] = isbestfor;
    data['nearby'] = nearby;
    data['vendor_id'] = vendorId;
    data['averageRating'] = averageRating;
    data['totalRating'] = totalRating;
    data['host_contact'] = hostContact;
    data[' bookingcount'] = bookingcount;
    data['deal_of_the_day'] = dealOfTheDay;
    data['deal_offer_percent'] = dealOfferPercent;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['area'] = area;
    data['address'] = address;
    data['locationurl'] = locationurl;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['host_contact'] = hostContact;
    data['host_name'] = hostName;
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
        bookings!.add(Bookings.fromJson(v));
      });
    }
    pricingId = json['pricing_id'] != null
        ? PricingId.fromJson(json['pricing_id'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['room_type'] = roomType;
    data['beds_available'] = bedsAvailable;
    data['no_of_guests'] = noOfGuests;
    data['no_of_childrens'] = noOfChildrens;
    data['room_amenities'] = roomAmenities;
    data['room_images_url'] = roomImagesUrl;
    data['room_description'] = roomDescription;
    data['rooms_available'] = roomsAvailable;
    data['accommodation_id'] = accommodationId;
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    if (pricingId != null) {
      data['pricing_id'] = pricingId!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['check_in_date'] = checkInDate;
    data['check_out_date'] = checkOutDate;
    data['_id'] = sId;
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
        pricing!.add(Pricing.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['accommodation_id'] = accommodationId;
    data['room_id'] = roomId;
    if (pricing != null) {
      data['pricing'] = pricing!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['price_type'] = priceType;
    data['_id'] = sId;
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
        pricing!.add(Pricing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['accommodation_id'] = accommodationId;
    data['room_id'] = roomId;
    if (pricing != null) {
      data['pricing'] = pricing!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['room_types'] = roomTypes;
    data['amenities'] = amenities;
    data['location'] = location;
    data['category'] = category;
    data['min_price'] = minPrice;
    data['max_price'] = maxPrice;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    return data;
  }
}

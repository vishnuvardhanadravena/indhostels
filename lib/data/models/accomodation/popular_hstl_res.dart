class AccomdationPoppularHstl {
  bool? success;
  int? statuscode;
  int? page;
  List<PopularHstlData>? data;
  int? totalPages;

  AccomdationPoppularHstl({
    this.success,
    this.statuscode,
    this.page,
    this.data,
    this.totalPages,
  });

  AccomdationPoppularHstl.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    page = json['page'];
    if (json['data'] != null) {
      data = <PopularHstlData>[];
      json['data'].forEach((v) {
        data!.add( PopularHstlData.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statuscode'] = statuscode;
    data['page'] = page;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = totalPages;
    return data;
  }
}

class PopularHstlData {
  String? sId;
  String? propertyName;
  String? propertyDescription;
  String? propertyType;
  String? categoryName;
  Location? location;
  List<String>? amenities;
  List<String>? roomTypes;
  HostDetails? hostDetails;
  List<String>? imagesUrl;
  bool? tax;
  bool? isverified;
  int? bookingcount;
  String? isbestfor;
  List<String>? nearby;
  String? vendorId;
  List<PricingData>? pricingData;
  int? totalRatings;
  double? averageRating;
  String? checkOutTime;
  int? taxAmount;
  bool? dealOfTheDay;
  int? dealOfferPercent;
  // int? bookingcount;
  String? reasonfornotverified;

  PopularHstlData({
    this.sId,
    this.propertyName,
    this.propertyDescription,
    this.propertyType,
    this.categoryName,
    this.location,
    this.amenities,
    this.roomTypes,
    this.hostDetails,
    this.imagesUrl,
    this.tax,
    this.isverified,
    this.bookingcount,
    this.isbestfor,
    this.nearby,
    this.vendorId,
    this.pricingData,
    this.totalRatings,
    this.averageRating,
    this.checkOutTime,
    this.taxAmount,
    this.dealOfTheDay,
    this.dealOfferPercent,
    // this.bookingcount,
    this.reasonfornotverified,
  });

  PopularHstlData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    propertyName = json['property_name'];
    propertyDescription = json['property_description'];
    propertyType = json['property_type'];
    categoryName = json['category_name'];
    location = json['location'] != null
        ?  Location.fromJson(json['location'])
        : null;
    amenities = json['amenities'].cast<String>();
    roomTypes = json['room_types'].cast<String>();
    hostDetails = json['host_details'] != null
        ? HostDetails.fromJson(json['host_details'])
        : null;
    imagesUrl = json['images_url'].cast<String>();
    tax = json['tax'];
    isverified = json['isverified'];
    bookingcount = json['bookingcount'];
    isbestfor = json['isbestfor'];
    nearby = json['nearby'].cast<String>();
    vendorId = json['vendor_id'];
    if (json['pricingData'] != null) {
      pricingData = <PricingData>[];
      json['pricingData'].forEach((v) {
        pricingData!.add(PricingData.fromJson(v));
      });
    }
    totalRatings = json['totalRatings'];
    averageRating = (json['averageRating'] as num?)?.toDouble();
    checkOutTime = json['check_out_time'];
    taxAmount = json['tax_amount'];
    dealOfTheDay = json['deal_of_the_day'];
    dealOfferPercent = json['deal_offer_percent'];
    bookingcount = json[' bookingcount'];
    reasonfornotverified = json['reasonfornotverified'];
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
    if (hostDetails != null) {
      data['host_details'] = hostDetails!.toJson();
    }
    data['images_url'] = imagesUrl;
    data['tax'] = tax;
    data['isverified'] = isverified;
    data['bookingcount'] = bookingcount;
    data['isbestfor'] = isbestfor;
    data['nearby'] = nearby;
    data['vendor_id'] = vendorId;
    if (pricingData != null) {
      data['pricingData'] = pricingData!.map((v) => v.toJson()).toList();
    }
    data['totalRatings'] = totalRatings;
    data['averageRating'] = averageRating;
    data['check_out_time'] = checkOutTime;
    data['tax_amount'] = taxAmount;
    data['deal_of_the_day'] = dealOfTheDay;
    data['deal_offer_percent'] = dealOfferPercent;
    data[' bookingcount'] = bookingcount;
    data['reasonfornotverified'] = reasonfornotverified;
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

class PricingData {
  String? sId;
  String? accommodationId;
  String? roomId;
  List<Pricing>? pricing;

  PricingData({this.sId, this.accommodationId, this.roomId, this.pricing});

  PricingData.fromJson(Map<String, dynamic> json) {
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

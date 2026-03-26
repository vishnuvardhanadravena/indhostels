class UserLikedAcommodations {
  bool? success;
  int? statuscode;
  String? message;
  List<LIkedAcommodations>? data;
  UserLikedAcommodations({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  UserLikedAcommodations.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LIkedAcommodations>[];
      json['data'].forEach((v) {
        data!.add(LIkedAcommodations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statuscode'] = statuscode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LIkedAcommodations {
  String? sId;
  String? propertyName;
  String? propertyDescription;
  String? propertyType;
  String? categoryName;
  Location? location;
  List<String>? imagesUrl;
  bool? isverified;
  int? bookingcount;
  String? checkOutTime;
  HostDetails? hostDetails;
  bool? dealOfTheDay;
  int? dealOfferPercent;
  double? averageRating;
  int? totalReviews;
  List<PricingData>? pricingData;

  LIkedAcommodations({
    this.sId,
    this.propertyName,
    this.propertyDescription,
    this.propertyType,
    this.categoryName,
    this.location,
    this.imagesUrl,
    this.isverified,
    this.bookingcount,
    this.checkOutTime,
    this.hostDetails,
    this.dealOfTheDay,
    this.dealOfferPercent,
    this.averageRating,
    this.totalReviews,
    this.pricingData,
  });

  LIkedAcommodations.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    propertyName = json['property_name'];
    propertyDescription = json['property_description'];
    propertyType = json['property_type'];
    categoryName = json['category_name'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    imagesUrl = json['images_url'].cast<String>();
    isverified = json['isverified'];
    bookingcount = json[' bookingcount'];
    checkOutTime = json['check_out_time'];
    hostDetails = json['host_details'] != null
        ? HostDetails.fromJson(json['host_details'])
        : null;
    dealOfTheDay = json['deal_of_the_day'];
    dealOfferPercent = json['deal_offer_percent'];
    averageRating = json['averageRating'];
    totalReviews = json['totalReviews'];
    if (json['pricingData'] != null) {
      pricingData = <PricingData>[];
      json['pricingData'].forEach((v) {
        pricingData!.add(PricingData.fromJson(v));
      });
    }
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
    data['images_url'] = imagesUrl;
    data['isverified'] = isverified;
    data[' bookingcount'] = bookingcount;
    data['check_out_time'] = checkOutTime;
    if (hostDetails != null) {
      data['host_details'] = hostDetails!.toJson();
    }
    data['deal_of_the_day'] = dealOfTheDay;
    data['deal_offer_percent'] = dealOfferPercent;
    data['averageRating'] = averageRating;
    data['totalReviews'] = totalReviews;
    if (pricingData != null) {
      data['pricingData'] = pricingData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  String? city;
  String? area;
  String? address;

  Location({this.city, this.area, this.address});

  Location.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    area = json['area'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['area'] = area;
    data['address'] = address;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['host_name'] = hostName;
    data['host_contact'] = hostContact;
    return data;
  }
}

class PricingData {
  String? sId;
  String? accommodationId;
  String? roomId;
  List<Pricing>? pricing;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PricingData({
    this.sId,
    this.accommodationId,
    this.roomId,
    this.pricing,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

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

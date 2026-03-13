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
        data!.add(new LIkedAcommodations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statuscode'] = this.statuscode;
    data['message'] = this.message;
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
        ? new Location.fromJson(json['location'])
        : null;
    imagesUrl = json['images_url'].cast<String>();
    isverified = json['isverified'];
    bookingcount = json[' bookingcount'];
    checkOutTime = json['check_out_time'];
    hostDetails = json['host_details'] != null
        ? new HostDetails.fromJson(json['host_details'])
        : null;
    dealOfTheDay = json['deal_of_the_day'];
    dealOfferPercent = json['deal_offer_percent'];
    averageRating = json['averageRating'];
    totalReviews = json['totalReviews'];
    if (json['pricingData'] != null) {
      pricingData = <PricingData>[];
      json['pricingData'].forEach((v) {
        pricingData!.add(new PricingData.fromJson(v));
      });
    }
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
    data['images_url'] = this.imagesUrl;
    data['isverified'] = this.isverified;
    data[' bookingcount'] = this.bookingcount;
    data['check_out_time'] = this.checkOutTime;
    if (this.hostDetails != null) {
      data['host_details'] = this.hostDetails!.toJson();
    }
    data['deal_of_the_day'] = this.dealOfTheDay;
    data['deal_offer_percent'] = this.dealOfferPercent;
    data['averageRating'] = this.averageRating;
    data['totalReviews'] = this.totalReviews;
    if (this.pricingData != null) {
      data['pricingData'] = this.pricingData!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['area'] = this.area;
    data['address'] = this.address;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['host_name'] = this.hostName;
    data['host_contact'] = this.hostContact;
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

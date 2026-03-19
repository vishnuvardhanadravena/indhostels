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
        data!.add(new PopularHstlData.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statuscode'] = this.statuscode;
    data['page'] = this.page;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
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
        ? new Location.fromJson(json['location'])
        : null;
    amenities = json['amenities'].cast<String>();
    roomTypes = json['room_types'].cast<String>();
    hostDetails = json['host_details'] != null
        ? new HostDetails.fromJson(json['host_details'])
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
        pricingData!.add(new PricingData.fromJson(v));
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
    if (this.hostDetails != null) {
      data['host_details'] = this.hostDetails!.toJson();
    }
    data['images_url'] = this.imagesUrl;
    data['tax'] = this.tax;
    data['isverified'] = this.isverified;
    data['bookingcount'] = this.bookingcount;
    data['isbestfor'] = this.isbestfor;
    data['nearby'] = this.nearby;
    data['vendor_id'] = this.vendorId;
    if (this.pricingData != null) {
      data['pricingData'] = this.pricingData!.map((v) => v.toJson()).toList();
    }
    data['totalRatings'] = this.totalRatings;
    data['averageRating'] = this.averageRating;
    data['check_out_time'] = this.checkOutTime;
    data['tax_amount'] = this.taxAmount;
    data['deal_of_the_day'] = this.dealOfTheDay;
    data['deal_offer_percent'] = this.dealOfferPercent;
    data[' bookingcount'] = this.bookingcount;
    data['reasonfornotverified'] = this.reasonfornotverified;
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

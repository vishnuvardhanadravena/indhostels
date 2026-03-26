class RecentViewsRes {
  bool? success;
  int? statuscode;
  String? message;
  List<Accommodationdata>? accommodationdata;

  RecentViewsRes(
      {this.success, this.statuscode, this.message, this.accommodationdata});

  RecentViewsRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    message = json['message'];
    if (json['accommodationdata'] != null) {
      accommodationdata = <Accommodationdata>[];
      json['accommodationdata'].forEach((v) {
        accommodationdata!.add(Accommodationdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statuscode'] = statuscode;
    data['message'] = message;
    if (accommodationdata != null) {
      data['accommodationdata'] =
          accommodationdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Accommodationdata {
  Location? location;
  HostDetails? hostDetails;
  bool? dealOfTheDay;
  int? dealOfferPercent;
  String? sId;
  String? propertyName;
  String? propertyDescription;
  String? propertyType;
  String? categoryName;
  String? checkOutTime;
  List<String>? imagesUrl;
  List<PricingIds>? pricingIds;
  bool? isverified;

  Accommodationdata(
      {this.location,
      this.hostDetails,
      this.dealOfTheDay,
      this.dealOfferPercent,
      this.sId,
      this.propertyName,
      this.propertyDescription,
      this.propertyType,
      this.categoryName,
      this.checkOutTime,
      this.imagesUrl,
      this.pricingIds,
      this.isverified});

  Accommodationdata.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    hostDetails = json['host_details'] != null
        ? HostDetails.fromJson(json['host_details'])
        : null;
    dealOfTheDay = json['deal_of_the_day'];
    dealOfferPercent = json['deal_offer_percent'];
    sId = json['_id'];
    propertyName = json['property_name'];
    propertyDescription = json['property_description'];
    propertyType = json['property_type'];
    categoryName = json['category_name'];
    checkOutTime = json['check_out_time'];
    imagesUrl = json['images_url'].cast<String>();
    if (json['pricing_ids'] != null) {
      pricingIds = <PricingIds>[];
      json['pricing_ids'].forEach((v) {
        pricingIds!.add(PricingIds.fromJson(v));
      });
    }
    isverified = json['isverified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (hostDetails != null) {
      data['host_details'] = hostDetails!.toJson();
    }
    data['deal_of_the_day'] = dealOfTheDay;
    data['deal_offer_percent'] = dealOfferPercent;
    data['_id'] = sId;
    data['property_name'] = propertyName;
    data['property_description'] = propertyDescription;
    data['property_type'] = propertyType;
    data['category_name'] = categoryName;
    data['check_out_time'] = checkOutTime;
    data['images_url'] = imagesUrl;
    if (pricingIds != null) {
      data['pricing_ids'] = pricingIds!.map((v) => v.toJson()).toList();
    }
    data['isverified'] = isverified;
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

class PricingIds {
  String? sId;
  List<Pricing>? pricing;

  PricingIds({this.sId, this.pricing});

  PricingIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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

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
        accommodationdata!.add(new Accommodationdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statuscode'] = this.statuscode;
    data['message'] = this.message;
    if (this.accommodationdata != null) {
      data['accommodationdata'] =
          this.accommodationdata!.map((v) => v.toJson()).toList();
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
        ? new Location.fromJson(json['location'])
        : null;
    hostDetails = json['host_details'] != null
        ? new HostDetails.fromJson(json['host_details'])
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
        pricingIds!.add(new PricingIds.fromJson(v));
      });
    }
    isverified = json['isverified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.hostDetails != null) {
      data['host_details'] = this.hostDetails!.toJson();
    }
    data['deal_of_the_day'] = this.dealOfTheDay;
    data['deal_offer_percent'] = this.dealOfferPercent;
    data['_id'] = this.sId;
    data['property_name'] = this.propertyName;
    data['property_description'] = this.propertyDescription;
    data['property_type'] = this.propertyType;
    data['category_name'] = this.categoryName;
    data['check_out_time'] = this.checkOutTime;
    data['images_url'] = this.imagesUrl;
    if (this.pricingIds != null) {
      data['pricing_ids'] = this.pricingIds!.map((v) => v.toJson()).toList();
    }
    data['isverified'] = this.isverified;
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

class PricingIds {
  String? sId;
  List<Pricing>? pricing;

  PricingIds({this.sId, this.pricing});

  PricingIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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

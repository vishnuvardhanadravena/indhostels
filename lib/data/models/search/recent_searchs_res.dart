class RecentSearchesRes {
  bool? success;
  int? statuscode;
  String? message;
  Searches? data;

  RecentSearchesRes({this.success, this.statuscode, this.message, this.data});

  RecentSearchesRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    message = json['message'];
    data = json['data'] != null ? Searches.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statuscode'] = statuscode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Searches {
  String? sId;
  List<String>? searchtext;
  List<Locationsearch>? locationsearch;

  Searches({this.sId, this.searchtext, this.locationsearch});

  Searches.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    searchtext = json['searchtext'].cast<String>();
    if (json['locationsearch'] != null) {
      locationsearch = <Locationsearch>[];
      json['locationsearch'].forEach((v) {
        locationsearch!.add(Locationsearch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['searchtext'] = searchtext;
    if (locationsearch != null) {
      data['locationsearch'] = locationsearch!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Locationsearch {
  String? location;
  String? checkin;
  String? checkout;
  String? sId;

  Locationsearch({this.location, this.checkin, this.checkout, this.sId});

  Locationsearch.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location;
    data['checkin'] = checkin;
    data['checkout'] = checkout;
    data['_id'] = sId;
    return data;
  }
}

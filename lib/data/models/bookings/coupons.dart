class GetCouponsResponce {
  bool? success;
  int? statuscode;
  String? message;
  List<Coupons>? data;
  int? totalcoupons;

  GetCouponsResponce({
    this.success,
    this.statuscode,
    this.message,
    this.data,
    this.totalcoupons,
  });

  GetCouponsResponce.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Coupons>[];
      json['data'].forEach((v) {
        data!.add(new Coupons.fromJson(v));
      });
    }
    totalcoupons = json['totalcoupons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statuscode'] = this.statuscode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalcoupons'] = this.totalcoupons;
    return data;
  }
}

class Coupons {
  String? sId;
  String? couponCode;
  String? discounttype;
  int? discountpercentage;
  int? discountamount;
  int? minimumamount;
  String? status;
  List<String>? targetedAccommodations;
  List<String>? usedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? expireDate;
  String? id;

  Coupons({
    this.sId,
    this.couponCode,
    this.discounttype,
    this.discountpercentage,
    this.discountamount,
    this.minimumamount,
    this.status,
    this.targetedAccommodations,
    this.usedBy,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.expireDate,
    this.id,
  });

  Coupons.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    couponCode = json['couponCode'];
    discounttype = json['discounttype'];
    discountpercentage = json['discountpercentage'];
    discountamount = json['discountamount'];
    minimumamount = json['minimumamount'];
    status = json['status'];
    targetedAccommodations = json['targetedAccommodations'].cast<String>();
    usedBy = json['usedBy'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    expireDate = json['expireDate'];
    id = json['Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['couponCode'] = this.couponCode;
    data['discounttype'] = this.discounttype;
    data['discountpercentage'] = this.discountpercentage;
    data['discountamount'] = this.discountamount;
    data['minimumamount'] = this.minimumamount;
    data['status'] = this.status;
    data['targetedAccommodations'] = this.targetedAccommodations;
    data['usedBy'] = this.usedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['expireDate'] = this.expireDate;
    data['Id'] = this.id;
    return data;
  }
}

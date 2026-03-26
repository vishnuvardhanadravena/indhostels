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
        data!.add(Coupons.fromJson(v));
      });
    }
    totalcoupons = json['totalcoupons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statuscode'] = statuscode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalcoupons'] = totalcoupons;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['couponCode'] = couponCode;
    data['discounttype'] = discounttype;
    data['discountpercentage'] = discountpercentage;
    data['discountamount'] = discountamount;
    data['minimumamount'] = minimumamount;
    data['status'] = status;
    data['targetedAccommodations'] = targetedAccommodations;
    data['usedBy'] = usedBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['expireDate'] = expireDate;
    data['Id'] = id;
    return data;
  }
}

class BookingDetailResponse {
  final bool success;
  final int statusCode;
  final BookingDetail data;
  final PaymentHistory paymentHistory;

  BookingDetailResponse({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.paymentHistory,
  });

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailResponse(
      success: json['success'] ?? false,
      statusCode: json['statuscode'] ?? 200,
      data: BookingDetail.fromJson(json['data']),
      paymentHistory: PaymentHistory.fromJson(json['paymenthistory']),
    );
  }
}

class BookingDetail {
  final String id;
  final BookingUser user;
  final Accommodation accommodation;
  final Room room;
  final String priceType;
  final double roomPrice;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String days;
  final int guests;
  final String roomType;
  final GuestDetails guestDetails;
  final String status;
  final DateTime bookedAt;
  final double bookingAmount;
  final String couponCode;
  final double discountAmount;
  final String vendorId;
  final String bookingId;
  final PaymentId payment;

  BookingDetail({
    required this.id,
    required this.user,
    required this.accommodation,
    required this.room,
    required this.priceType,
    required this.roomPrice,
    required this.checkInDate,
    required this.checkOutDate,
    required this.days,
    required this.guests,
    required this.roomType,
    required this.guestDetails,
    required this.status,
    required this.bookedAt,
    required this.bookingAmount,
    required this.couponCode,
    required this.discountAmount,
    required this.vendorId,
    required this.bookingId,
    required this.payment,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      id: json['_id'] ?? '',
      user: BookingUser.fromJson(json['userId'] ?? {}),
      accommodation: Accommodation.fromJson(json['accommodationId'] ?? {}),
      room: Room.fromJson(json['room_id'] ?? {}),
      priceType: json['price_type'] ?? '',
      roomPrice: (json['room_price'] ?? 0).toDouble(),
      checkInDate: DateTime.parse(json['check_in_date']),
      checkOutDate: DateTime.parse(json['check_out_date']),
      days: json['days'] ?? '',
      guests: json['guests'] ?? 0,
      roomType: json['roomtype'] ?? '',
      guestDetails: GuestDetails.fromJson(json['guestdetails'] ?? {}),
      status: json['status'] ?? '',
      bookedAt: DateTime.parse(json['bookedAt']),
      bookingAmount: (json['bookingamount'] ?? 0).toDouble(),
      couponCode: json['couponCode'] ?? '',
      discountAmount: (json['discountamount'] ?? 0).toDouble(),
      vendorId: json['vendorId'] ?? '',
      bookingId: json['bookingId'] ?? '',
      payment: PaymentId.fromJson(json['paymentid'] ?? {}),
    );
  }

  // Helpers
  String get shortBookingId => bookingId.replaceFirst('BOKindhostels', '');
  String get formattedRoomPrice => '₹${roomPrice.toStringAsFixed(0)}';
  String get primaryImage =>
      accommodation.imagesUrl.isNotEmpty ? accommodation.imagesUrl.first : '';
}

class BookingUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String status;
  final String profileUrl;
  final String gender;
  final UserLocation location;

  BookingUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.status,
    required this.profileUrl,
    required this.gender,
    required this.location,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      id: json['_id'] ?? '',
      fullName: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '',
      status: json['status'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      gender: json['gender'] ?? '',
      location: UserLocation.fromJson(json['location'] ?? {}),
    );
  }
}

class UserLocation {
  final String city;
  final String state;

  UserLocation({required this.city, required this.state});

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      UserLocation(city: json['city'] ?? '', state: json['state'] ?? '');
}

class Accommodation {
  final String id;
  final String propertyName;
  final String propertyDescription;
  final String propertyType;
  final String categoryName;
  final AccommodationLocation location;
  final List<String> amenities;
  final List<String> roomTypes;
  final String checkInTime;
  final String checkOutTime;
  final String cancellationPolicy;
  final String hostContact;
  final List<String> imagesUrl;
  final bool hasTax;
  final double taxAmount;
  final bool isVerified;
  final HostDetails hostDetails;
  final String isBestFor;
  final List<String> nearby;
  final bool dealOfTheDay;
  final int dealOfferPercent;
  final double? rating;

  Accommodation({
    required this.id,
    required this.propertyName,
    required this.propertyDescription,
    required this.propertyType,
    required this.categoryName,
    required this.location,
    required this.amenities,
    required this.roomTypes,
    required this.checkInTime,
    required this.checkOutTime,
    required this.cancellationPolicy,
    required this.hostContact,
    required this.imagesUrl,
    required this.hasTax,
    required this.taxAmount,
    required this.isVerified,
    required this.hostDetails,
    required this.isBestFor,
    required this.nearby,
    required this.dealOfTheDay,
    required this.dealOfferPercent,
    this.rating,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['_id'] ?? '',
      propertyName: json['property_name'] ?? '',
      propertyDescription: json['property_description'] ?? '',
      propertyType: json['property_type'] ?? '',
      categoryName: json['category_name'] ?? '',
      location: AccommodationLocation.fromJson(json['location'] ?? {}),
      amenities: List<String>.from(json['amenities'] ?? []),
      roomTypes: List<String>.from(json['room_types'] ?? []),
      checkInTime: json['check_in_time'] ?? '',
      checkOutTime: json['check_out_time'] ?? '',
      cancellationPolicy: json['cancellation_policy'] ?? '',
      hostContact: json['host_contact'] ?? '',
      imagesUrl: List<String>.from(json['images_url'] ?? []),
      hasTax: json['tax'] ?? false,
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      isVerified: json['isverified'] ?? false,
      hostDetails: HostDetails.fromJson(json['host_details'] ?? {}),
      isBestFor: json['isbestfor'] ?? '',
      nearby: List<String>.from(json['nearby'] ?? []),
      dealOfTheDay: json['deal_of_the_day'] ?? false,
      dealOfferPercent: json['deal_offer_percent'] ?? 0,
      rating: json['rating'] != null ? (json['rating']).toDouble() : null,
    );
  }
}

class AccommodationLocation {
  final String city;
  final String area;
  final String address;
  final String? locationUrl;

  AccommodationLocation({
    required this.city,
    required this.area,
    required this.address,
    this.locationUrl,
  });

  factory AccommodationLocation.fromJson(Map<String, dynamic> json) =>
      AccommodationLocation(
        city: json['city'] ?? '',
        area: json['area'] ?? '',
        address: json['address'] ?? '',
        locationUrl: json['locationUrl'],
      );

  String get displayArea =>
      '${area.isNotEmpty ? area[0].toUpperCase() + area.substring(1) : ''}, ${city.isNotEmpty ? city[0].toUpperCase() + city.substring(1) : ''}';

  String get fullAddress => address.isNotEmpty ? address : '$area, $city';
}

class HostDetails {
  final String hostName;
  final String hostContact;

  HostDetails({required this.hostName, required this.hostContact});

  factory HostDetails.fromJson(Map<String, dynamic> json) => HostDetails(
    hostName: json['host_name'] ?? '',
    hostContact: json['host_contact'] ?? '',
  );
}

class Room {
  final String id;
  final String roomType;
  final List<String> amenities;
  final List<String> imagesUrl;
  final String description;
  final int roomsAvailable;

  Room({
    required this.id,
    required this.roomType,
    required this.amenities,
    required this.imagesUrl,
    required this.description,
    required this.roomsAvailable,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'] ?? '',
      roomType: json['room_type'] ?? '',
      amenities: List<String>.from(json['room_amenities'] ?? []),
      imagesUrl: List<String>.from(json['room_images_url'] ?? []),
      description: json['room_description'] ?? '',
      roomsAvailable: json['rooms_available'] ?? 0,
    );
  }
}

class GuestDetails {
  final String fullName;
  final String mobileNumber;
  final String emailAddress;
  final StayInfo stayInfo;
  final bool agreed;
  final int noOfAdults;
  final int noOfChildrens;
  final String gender;

  GuestDetails({
    required this.fullName,
    required this.mobileNumber,
    required this.emailAddress,
    required this.stayInfo,
    required this.agreed,
    required this.noOfAdults,
    required this.noOfChildrens,
    required this.gender,
  });

  factory GuestDetails.fromJson(Map<String, dynamic> json) {
    return GuestDetails(
      fullName: json['fullname'] ?? '',
      mobileNumber: json['mobilenumber']?.toString() ?? '',
      emailAddress: json['emailAddress'] ?? '',
      stayInfo: StayInfo.fromJson(json['stayinfo'] ?? {}),
      agreed: json['agreed'] ?? false,
      noOfAdults: json['noofadults'] ?? 0,
      noOfChildrens: json['noofchildrens'] ?? 0,
      gender: json['gender'] ?? '',
    );
  }
}

class StayInfo {
  final DateTime checkIn;
  final DateTime checkOut;
  final String roomType;

  StayInfo({
    required this.checkIn,
    required this.checkOut,
    required this.roomType,
  });

  factory StayInfo.fromJson(Map<String, dynamic> json) => StayInfo(
    checkIn: DateTime.parse(json['check_in']),
    checkOut: DateTime.parse(json['check_out']),
    roomType: json['roomtype'] ?? '',
  );
}

class PaymentId {
  final String id;
  final String bookingId;
  final double bookingAmount;
  final String paymentMode;
  final String paymentStatus;
  final RazorpayInfo paymentInfo;
  final String invoice;
  final double tax;
  final DateTime createdAt;

  PaymentId({
    required this.id,
    required this.bookingId,
    required this.bookingAmount,
    required this.paymentMode,
    required this.paymentStatus,
    required this.paymentInfo,
    required this.invoice,
    required this.tax,
    required this.createdAt,
  });

  factory PaymentId.fromJson(Map<String, dynamic> json) {
    return PaymentId(
      id: json['_id'] ?? '',
      bookingId: json['BookingId'] ?? '',
      bookingAmount: (json['bookingamount'] ?? 0).toDouble(),
      paymentMode: json['payment_mode'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentInfo: RazorpayInfo.fromJson(json['paymentInfo'] ?? {}),
      invoice: json['invoice'] ?? '',
      tax: (json['tax'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  bool get isPaid => paymentStatus == 'paid';
  bool get isOnline => paymentMode == 'online';
}

class RazorpayInfo {
  final String paymentId;
  final String orderId;
  final String signature;

  RazorpayInfo({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });

  factory RazorpayInfo.fromJson(Map<String, dynamic> json) => RazorpayInfo(
    paymentId: json['razorpay_payment_id'] ?? '',
    orderId: json['razorpay_order_id'] ?? '',
    signature: json['razorpay_signature'] ?? '',
  );
}

class PaymentHistory {
  final String id;
  final int amount;
  final String currency;
  final String status;
  final String orderId;
  final String method;
  final int amountRefunded;
  final String? refundStatus;
  final bool captured;
  final String description;
  final String? vpa;
  final String email;
  final String contact;
  final int fee;
  final int tax;
  final AcquirerData acquirerData;
  final int createdAt;
  final UpiInfo? upi;

  PaymentHistory({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.orderId,
    required this.method,
    required this.amountRefunded,
    this.refundStatus,
    required this.captured,
    required this.description,
    this.vpa,
    required this.email,
    required this.contact,
    required this.fee,
    required this.tax,
    required this.acquirerData,
    required this.createdAt,
    this.upi,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'INR',
      status: json['status'] ?? '',
      orderId: json['order_id'] ?? '',
      method: json['method'] ?? '',
      amountRefunded: json['amount_refunded'] ?? 0,
      refundStatus: json['refund_status'],
      captured: json['captured'] ?? false,
      description: json['description'] ?? '',
      vpa: json['vpa'],
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
      fee: json['fee'] ?? 0,
      tax: json['tax'] ?? 0,
      acquirerData: AcquirerData.fromJson(json['acquirer_data'] ?? {}),
      createdAt: json['created_at'] ?? 0,
      upi: json['upi'] != null ? UpiInfo.fromJson(json['upi']) : null,
    );
  }

  double get amountInRupees => amount / 100;
  double get feeInRupees => fee / 100;
}

class AcquirerData {
  final String rrn;
  final String upiTransactionId;

  AcquirerData({required this.rrn, required this.upiTransactionId});

  factory AcquirerData.fromJson(Map<String, dynamic> json) => AcquirerData(
    rrn: json['rrn'] ?? '',
    upiTransactionId: json['upi_transaction_id'] ?? '',
  );
}

class UpiInfo {
  final String vpa;
  final String flow;

  UpiInfo({required this.vpa, required this.flow});

  factory UpiInfo.fromJson(Map<String, dynamic> json) =>
      UpiInfo(vpa: json['vpa'] ?? '', flow: json['flow'] ?? '');
}

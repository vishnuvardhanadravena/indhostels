
import 'package:indhostels/pages/bookings/bookings.dart';

class PaymentModel {
  final String id;
  final double amount;
  final String mode; 
  final String status; 
  final String invoice;
  final double tax;
  final String? razorpayPaymentId;

  const PaymentModel({
    required this.id,
    required this.amount,
    required this.mode,
    required this.status,
    required this.invoice,
    required this.tax,
    this.razorpayPaymentId,
  });

  bool get isPaid => status == 'paid';
  bool get isOnline => mode == 'online';

  factory PaymentModel.fromJson(Map<String, dynamic> j) => PaymentModel(
    id: j['_id'] ?? '',
    amount: (j['bookingamount'] ?? 0).toDouble(),
    mode: j['payment_mode'] ?? '',
    status: j['payment_status'] ?? '',
    invoice: j['invoice'] ?? '',
    tax: (j['tax'] ?? 0).toDouble(),
    razorpayPaymentId: j['paymentInfo']?['razorpay_payment_id'],
  );
}

class PropertyLocation {
  final String city;
  final String area;
  final String address;
  final String? locationUrl;
  final double? lat;
  final double? lng;

  const PropertyLocation({
    required this.city,
    required this.area,
    required this.address,
    this.locationUrl,
    this.lat,
    this.lng,
  });

  String get displayArea => area.isNotEmpty ? area : city;
  String get fullAddress => '$address, ${city.toUpperCase()}';

  factory PropertyLocation.fromJson(Map<String, dynamic> j) => PropertyLocation(
    city: j['city'] ?? '',
    area: j['area'] ?? '',
    address: j['address'] ?? '',
    locationUrl: j['locationurl'],
    lat: j['lat']?.toDouble(),
    lng: j['lont']?.toDouble(),
  );
}

class RoomModel {
  final String id;
  final String roomType;
  final List<String> amenities;
  final List<String> imageUrls;
  final String description;
  final int roomsAvailable;

  const RoomModel({
    required this.id,
    required this.roomType,
    required this.amenities,
    required this.imageUrls,
    required this.description,
    required this.roomsAvailable,
  });

  factory RoomModel.fromJson(Map<String, dynamic> j) {
    final rawAmenities = j['room_amenities'] as List? ?? [];
    final List<String> amenities = rawAmenities
        .expand((e) => e.toString().split(',').map((s) => s.trim()))
        .where((s) => s.isNotEmpty)
        .toList();

    return RoomModel(
      id: j['_id'] ?? '',
      roomType: j['room_type'] ?? '',
      amenities: amenities,
      imageUrls: List<String>.from(j['room_images_url'] ?? []),
      description: j['room_description'] ?? '',
      roomsAvailable: j['rooms_available'] ?? 0,
    );
  }
}

class AccommodationModel {
  final String id;
  final String propertyName;
  final String propertyType;
  final String categoryName;
  final PropertyLocation location;
  final List<String> amenities;
  final List<String> imageUrls;
  final String cancellationPolicy;
  final String checkInTime;
  final String checkOutTime;
  final String hostName;
  final String hostContact;
  final bool isVerified;
  final bool hasTax;
  final double taxAmount;

  const AccommodationModel({
    required this.id,
    required this.propertyName,
    required this.propertyType,
    required this.categoryName,
    required this.location,
    required this.amenities,
    required this.imageUrls,
    required this.cancellationPolicy,
    required this.checkInTime,
    required this.checkOutTime,
    required this.hostName,
    required this.hostContact,
    required this.isVerified,
    required this.hasTax,
    required this.taxAmount,
  });

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';

  factory AccommodationModel.fromJson(Map<String, dynamic> j) =>
      AccommodationModel(
        id: j['_id'] ?? '',
        propertyName: j['property_name'] ?? '',
        propertyType: j['property_type'] ?? '',
        categoryName: j['category_name'] ?? '',
        location: PropertyLocation.fromJson(j['location'] ?? {}),
        amenities: List<String>.from(j['amenities'] ?? []),
        imageUrls: List<String>.from(j['images_url'] ?? []),
        cancellationPolicy: j['cancellation_policy'] ?? '',
        checkInTime: j['check_in_time'] ?? '',
        checkOutTime: j['check_out_time'] ?? '',
        hostName: j['host_details']?['host_name'] ?? '',
        hostContact:
            j['host_details']?['host_contact'] ?? j['host_contact'] ?? '',
        isVerified: j['isverified'] ?? false,
        hasTax: j['tax'] ?? false,
        taxAmount: (j['tax_amount'] ?? 0).toDouble(),
      );
}

class GuestDetails {
  final String fullname;
  final String email;
  final String mobile;
  final int adults;
  final int children;
  final String gender;

  const GuestDetails({
    required this.fullname,
    required this.email,
    required this.mobile,
    required this.adults,
    required this.children,
    required this.gender,
  });

  factory GuestDetails.fromJson(Map<String, dynamic> j) => GuestDetails(
    fullname: j['fullname'] ?? '',
    email: j['emailAddress'] ?? '',
    mobile: j['mobilenumber']?.toString() ?? '',
    adults: j['noofadults'] ?? 0,
    children: j['noofchildrens'] ?? 0,
    gender: j['gender'] ?? '',
  );
}

class BookingModel {
  final String id;
  final String bookingId;
  final AccommodationModel accommodation;
  final RoomModel room;
  final BookingStatus status;
  final String priceType; 
  final double roomPrice;
  final double bookingAmount;
  final DateTime checkIn;
  final DateTime checkOut;
  final String days;
  final int guests;
  final String roomType;
  final GuestDetails guestDetails;
  final PaymentModel payment;
  final DateTime bookedAt;
  final DateTime createdAt;
  final double discountAmount;
  final String couponCode;

  const BookingModel({
    required this.id,
    required this.bookingId,
    required this.accommodation,
    required this.room,
    required this.status,
    required this.priceType,
    required this.roomPrice,
    required this.bookingAmount,
    required this.checkIn,
    required this.checkOut,
    required this.days,
    required this.guests,
    required this.roomType,
    required this.guestDetails,
    required this.payment,
    required this.bookedAt,
    required this.createdAt,
    required this.discountAmount,
    required this.couponCode,
  });

  String get primaryImage => accommodation.primaryImage;
  String get propertyName => accommodation.propertyName;
  String get locationDisplay => accommodation.location.displayArea;
  String get formattedAmount => '₹${bookingAmount.toStringAsFixed(0)}';
  String get formattedRoomPrice => '₹${roomPrice.toStringAsFixed(0)}';

  factory BookingModel.fromJson(Map<String, dynamic> j) => BookingModel(
    id: j['_id'] ?? '',
    bookingId: j['bookingId'] ?? '',
    accommodation: AccommodationModel.fromJson(j['accommodationId'] ?? {}),
    room: RoomModel.fromJson(j['room_id'] ?? {}),
    status: BookingStatusX.fromString(j['status'] ?? ''),
    priceType: j['price_type'] ?? '',
    roomPrice: (j['room_price'] ?? 0).toDouble(),
    bookingAmount: (j['bookingamount'] ?? 0).toDouble(),
    checkIn: DateTime.tryParse(j['check_in_date'] ?? '') ?? DateTime.now(),
    checkOut: DateTime.tryParse(j['check_out_date'] ?? '') ?? DateTime.now(),
    days: j['days'] ?? '',
    guests: j['guests'] ?? 1,
    roomType: j['roomtype'] ?? '',
    guestDetails: GuestDetails.fromJson(j['guestdetails'] ?? {}),
    payment: PaymentModel.fromJson(j['paymentid'] ?? {}),
    bookedAt: DateTime.tryParse(j['bookedAt'] ?? '') ?? DateTime.now(),
    createdAt: DateTime.tryParse(j['createdAt'] ?? '') ?? DateTime.now(),
    discountAmount: (j['discountamount'] ?? 0).toDouble(),
    couponCode: j['couponCode'] ?? '',
  );

  static List<BookingModel> listFromJson(List json) =>
      json.map((e) => BookingModel.fromJson(e)).toList();
}

class BookingsResponse {
  final bool success;
  final List<BookingModel> data;
  final int totalPages;
  final int totalOrders;

  const BookingsResponse({
    required this.success,
    required this.data,
    required this.totalPages,
    required this.totalOrders,
  });

  factory BookingsResponse.fromJson(Map<String, dynamic> j) => BookingsResponse(
    success: j['success'] ?? false,
    data: BookingModel.listFromJson(j['data'] ?? []),
    totalPages: j['totalpages'] ?? 1,
    totalOrders: j['totalOrders'] ?? 0,
  );
}
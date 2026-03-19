
import 'package:indhostels/data/models/accomodation/accomodation_details_res.dart';

class RoomPricing {
  final String id;
  final double price;
  final String priceType;

  const RoomPricing({
    required this.id,
    required this.price,
    required this.priceType,
  });

  factory RoomPricing.fromJson(Map<String, dynamic> json) => RoomPricing(
    id: json['_id'] as String? ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    priceType: json['price_type'] as String? ?? 'per night',
  );
}

class RoomPricingId {
  final String id;
  final String accommodationId;
  final String roomId;
  final List<RoomPricing> pricing;

  const RoomPricingId({
    required this.id,
    required this.accommodationId,
    required this.roomId,
    required this.pricing,
  });

  factory RoomPricingId.fromJson(Map<String, dynamic> json) => RoomPricingId(
    id: json['_id'] as String? ?? '',
    accommodationId: json['accommodation_id'] as String? ?? '',
    roomId: json['room_id'] as String? ?? '',
    pricing: (json['pricing'] as List<dynamic>? ?? [])
        .map((e) => RoomPricing.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  /// Convenience: first price entry
  RoomPricing? get primaryPricing => pricing.isNotEmpty ? pricing.first : null;
}

class RoomBooking {
  final String id;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const RoomBooking({
    required this.id,
    required this.checkInDate,
    required this.checkOutDate,
  });

  factory RoomBooking.fromJson(Map<String, dynamic> json) => RoomBooking(
    id: json['_id'] as String? ?? '',
    checkInDate:
        DateTime.tryParse(json['check_in_date'] as String? ?? '') ??
        DateTime.now(),
    checkOutDate:
        DateTime.tryParse(json['check_out_date'] as String? ?? '') ??
        DateTime.now(),
  );
}

class RoomModel {
  final String id;
  final String roomType;
  final int bedsAvailable;
  final int noOfGuests;
  final int noOfChildrens;
  final List<String> roomAmenities;
  final List<String> roomImagesUrl;
  final String roomDescription;
  final int roomsAvailable;
  final String accommodationId;
  final List<RoomBooking> bookings;
  final RoomPricingId? pricingId;

  const RoomModel({
    required this.id,
    required this.roomType,
    required this.bedsAvailable,
    required this.noOfGuests,
    required this.noOfChildrens,
    required this.roomAmenities,
    required this.roomImagesUrl,
    required this.roomDescription,
    required this.roomsAvailable,
    required this.accommodationId,
    required this.bookings,
    this.pricingId,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    id: json['_id'] as String? ?? '',
    roomType: json['room_type'] as String? ?? '',
    bedsAvailable: (json['beds_available'] as num?)?.toInt() ?? 0,
    noOfGuests: (json['no_of_guests'] as num?)?.toInt() ?? 0,
    noOfChildrens: (json['no_of_childrens'] as num?)?.toInt() ?? 0,
    roomAmenities: (json['room_amenities'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
    roomImagesUrl: (json['room_images_url'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
    roomDescription: json['room_description'] as String? ?? '',
    roomsAvailable: (json['rooms_available'] as num?)?.toInt() ?? 0,
    accommodationId: json['accommodation_id'] as String? ?? '',
    bookings: (json['bookings'] as List<dynamic>? ?? [])
        .map((e) => RoomBooking.fromJson(e as Map<String, dynamic>))
        .toList(),
    pricingId: json['pricing_id'] != null
        ? RoomPricingId.fromJson(json['pricing_id'] as Map<String, dynamic>)
        : null,
  );
  factory RoomModel.fromRoomId(RoomId e) {
    return RoomModel(
      id: e.sId ?? '',
      roomType: e.roomType ?? '',
      bedsAvailable: e.bedsAvailable ?? 0,
      noOfGuests: e.noOfGuests ?? 0,
      noOfChildrens: e.noOfChildrens ?? 0,
      roomAmenities: e.roomAmenities ?? [],
      roomImagesUrl: e.roomImagesUrl ?? [],
      roomDescription: e.roomDescription ?? '',
      roomsAvailable: e.roomsAvailable ?? 0,
      accommodationId: e.accommodationId ?? '',
      bookings: (e.bookings ?? [])
          .map(
            (b) => RoomBooking(
              id: b.sId ?? '',
              checkInDate:
                  DateTime.tryParse(b.checkInDate ?? '') ?? DateTime.now(),
              checkOutDate:
                  DateTime.tryParse(b.checkOutDate ?? '') ?? DateTime.now(),
            ),
          )
          .toList(),
      pricingId: e.pricingId == null
          ? null
          : RoomPricingId(
              id: e.pricingId!.sId ?? '',
              accommodationId: e.pricingId!.accommodationId ?? '',
              roomId: e.pricingId!.roomId ?? '',
              pricing: (e.pricingId!.pricing ?? [])
                  .map(
                    (p) => RoomPricing(
                      id: p.sId ?? '',
                      price: (p.price ?? 0).toDouble(),
                      priceType: p.priceType ?? '',
                    ),
                  )
                  .toList(),
            ),
    );
  }

  List<String> get parsedAmenities {
    if (roomAmenities.isEmpty) return [];
    return roomAmenities;
  }

  String get roomTypeLabel {
    switch (roomType.toLowerCase()) {
      case 'threeshare':
        return '3-Share Room';
      case 'twoshare':
        return '2-Share Room';
      case 'single':
        return 'Single Room';
      case 'ac':
        return 'AC Room';
      default:
        return roomType
            .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}')
            .trim();
    }
  }

  String? get primaryImage =>
      roomImagesUrl.isNotEmpty ? roomImagesUrl.first : null;

  String get priceDisplay {
    final p = pricingId?.primaryPricing;
    if (p == null) return '—';
    return '₹${p.price.toStringAsFixed(0)} / ${p.priceType}';
  }

  String get priceAmount {
    final p = pricingId?.primaryPricing;
    if (p == null) return '—';
    return '₹${p.price.toStringAsFixed(0)}';
  }

  String get priceSuffix {
    final p = pricingId?.primaryPricing;
    if (p == null) return '';
    return '/ ${p.priceType}';
  }
}


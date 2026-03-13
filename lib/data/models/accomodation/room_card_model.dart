// ─── room_model.dart ──────────────────────────────────────────────────────────

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

class RoomStaticData {
  RoomStaticData._();

  static final List<RoomModel> rooms = _raw
      .map((json) => RoomModel.fromJson(json))
      .toList();

  static final List<RoomModel> empty = [];

  static final List<Map<String, dynamic>> _raw = [
    {
      "_id": "6942547b7d5cfecfb28bc75d",
      "room_type": "threeshare",
      "beds_available": 8,
      "no_of_guests": 3,
      "no_of_childrens": 0,
      "room_amenities": [
        "geyser,Tube light / LED light,Refrigerator,water purifier,Bed(single / bunker / cot)",
      ],
      "room_images_url": [
        "https://indhostels.s3.us-east-1.amazonaws.com/roomImages/1765954681110-3_rk_-for-rent.avif",
      ],
      "room_description":
          "Spacious 3-share room with a beautiful view and modern amenities for budget travellers.",
      "rooms_available": 3,
      "accommodation_id": "694250c577b9c513afb1bd85",
      "bookings": [
        {
          "check_in_date": "2026-02-28T00:00:00.000Z",
          "check_out_date": "2026-03-28T00:00:00.000Z",
          "_id": "69a133112eb7eadf5db03b9a",
        },
      ],
      "pricing_id": {
        "_id": "6942547b7d5cfecfb28bc761",
        "accommodation_id": "694250c577b9c513afb1bd85",
        "room_id": "6942547b7d5cfecfb28bc75d",
        "pricing": [
          {
            "price": 3000,
            "price_type": "per month",
            "_id": "6942547b7d5cfecfb28bc765",
          },
        ],
      },
    },

    // 2. AC Room
    {
      "_id": "6942547b7d5cfecfb28bc75e",
      "room_type": "ac",
      "beds_available": 14,
      "no_of_guests": 2,
      "no_of_childrens": 0,
      "room_amenities": ["AC,WiFi,TV,Attached Bathroom,Wardrobe,Desk"],
      "room_images_url": [
        "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800",
      ],
      "room_description":
          "This is the luxury AC room for staying with all top-tier amenities.",
      "rooms_available": 5,
      "accommodation_id": "694250c577b9c513afb1bd85",
      "bookings": [],
      "pricing_id": {
        "_id": "6942547b7d5cfecfb28bc762",
        "accommodation_id": "694250c577b9c513afb1bd85",
        "room_id": "6942547b7d5cfecfb28bc75e",
        "pricing": [
          {
            "price": 500,
            "price_type": "1 night",
            "_id": "6942547b7d5cfecfb28bc766",
          },
        ],
      },
    },

    // 3. Two-share
    {
      "_id": "6942547b7d5cfecfb28bc75f",
      "room_type": "twoshare",
      "beds_available": 6,
      "no_of_guests": 2,
      "no_of_childrens": 1,
      "room_amenities": ["WiFi,Fan,Attached Bathroom,Study Table,Locker"],
      "room_images_url": [
        "https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800",
      ],
      "room_description":
          "Comfortable 2-share room perfect for friends or work colleagues.",
      "rooms_available": 2,
      "accommodation_id": "694250c577b9c513afb1bd85",
      "bookings": [],
      "pricing_id": {
        "_id": "6942547b7d5cfecfb28bc763",
        "accommodation_id": "694250c577b9c513afb1bd85",
        "room_id": "6942547b7d5cfecfb28bc75f",
        "pricing": [
          {
            "price": 1500,
            "price_type": "per month",
            "_id": "6942547b7d5cfecfb28bc767",
          },
        ],
      },
    },

    // 4. Single room
    {
      "_id": "6942547b7d5cfecfb28bc760",
      "room_type": "single",
      "beds_available": 4,
      "no_of_guests": 1,
      "no_of_childrens": 0,
      "room_amenities": [
        "AC,WiFi,Private Bathroom,Mini Fridge,Wardrobe,Balcony",
      ],
      "room_images_url": [
        "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800",
      ],
      "room_description":
          "Private single room with all modern facilities for solo travellers.",
      "rooms_available": 1,
      "accommodation_id": "694250c577b9c513afb1bd85",
      "bookings": [],
      "pricing_id": {
        "_id": "6942547b7d5cfecfb28bc764",
        "accommodation_id": "694250c577b9c513afb1bd85",
        "room_id": "6942547b7d5cfecfb28bc760",
        "pricing": [
          {
            "price": 4500,
            "price_type": "per month",
            "_id": "6942547b7d5cfecfb28bc768",
          },
        ],
      },
    },

    // 5. Dormitory (6-share bunk)
    {
      "_id": "6942547b7d5cfecfb28bc771",
      "room_type": "dormitory",
      "beds_available": 20,
      "no_of_guests": 6,
      "no_of_childrens": 0,
      "room_amenities": [
        "WiFi,Fan,Common Bathroom,Locker,Bunk Bed,Reading Light",
      ],
      "room_images_url": [
        "https://images.unsplash.com/photo-1520277739336-7bf67edfa768?w=800",
      ],
      "room_description":
          "Budget-friendly 6-bed dormitory great for backpackers and solo explorers.",
      "rooms_available": 4,
      "accommodation_id": "694250c577b9c513afb1bd85",
      "bookings": [
        {
          "check_in_date": "2026-03-01T00:00:00.000Z",
          "check_out_date": "2026-03-10T00:00:00.000Z",
          "_id": "69b133112eb7eadf5db03b9b",
        },
      ],
      "pricing_id": {
        "_id": "6942547b7d5cfecfb28bc772",
        "accommodation_id": "694250c577b9c513afb1bd85",
        "room_id": "6942547b7d5cfecfb28bc771",
        "pricing": [
          {
            "price": 299,
            "price_type": "1 night",
            "_id": "6942547b7d5cfecfb28bc773",
          },
        ],
      },
    },

    // 6. Deluxe Suite
    {
      "_id": "6942547b7d5cfecfb28bc774",
      "room_type": "deluxe",
      "beds_available": 2,
      "no_of_guests": 2,
      "no_of_childrens": 1,
      "room_amenities": [
        "AC,WiFi,Smart TV,King Bed,Jacuzzi,Mini Bar,Room Service,Balcony",
      ],
      "room_images_url": [
        "https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800",
      ],
      "room_description":
          "Deluxe suite featuring a king bed, jacuzzi, and panoramic city views.",
      "rooms_available": 1,
      "accommodation_id": "694250c577b9c513afb1bd85",
      "bookings": [],
      "pricing_id": {
        "_id": "6942547b7d5cfecfb28bc775",
        "accommodation_id": "694250c577b9c513afb1bd85",
        "room_id": "6942547b7d5cfecfb28bc774",
        "pricing": [
          {
            "price": 2500,
            "price_type": "1 night",
            "_id": "6942547b7d5cfecfb28bc776",
          },
        ],
      },
    },

    // 7. Studio apartment
    {
      "_id": "6942547b7d5cfecfb28bc777",
      "room_type": "studio",
      "beds_available": 1,
      "no_of_guests": 2,
      "no_of_childrens": 0,
      "room_amenities": [
        "AC,WiFi,Kitchenette,Queen Bed,Washing Machine,Workspace",
      ],
      "room_images_url": [
        "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800",
      ],
      "room_description":
          "Self-contained studio with kitchenette — ideal for long-stay guests.",
      "rooms_available": 2,
      "accommodation_id": "694250c577b9c513afb1bd85",
      "bookings": [],
      "pricing_id": {
        "_id": "6942547b7d5cfecfb28bc778",
        "accommodation_id": "694250c577b9c513afb1bd85",
        "room_id": "6942547b7d5cfecfb28bc777",
        "pricing": [
          {
            "price": 8500,
            "price_type": "per month",
            "_id": "6942547b7d5cfecfb28bc779",
          },
        ],
      },
    },

    // 8. Economy Non-AC
    {
      "_id": "6942547b7d5cfecfb28bc780",
      "room_type": "economy",
      "beds_available": 10,
      "no_of_guests": 4,
      "no_of_childrens": 2,
      "room_amenities": ["Fan,Common Bathroom,WiFi,Bunk Beds,Storage Box"],
      "room_images_url": [
        "https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?w=800",
      ],
      "room_description":
          "No-frills economy room at the best price — clean, safe, and convenient.",
      "rooms_available": 6,
      "accommodation_id": "694250c577b9c513afb1bd85",
      "bookings": [],
      "pricing_id": {
        "_id": "6942547b7d5cfecfb28bc781",
        "accommodation_id": "694250c577b9c513afb1bd85",
        "room_id": "6942547b7d5cfecfb28bc780",
        "pricing": [
          {
            "price": 799,
            "price_type": "per month",
            "_id": "6942547b7d5cfecfb28bc782",
          },
        ],
      },
    },
  ];
}

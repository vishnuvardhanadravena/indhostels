
class WishlistItem {
  final String wishlistItemId;
  final String accommodationId;
  final AccommodationDetails? details;
  final DateTime addedOn;

  const WishlistItem({
    required this.wishlistItemId,
    required this.accommodationId,
    this.details,
    required this.addedOn,
  });

  factory WishlistItem.fromGetJson(Map<String, dynamic> json) {
    final acc = json['accommodationId'];
    final accMap =
        acc is Map ? Map<String, dynamic>.from(acc) : null;

    return WishlistItem(
      wishlistItemId: json['_id'] as String,
      accommodationId: accMap != null ? accMap['_id'] as String : acc as String,
      details: accMap != null ? AccommodationDetails.fromJson(accMap) : null,
      addedOn: DateTime.parse(json['AddedOn'] as String),
    );
  }

  factory WishlistItem.fromAddJson(Map<String, dynamic> json) {
    return WishlistItem(
      wishlistItemId: json['_id'] as String,
      accommodationId: json['accommodationId'] as String,
      addedOn: DateTime.parse(json['AddedOn'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'wishlistItemId': wishlistItemId,
        'accommodationId': accommodationId,
        'addedOn': addedOn.toIso8601String(),
        if (details != null) 'details': details!.toJson(),
      };

  factory WishlistItem.fromStorageJson(Map<String, dynamic> json) {
    return WishlistItem(
      wishlistItemId: json['wishlistItemId'] as String,
      accommodationId: json['accommodationId'] as String,
      addedOn: DateTime.parse(json['addedOn'] as String),
      details: json['details'] != null
          ? AccommodationDetails.fromJson(
              Map<String, dynamic>.from(json['details'] as Map),
            )
          : null,
    );
  }
}


class AccommodationDetails {
  final String id;
  final String propertyName;
  final String propertyType;
  final String categoryName;
  final List<String> imagesUrl;
  final LocationInfo location;
  final HostDetails hostDetails;
  final List<String> amenities;
  final List<String> roomTypes;
  final bool dealOfTheDay;
  final int dealOfferPercent;
  final bool isVerified;
  final List<PricingInfo> pricingIds;

  const AccommodationDetails({
    required this.id,
    required this.propertyName,
    required this.propertyType,
    required this.categoryName,
    required this.imagesUrl,
    required this.location,
    required this.hostDetails,
    required this.amenities,
    required this.roomTypes,
    required this.dealOfTheDay,
    required this.dealOfferPercent,
    required this.isVerified,
    required this.pricingIds,
  });

  factory AccommodationDetails.fromJson(Map<String, dynamic> json) {
    return AccommodationDetails(
      id: json['_id'] as String,
      propertyName: json['property_name'] as String? ?? '',
      propertyType: json['property_type'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      imagesUrl: List<String>.from(json['images_url'] as List? ?? []),
      location: LocationInfo.fromJson(
        Map<String, dynamic>.from(json['location'] as Map? ?? {}),
      ),
      hostDetails: HostDetails.fromJson(
        Map<String, dynamic>.from(json['host_details'] as Map? ?? {}),
      ),
      amenities: List<String>.from(json['amenities'] as List? ?? []),
      roomTypes: List<String>.from(json['room_types'] as List? ?? []),
      dealOfTheDay: json['deal_of_the_day'] as bool? ?? false,
      dealOfferPercent: json['deal_offer_percent'] as int? ?? 0,
      isVerified: json['isverified'] as bool? ?? false,
      pricingIds: (json['pricing_ids'] as List? ?? [])
          .map(
            (e) => PricingInfo.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'property_name': propertyName,
        'property_type': propertyType,
        'category_name': categoryName,
        'images_url': imagesUrl,
        'location': location.toJson(),
        'host_details': hostDetails.toJson(),
        'amenities': amenities,
        'room_types': roomTypes,
        'deal_of_the_day': dealOfTheDay,
        'deal_offer_percent': dealOfferPercent,
        'isverified': isVerified,
        'pricing_ids': pricingIds.map((e) => e.toJson()).toList(),
      };
}

class LocationInfo {
  final String city;
  final String area;
  final String address;
  final String locationUrl;

  const LocationInfo({
    required this.city,
    required this.area,
    required this.address,
    required this.locationUrl,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        city: json['city'] as String? ?? '',
        area: json['area'] as String? ?? '',
        address: json['address'] as String? ?? '',
        locationUrl: json['locationurl'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'city': city,
        'area': area,
        'address': address,
        'locationurl': locationUrl,
      };
}

class HostDetails {
  final String hostName;
  final String hostContact;

  const HostDetails({required this.hostName, required this.hostContact});

  factory HostDetails.fromJson(Map<String, dynamic> json) => HostDetails(
        hostName: json['host_name'] as String? ?? '',
        hostContact: json['host_contact'] as String? ?? '',
      );

  Map<String, dynamic> toJson() =>
      {'host_name': hostName, 'host_contact': hostContact};
}

class PricingInfo {
  final String id;
  final String accommodationId;
  final String roomId;
  final List<PriceEntry> pricing;

  const PricingInfo({
    required this.id,
    required this.accommodationId,
    required this.roomId,
    required this.pricing,
  });

  factory PricingInfo.fromJson(Map<String, dynamic> json) => PricingInfo(
        id: json['_id'] as String,
        accommodationId: json['accommodation_id'] as String? ?? '',
        roomId: json['room_id'] as String? ?? '',
        pricing: (json['pricing'] as List? ?? [])
            .map(
              (e) => PriceEntry.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'accommodation_id': accommodationId,
        'room_id': roomId,
        'pricing': pricing.map((e) => e.toJson()).toList(),
      };
}

class PriceEntry {
  final int price;
  final String priceType;

  const PriceEntry({required this.price, required this.priceType});

  factory PriceEntry.fromJson(Map<String, dynamic> json) => PriceEntry(
        price: json['price'] as int,
        priceType: json['price_type'] as String,
      );

  Map<String, dynamic> toJson() => {'price': price, 'price_type': priceType};
}
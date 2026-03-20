
class LocationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final LocationData data;

  const LocationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      success: json['success'] as bool,
      statusCode: json['statuscode'] as int,
      message: json['message'] as String,
      data: LocationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}


class LocationData {
  final List<LocationItem> locations;
  final List<StayType> stayTypes;
  final List<String> roomTypes;
  final List<String> amenities;
  final PriceRange? priceRange;

  const LocationData({
    required this.locations,
    required this.stayTypes,
    required this.roomTypes,
    required this.amenities,
    this.priceRange,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      locations: (json['locations'] as List<dynamic>)
          .map((e) => LocationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      stayTypes: (json['staytypes'] as List<dynamic>)
          .map((e) => StayType.fromJson(e as Map<String, dynamic>))
          .toList(),
      roomTypes: (json['roomtypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      amenities: (json['amenities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      priceRange: (json['maxprice'] as List<dynamic>).isNotEmpty
          ? PriceRange.fromJson(
              (json['maxprice'] as List<dynamic>).first as Map<String, dynamic>)
          : null,
    );
  }
}


class LocationItem {
  final String city;  
  final List<String> areas;

  const LocationItem({required this.city, required this.areas});

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      city: (json['_id'] as String).trim(),
      areas: (json['area'] as List<dynamic>)
          .map((a) => (a as String).trim())
          .toList(),
    );
  }
}


class StayType {
  final String id;
  final String stayType;

  const StayType({required this.id, required this.stayType});

  factory StayType.fromJson(Map<String, dynamic> json) {
    return StayType(
      id: json['_id'] as String,
      stayType: json['staytype'] as String,
    );
  }
}


class PriceRange {
  final int maxPrice;
  final int minPrice;

  const PriceRange({required this.maxPrice, required this.minPrice});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      maxPrice: (json['maxPrice'] as num).toInt(),
      minPrice: (json['minPrice'] as num).toInt(),
    );
  }
}
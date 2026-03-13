// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:indhostels/utils/widgets/authwidgts.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child: const Center(child: Text("Bookings Screen")));
  }
}

// ── Drop your API JSON response here for testing ─────────────────
const String _sampleApiJson = r'''
{"success":true,"statuscode":200,"data":[
  {"_id":"69a7dd33522e2b65e03d8224","bookingId":"BOKindhostels17726088198559186",
   "status":"confirmed","price_type":"per day","room_price":500,"bookingamount":1500,
   "check_in_date":"2026-03-07T00:00:00.000Z","check_out_date":"2026-03-08T00:00:00.000Z",
   "days":"1 days","guests":3,"roomtype":"Three Share Room","discountamount":0,"couponCode":"",
   "bookedAt":"2026-02-27T06:04:19.857Z","createdAt":"2026-03-04T07:20:19.855Z","updatedAt":"2026-03-04T07:20:19.866Z","__v":0,
   "accommodationId":{"_id":"690d9ac019f1d7d6f7537d6c","property_name":"Homely Haven",
     "property_type":"pgs","category_name":"menspg","isverified":true,"tax":false,"tax_amount":0,
     "location":{"city":"hyderabad","area":"kphb","address":"KPHB Colony, Phase2, Near Metro Station"},
     "amenities":["wifi","meals included","24/7 security","laundry service","parking","gym"],
     "cancellation_policy":"before24hrs","check_in_time":"NA","check_out_time":"to 12:00 am",
     "host_details":{"host_name":"Ramesh","host_contact":"9569873216"},
     "images_url":["https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=400"]},
   "room_id":{"_id":"690db7ba97d40a5d14ebfc01","room_type":"Three Share Room","rooms_available":0,
     "room_description":"Spacious three share room","bookings":[],
     "room_amenities":["geyser","water purifier","Bed(single / bunker / cot)","Mattress & pillow","Study table & chair","Personal charging points","Curtains","meals"],
     "room_images_url":["https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=200"]},
   "guestdetails":{"fullname":"Pabolu Mukesh Narayana","mobilenumber":8374831031,
     "emailAddress":"mukesh@gmail.com","agreed":true,"noofadults":2,"noofchildrens":1,"gender":"male"},
   "paymentid":{"_id":"pay1","bookingamount":1500,"payment_mode":"online","payment_status":"paid",
     "invoice":"INDHOSTELS-819849","tax":0,
     "paymentInfo":{"razorpay_payment_id":"pay_SN41Ggfmjsb7kH","razorpay_order_id":"order_SN419NcpEt1j5J"}}},

  {"_id":"69a133112eb7eadf5db03b94","bookingId":"BOKindhostels17721720491886475",
   "status":"confirmed","price_type":"per month","room_price":3000,"bookingamount":3000,
   "check_in_date":"2026-02-28T00:00:00.000Z","check_out_date":"2026-03-28T00:00:00.000Z",
   "days":"4 weeks","guests":1,"roomtype":"threeshare","discountamount":0,"couponCode":"",
   "bookedAt":"2026-02-26T06:27:10.168Z","createdAt":"2026-02-27T06:00:49.188Z","updatedAt":"2026-02-27T06:00:49.204Z","__v":0,
   "accommodationId":{"_id":"694250c577b9c513afb1bd85","property_name":"Sri Vallabha Girls Hostel",
     "property_type":"hostels","category_name":"Girls Hostels","isverified":true,"tax":true,"tax_amount":0,
     "location":{"city":"hyderabad","area":"Jala Vayu Vihar","address":"Adda Gutta Socity, Roadno2, 55c",
       "locationurl":"https://maps.app.goo.gl/XXTqYEhbGxcnbtKA9"},
     "amenities":["24/7 security","cctv surveillance","wifi","lift/elevator","dining area","gym","parking area"],
     "cancellation_policy":"before24hrs","check_in_time":"na","check_out_time":"na",
     "host_details":{"host_contact":"8956745265","host_name":"pallavi"},
     "images_url":["https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400"]},
   "room_id":{"_id":"6942547b7d5cfecfb28bc75d","room_type":"threeshare","rooms_available":3,
     "room_description":"Spacious rooms with modern amenities","bookings":[],
     "room_amenities":["geyser","Tube light / LED light","Refrigerator","water purifier","Bed(single / bunker / cot)"],
     "room_images_url":["https://images.unsplash.com/photo-1566073771259-6a8506099945?w=200"]},
   "guestdetails":{"fullname":"Pabolu Mukesh Narayana","mobilenumber":8374831031,
     "emailAddress":"mukesh@gmail.com","agreed":true,"noofadults":0,"noofchildrens":0,"gender":"male"},
   "paymentid":{"_id":"pay2","bookingamount":3000,"payment_mode":"online","payment_status":"paid",
     "invoice":"INDHOSTELS-049177","tax":0,
     "paymentInfo":{"razorpay_payment_id":"pay_SL3zg3jReftKzZ"}}},

  {"_id":"694fd0ff3b4e89cc56ddefb3","bookingId":"BOKindhostels17668385275212403",
   "status":"confirmed","price_type":"per day","room_price":500,"bookingamount":1050,
   "check_in_date":"2025-12-28T00:00:00.000Z","check_out_date":"2025-12-30T00:00:00.000Z",
   "days":"2 days","guests":1,"roomtype":"oneshare","discountamount":0,"couponCode":"",
   "bookedAt":"2025-12-27T11:59:20.947Z","createdAt":"2025-12-27T12:28:47.521Z","updatedAt":"2025-12-27T12:28:47.609Z","__v":0,
   "accommodationId":{"_id":"694a447dd733e9c3f1110084","property_name":"Royalpg",
     "property_type":"pgs","category_name":"menspg","isverified":true,"tax":true,"tax_amount":50,
     "location":{"city":"hyderabad","area":"miyapur","address":"miyapur, teachers colony, 55r",
       "locationurl":"https://maps.app.goo.gl/yYYLqnnvAPkcyj9g8","lat":17.49781566107733,"lont":78.39689953810134},
     "amenities":["power backup","wifi"],
     "cancellation_policy":"before24hrs","check_in_time":"NA","check_out_time":"NA",
     "host_details":{"host_contact":"6547893218","host_name":"Swami"},
     "images_url":["https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400"]},
   "room_id":{"_id":"694a8a56f537e86be29eb4db","room_type":"oneshare","rooms_available":4,
     "room_description":"Private single room","bookings":[],
     "room_amenities":["geyser","water purifier","Bed(single / bunker / cot)","Mattress & pillow","Study table & chair","meals"],
     "room_images_url":["https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=200"]},
   "guestdetails":{"fullname":"Pabolu Mukesh Narayana","mobilenumber":8374831031,
     "emailAddress":"mukesh@gmail.com","agreed":true,"noofadults":0,"noofchildrens":0,"gender":"male"},
   "paymentid":{"_id":"pay3","bookingamount":1050,"payment_mode":"online","payment_status":"paid",
     "invoice":"INDHOSTELS-527413","tax":50,
     "paymentInfo":{"razorpay_payment_id":"pay_RwdU2R1HZ2n618"}}},

  {"_id":"69393d53cea138bbd0deaa08","bookingId":"BOKindhostels17653589314462627",
   "status":"confirmed","price_type":"per day","room_price":500,"bookingamount":510,
   "check_in_date":"2025-12-12T00:00:00.000Z","check_out_date":"2025-12-13T00:00:00.000Z",
   "days":"1 days","guests":1,"roomtype":"four share","discountamount":0,"couponCode":"",
   "bookedAt":"2025-12-10T09:28:41.323Z","createdAt":"2025-12-10T09:28:51.446Z","updatedAt":"2025-12-10T09:28:51.526Z","__v":0,
   "accommodationId":{"_id":"69328a5fd9300c2ce8c2a378","property_name":"Sri Vallabha Mens Pg",
     "property_type":"pgs","category_name":"menspg","isverified":true,"tax":true,"tax_amount":10,
     "location":{"city":"hyderabad","area":"kphb","address":"Jala Vayu vihar, adda gutta socity, Roadno.2",
       "locationurl":"https://maps.app.goo.gl/ofZaduJMubVsTrdv7"},
     "amenities":["wifi"],
     "cancellation_policy":"before48hrs","check_in_time":"no","check_out_time":"no",
     "host_details":{"host_contact":"9703243104","host_name":"bhanu"},
     "images_url":["https://images.unsplash.com/photo-1445019980597-93fa8acb246c?w=400"]},
   "room_id":{"_id":"6939132bb6cf284c2b922bde","room_type":"four share","rooms_available":22,
     "room_description":"Spacious four share room","bookings":[],
     "room_amenities":["geyser","water purifier","Bed(single / bunker / cot)","Mattress & pillow","Study table & chair","meals"],
     "room_images_url":["https://images.unsplash.com/photo-1445019980597-93fa8acb246c?w=200"]},
   "guestdetails":{"fullname":"Sukesh","mobilenumber":8374831031,
     "emailAddress":"mukesh@gmail.com","agreed":true,"noofadults":0,"noofchildrens":0,"gender":"Male"},
   "paymentid":{"_id":"pay4","bookingamount":510,"payment_mode":"coc","payment_status":"unpaid",
     "invoice":"INDHOSTELS-931413","tax":10}}
],"totalpages":3,"totalOrders":26}
''';



class BookingsLoader extends StatefulWidget {
  const BookingsLoader();

  @override
  State<BookingsLoader> createState() => _BookingsLoaderState();
}

class _BookingsLoaderState extends State<BookingsLoader> {
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));
    final raw = jsonDecode(_sampleApiJson) as Map<String, dynamic>;
    final response = BookingsResponse.fromJson(raw);
    setState(() {
      _bookings = response.data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => MyBookingsScreen(
    bookings: _bookings,
    isLoading: _isLoading,
    onRefresh: _load,
  );
}

class MyBookingsScreen extends StatefulWidget {
  final List<BookingModel> bookings;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const MyBookingsScreen({
    super.key,
    required this.bookings,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int _selectedTab = 0;

  /// Upcoming / active: check-out in the future
  List<BookingModel> get _booked => widget.bookings
      .where(
        (b) => b.checkOut.isAfter(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      )
      .toList();

  /// Past bookings
  List<BookingModel> get _history => widget.bookings
      .where((b) => b.checkOut.isBefore(DateTime.now()))
      .toList();

  List<BookingModel> get _current => _selectedTab == 0 ? _booked : _history;

  @override
  Widget build(BuildContext context) {
    final isTab = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: _buildAppBar(isTab),
      body: Column(
        children: [
          _buildTabBar(isTab),
          if (widget.isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF5B4BCC)),
              ),
            )
          else if (_current.isEmpty)
            _buildEmpty(isTab)
          else
            Expanded(
              child: isTab ? _buildTabGrid(isTab) : _buildMobileList(isTab),
            ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(bool isTab) => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    title: Text(
      'My Bookings',
      style: TextStyle(
        color: const Color(0xFF1A1A2E),
        fontWeight: FontWeight.w700,
        fontSize: isTab ? 22 : 18,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.bookings.length} Total',
              style: const TextStyle(
                color: Color(0xFF5B4BCC),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildTabBar(bool isTab) => Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: isTab ? 32 : 20, vertical: 12),
    child: AuthTabSwitcher(
      isTab: isTab,
      selectedIndex: _selectedTab,
      tabs: ['Booked (${_booked.length})', 'History (${_history.length})'],
      onTabSelected: (i) => setState(() => _selectedTab = i),
    ),
  );

  Widget _buildMobileList(bool isTab) => RefreshIndicator(
    color: const Color(0xFF5B4BCC),
    onRefresh: () async => widget.onRefresh?.call(),
    child: ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: _current.length,
      itemBuilder: (_, i) => BookingCard(
        booking: _current[i],
        isTab: isTab,
        isHistory: _selectedTab == 1,
        onPrimaryAction: () => _openDetail(_current[i]),
        onSecondaryAction: () => _handleSecondary(_current[i]),
      ),
    ),
  );

  Widget _buildTabGrid(bool isTab) => RefreshIndicator(
    color: const Color(0xFF5B4BCC),
    onRefresh: () async => widget.onRefresh?.call(),
    child: GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 4,
        childAspectRatio: 1.2,
      ),
      itemCount: _current.length,
      itemBuilder: (_, i) => BookingCard(
        booking: _current[i],
        isTab: isTab,
        isHistory: _selectedTab == 1,
        onPrimaryAction: () => _openDetail(_current[i]),
        onSecondaryAction: () => _handleSecondary(_current[i]),
      ),
    ),
  );

  Widget _buildEmpty(bool isTab) => Expanded(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _selectedTab == 0 ? Icons.hotel_outlined : Icons.history_rounded,
            size: isTab ? 72 : 56,
            color: const Color(0xFFD0C8FF),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedTab == 0 ? 'No active bookings' : 'No past bookings',
            style: TextStyle(
              fontSize: isTab ? 18 : 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your bookings will appear here',
            style: TextStyle(
              fontSize: isTab ? 14 : 12,
              color: const Color(0xFFAAAAAA),
            ),
          ),
        ],
      ),
    ),
  );

  void _openDetail(BookingModel booking) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: booking)),
  );

  void _handleSecondary(BookingModel booking) {
    if (_selectedTab == 0) {
      _showCancelDialog(booking);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Opening Rate & Review...')));
    }
  }

  void _showCancelDialog(BookingModel booking) => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Cancel Booking?',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      content: Text(
        'Cancel booking at ${booking.propertyName}?\n\n'
        'Policy: ${booking.accommodation.cancellationPolicy}',
        style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Keep', style: TextStyle(color: Color(0xFF5B4BCC))),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Booking cancelled')));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
// =================================================================================================================================================================

// ── Status helpers ──────────────────────────────────────────────
enum BookingStatus { confirmed, cancelled, completed, pending }

extension BookingStatusX on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.pending:
        return 'Pending';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.confirmed:
        return const Color(0xFF4CAF50);
      case BookingStatus.cancelled:
        return const Color(0xFFE53935);
      case BookingStatus.completed:
        return const Color(0xFF2196F3);
      case BookingStatus.pending:
        return const Color(0xFFFFA726);
    }
  }

  static BookingStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }
}

// ── Payment Model ───────────────────────────────────────────────
class PaymentModel {
  final String id;
  final double amount;
  final String mode; // "online" | "coc"
  final String status; // "paid" | "unpaid"
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

// ── Location Model ──────────────────────────────────────────────
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

// ── Room Model ──────────────────────────────────────────────────
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
    // amenities can be List<String> or List with comma-joined string
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

// ── Accommodation Model ─────────────────────────────────────────
class AccommodationModel {
  final String id;
  final String propertyName;
  final String propertyType; // "pgs" | "hostels"
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

// ── Guest Details Model ─────────────────────────────────────────
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

// ── Main Booking Model ──────────────────────────────────────────
class BookingModel {
  final String id;
  final String bookingId;
  final AccommodationModel accommodation;
  final RoomModel room;
  final BookingStatus status;
  final String priceType; // "per day" | "per month" | "per week"
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

// ── API Response Wrapper ────────────────────────────────────────
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
// ========================================================================================================================================================

class BookingDetailScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailScreen({super.key, required this.booking});

  String _fmt(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    final isTab = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1A1A2E),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Details',
          style: TextStyle(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: isTab ? 22 : 18,
          ),
        ),
      ),
      body: isTab
          ? _buildTabLayout(context, isTab)
          : _buildMobileLayout(context, isTab),
    );
  }

  // ── Layouts ──────────────────────────────────────────────────
  Widget _buildMobileLayout(BuildContext context, bool isTab) => Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _BookingHeaderCard(booking: booking, isTab: isTab),
              const SizedBox(height: 16),
              _LocationCard(booking: booking, isTab: isTab),
              const SizedBox(height: 16),
              _BookingDetailsCard(booking: booking, isTab: isTab),
              const SizedBox(height: 16),
              _AmenitiesCard(booking: booking, isTab: isTab),
              const SizedBox(height: 16),
              _PaymentCard(booking: booking, isTab: isTab),
              const SizedBox(height: 16),
              _GuestCard(booking: booking, isTab: isTab),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      _BottomActions(booking: booking, isTab: isTab, context: context),
    ],
  );

  Widget _buildTabLayout(BuildContext context, bool isTab) => Column(
    children: [
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _BookingHeaderCard(booking: booking, isTab: isTab),
                    const SizedBox(height: 20),
                    _LocationCard(booking: booking, isTab: isTab),
                    const SizedBox(height: 20),
                    _AmenitiesCard(booking: booking, isTab: isTab),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _BookingDetailsCard(booking: booking, isTab: isTab),
                    const SizedBox(height: 20),
                    _PaymentCard(booking: booking, isTab: isTab),
                    const SizedBox(height: 20),
                    _GuestCard(booking: booking, isTab: isTab),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      _BottomActions(booking: booking, isTab: isTab, context: context),
    ],
  );
}

// ── Booking Header Card ─────────────────────────────────────────
class _BookingHeaderCard extends StatelessWidget {
  final BookingModel booking;
  final bool isTab;
  const _BookingHeaderCard({required this.booking, required this.isTab});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Booking ID : ${booking.bookingId.replaceFirst('BOKindhostels', '')}',
                  style: TextStyle(
                    fontSize: isTab ? 14 : 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppBadge(status: booking.status),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Row(
              children: [
                Text(
                  'Invoice : ',
                  style: TextStyle(
                    fontSize: isTab ? 13 : 11,
                    color: const Color(0xFF888888),
                  ),
                ),
                Text(
                  booking.payment.invoice,
                  style: TextStyle(
                    fontSize: isTab ? 13 : 11,
                    color: const Color(0xFF5B4BCC),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          Row(
            children: [
              HotelImageCard(
                imageUrl: booking.primaryImage,
                width: isTab ? 90 : 76,
                height: isTab ? 80 : 68,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.propertyName,
                      style: TextStyle(
                        fontSize: isTab ? 16 : 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: Color(0xFF888888),
                        ),
                        Text(
                          booking.accommodation.location.displayArea,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF888888),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _TypeChip(
                          label: booking.accommodation.propertyType
                              .toUpperCase(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: booking.formattedRoomPrice,
                            style: TextStyle(
                              fontSize: isTab ? 15 : 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          TextSpan(
                            text: ' / ${booking.priceType}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Location Card ───────────────────────────────────────────────
class _LocationCard extends StatelessWidget {
  final BookingModel booking;
  final bool isTab;
  const _LocationCard({required this.booking, required this.isTab});

  @override
  Widget build(BuildContext context) {
    final loc = booking.accommodation.location;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location',
                style: TextStyle(
                  fontSize: isTab ? 15 : 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              if (loc.locationUrl != null)
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Open Map',
                    style: TextStyle(
                      color: Color(0xFF5B4BCC),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: isTab ? 160 : 130,
              width: double.infinity,
              color: const Color(0xFFD9E8D5),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.location_on,
                      color: Color(0xFF5B4BCC),
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF5B4BCC), size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  loc.fullAddress,
                  style: TextStyle(
                    fontSize: isTab ? 13 : 12,
                    color: const Color(0xFF555555),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Booking Details Card ────────────────────────────────────────
class _BookingDetailsCard extends StatelessWidget {
  final BookingModel booking;
  final bool isTab;
  const _BookingDetailsCard({required this.booking, required this.isTab});

  String _fmt(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Booking Details',
            style: TextStyle(
              fontSize: isTab ? 15 : 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 14),
          SectionLabel(
            title: 'Dates',
            icon: Icons.calendar_month_outlined,
            isTab: isTab,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              '${_fmt(booking.checkIn)} → ${_fmt(booking.checkOut)} (${booking.days})',
              style: const TextStyle(fontSize: 12, color: Color(0xFF5B4BCC)),
            ),
          ),
          const SizedBox(height: 12),
          SectionLabel(
            title: 'Guests',
            icon: Icons.people_outline,
            isTab: isTab,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              '${booking.guests} guest(s)',
              style: const TextStyle(fontSize: 12, color: Color(0xFF5B4BCC)),
            ),
          ),
          const SizedBox(height: 12),
          SectionLabel(
            title: 'Room type',
            icon: Icons.bed_outlined,
            isTab: isTab,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              booking.roomType,
              style: const TextStyle(fontSize: 12, color: Color(0xFF5B4BCC)),
            ),
          ),
          const SizedBox(height: 12),
          SectionLabel(
            title: 'Cancellation Policy',
            icon: Icons.policy_outlined,
            isTab: isTab,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              booking.accommodation.cancellationPolicy,
              style: const TextStyle(fontSize: 12, color: Color(0xFF5B4BCC)),
            ),
          ),
          const SizedBox(height: 12),
          SectionLabel(title: 'Host', icon: Icons.person_outline, isTab: isTab),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              '${booking.accommodation.hostName} · ${booking.accommodation.hostContact}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF5B4BCC)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Amenities Card ──────────────────────────────────────────────
class _AmenitiesCard extends StatelessWidget {
  final BookingModel booking;
  final bool isTab;
  const _AmenitiesCard({required this.booking, required this.isTab});

  @override
  Widget build(BuildContext context) {
    final amenities = booking.room.amenities;
    if (amenities.isEmpty) return const SizedBox.shrink();

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Amenities',
            style: TextStyle(
              fontSize: isTab ? 15 : 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amenities
                .map(
                  (a) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EEFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      a,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF5B4BCC),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Payment Card ────────────────────────────────────────────────
class _PaymentCard extends StatelessWidget {
  final BookingModel booking;
  final bool isTab;
  const _PaymentCard({required this.booking, required this.isTab});

  @override
  Widget build(BuildContext context) {
    final p = booking.payment;
    final roomAmt = booking.roomPrice;
    final tax = p.tax;
    final discount = booking.discountAmount;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: isTab ? 15 : 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: p.isPaid
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : const Color(0xFFFFA726).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  p.isPaid ? '● Paid' : '● Unpaid',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: p.isPaid
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFFFA726),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PaymentRow(
            label: '${booking.formattedRoomPrice} × ${booking.days}',
            value: '₹${roomAmt.toStringAsFixed(0)}',
            isTab: isTab,
          ),
          if (tax > 0)
            PaymentRow(
              label: 'Tax & Fees',
              value: '₹${tax.toStringAsFixed(0)}',
              isTab: isTab,
            ),
          if (discount > 0)
            PaymentRow(
              label:
                  'Discount${booking.couponCode.isNotEmpty ? ' (${booking.couponCode})' : ''}',
              value: '-₹${discount.toStringAsFixed(0)}',
              isTab: isTab,
            ),
          const Divider(height: 16, color: Color(0xFFF0F0F0)),
          PaymentRow(
            label: 'Total Payment',
            value: '₹${booking.bookingAmount.toStringAsFixed(0)}/-',
            isTotal: true,
            isTab: isTab,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                p.isOnline ? Icons.credit_card : Icons.money,
                size: 14,
                color: const Color(0xFF888888),
              ),
              const SizedBox(width: 6),
              Text(
                p.isOnline
                    ? 'Online · ${p.razorpayPaymentId ?? ''}'
                    : 'Cash on Check-in',
                style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Guest Details Card ──────────────────────────────────────────
class _GuestCard extends StatelessWidget {
  final BookingModel booking;
  final bool isTab;
  const _GuestCard({required this.booking, required this.isTab});

  @override
  Widget build(BuildContext context) {
    final g = booking.guestDetails;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guest Details',
            style: TextStyle(
              fontSize: isTab ? 15 : 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          _GuestRow(icon: Icons.person_outline, value: g.fullname),
          const SizedBox(height: 8),
          _GuestRow(icon: Icons.phone_outlined, value: g.mobile),
          const SizedBox(height: 8),
          _GuestRow(icon: Icons.email_outlined, value: g.email),
          const SizedBox(height: 8),
          _GuestRow(
            icon: Icons.wc_outlined,
            value: '${g.gender[0].toUpperCase()}${g.gender.substring(1)}',
          ),
        ],
      ),
    );
  }
}

class _GuestRow extends StatelessWidget {
  final IconData icon;
  final String value;
  const _GuestRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF5B4BCC)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Bottom Actions ──────────────────────────────────────────────
class _BottomActions extends StatelessWidget {
  final BookingModel booking;
  final bool isTab;
  final BuildContext context;
  const _BottomActions({
    required this.booking,
    required this.isTab,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTab ? 32 : 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'Cancel',
              onPressed: () => Navigator.pop(ctx),
              variant: AppButtonVariant.outline,
              height: isTab ? 52 : 46,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton(
              label: 'Invoice',
              icon: Icons.download_rounded,
              onPressed: () => ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text('Downloading ${booking.payment.invoice}...'),
                ),
              ),
              variant: AppButtonVariant.primary,
              height: isTab ? 52 : 46,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Generic white card ──────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

class _TypeChip extends StatelessWidget {
  final String label;
  const _TypeChip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      color: const Color(0xFFF0EEFF),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 9,
        color: Color(0xFF5B4BCC),
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
// ===============================================================================================================================================================

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isTab;
  final bool isHistory;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isTab,
    this.isHistory = false,
    this.onPrimaryAction,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isTab ? 20 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          _buildHotelInfo(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final shortId = booking.bookingId.replaceFirst('BOKindhostels', '');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Booking ID : $shortId',
              style: TextStyle(
                fontSize: isTab ? 14 : 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          AppBadge(status: booking.status),
        ],
      ),
    );
  }

  Widget _buildHotelInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HotelImageCard(
            imageUrl: booking.primaryImage,
            width: isTab ? 100 : 84,
            height: isTab ? 90 : 76,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        booking.propertyName,
                        style: TextStyle(
                          fontSize: isTab ? 15 : 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    if (booking.accommodation.isVerified)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B4BCC).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '✓ Verified',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF5B4BCC),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Color(0xFF888888),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      booking.locationDisplay,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EEFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        booking.accommodation.propertyType.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF5B4BCC),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  booking.roomType,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: booking.formattedAmount,
                            style: TextStyle(
                              fontSize: isTab ? 15 : 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          TextSpan(
                            text: ' / ${booking.days}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _PaymentPill(isPaid: booking.payment.isPaid),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: isHistory ? 'Rate & Review' : 'Cancel',
              onPressed: onSecondaryAction,
              variant: AppButtonVariant.outline,
              height: isTab ? 46 : 42,
              fontSize: isTab ? 13 : 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              label: isHistory ? 'Rebook' : 'View Details',
              onPressed: onPrimaryAction,
              variant: AppButtonVariant.primary,
              height: isTab ? 46 : 42,
              fontSize: isTab ? 13 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentPill extends StatelessWidget {
  final bool isPaid;
  const _PaymentPill({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPaid
            ? const Color(0xFF4CAF50).withOpacity(0.1)
            : const Color(0xFFFFA726).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isPaid ? '● Paid' : '● Unpaid',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isPaid ? const Color(0xFF4CAF50) : const Color(0xFFFFA726),
        ),
      ),
    );
  }
}

class AppBadge extends StatelessWidget {
  final BookingStatus status;

  const AppBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              color: status.color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
// =========================================================payment-button=========================================

class PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isTab;

  const PaymentRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isTab = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTab ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              color: isTotal
                  ? const Color(0xFF1A1A2E)
                  : const Color(0xFF555555),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTab ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}

enum AppButtonVariant { primary, outline }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final double fontSize;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 44,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AppButtonVariant.primary;
    return SizedBox(
      width: width,
      height: height,
      child: isPrimary
          ? ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B4BCC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: _buildChild(Colors.white),
            )
          : OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF5B4BCC),
                side: const BorderSide(color: Color(0xFF5B4BCC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _buildChild(const Color(0xFF5B4BCC)),
            ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(color: color, strokeWidth: 2),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Icon(icon, size: 16),
        ],
      );
    }
    return Text(
      label,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
    );
  }
}

class HotelImageCard extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  const HotelImageCard({
    super.key,
    required this.imageUrl,
    this.width = 80,
    this.height = 72,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: const Color(0xFFEEEEEE),
          child: const Icon(Icons.hotel, color: Colors.grey),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isTab;

  const SectionLabel({
    super.key,
    required this.title,
    required this.icon,
    this.isTab = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: isTab ? 20 : 16, color: const Color(0xFF5B4BCC)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: isTab ? 16 : 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

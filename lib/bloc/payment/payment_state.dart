part of 'payment_bloc.dart';

enum PaymentStatus {
  initial,
  creatingOrder,
  openingGateway,
  verifying,
  success,
  failure,
}

class PaymentState extends Equatable {
  final String stayType;
  final String? cancellationPolicy;
  final String? checkInTime;
  final bool isVerified;

  final String pricingType;

  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  final int adults;
  final int children;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final bool termsAccepted;

  final String? fullNameError;
  final String? emailError;
  final String? phoneError;
  final String? dateError;

  final double pricePerUnit;
  final double cleaningFee;
  final double serviceFee;

  final PaymentStatus status;
  final String? errorMessage;

  final bool taxEnabled;
  final double taxAmount;
  final double taxPercentage;
  final int maxAdults;
  const PaymentState({
    this.stayType = 'hostel',
    this.cancellationPolicy,
    this.checkInTime,
    this.isVerified = false,
    this.pricingType = 'per day',
    this.checkInDate,
    this.checkOutDate,
    this.adults = 1,
    this.children = 0,
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.gender = 'Male',
    this.termsAccepted = false,
    this.fullNameError,
    this.emailError,
    this.phoneError,
    this.dateError,
    this.pricePerUnit = 0,
    this.cleaningFee = 200,
    this.serviceFee = 100,
    this.status = PaymentStatus.initial,
    this.errorMessage,
    this.taxEnabled = false,
    this.taxAmount = 0,
    this.taxPercentage = 0,
    this.maxAdults = 1,
  });

  String get normalizedPricing => pricingType.toLowerCase().trim();

  int get totalGuests => adults + children;

  int get totalNights {
    if (checkInDate == null || checkOutDate == null) return 0;
    final days = checkOutDate!.difference(checkInDate!).inDays;
    return days > 0 ? days : 0;
  }

  double get roomTotal {
    final type = normalizedPricing;

    if (type.contains('day')) {
      return pricePerUnit * totalNights * totalGuests;
    }

    if (type.contains('week')) {
      final weeks = (totalNights / 7).ceil();
      return pricePerUnit * weeks * totalGuests;
    }

    if (type.contains('month')) {
      final months = ((totalNights == 0 ? 30 : totalNights) / 30).ceil();
      return pricePerUnit * months * totalGuests;
    }

    return 0;
  }

  // double get subtotal => roomTotal + cleaningFee + serviceFee;
  double get subtotal => roomTotal;

  double get taxTotal {
    if (!taxEnabled) return 0;

    if (taxPercentage > 0) {
      return subtotal * taxPercentage / 100;
    }

    return taxAmount;
  }

  double get grandTotal => subtotal + taxTotal;

  bool get canCheckout =>
      checkInDate != null &&
      checkOutDate != null &&
      totalNights >= 0 &&
      dateError == null &&
      termsAccepted &&
      fullNameError == null &&
      emailError == null &&
      phoneError == null &&
      fullName.isNotEmpty &&
      email.isNotEmpty &&
      phone.isNotEmpty;

  PaymentState copyWith({
    String? stayType,
    String? cancellationPolicy,
    bool clearCancellationPolicy = false,
    String? checkInTime,
    bool clearCheckInTime = false,
    bool? isVerified,
    String? pricingType,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? adults,
    int? children,
    String? fullName,
    String? email,
    String? phone,
    String? gender,
    bool? termsAccepted,
    String? fullNameError,
    String? emailError,
    String? phoneError,
    String? dateError,
    bool clearFullNameError = false,
    bool clearEmailError = false,
    bool clearPhoneError = false,
    bool clearDateError = false,
    double? pricePerUnit,
    double? cleaningFee,
    double? serviceFee,
    PaymentStatus? status,
    String? errorMessage,
    bool clearError = false,
    bool? taxEnabled,
    double? taxAmount,
    double? taxPercentage,
    int? maxAdults,
  }) {
    return PaymentState(
      stayType: stayType ?? this.stayType,
      cancellationPolicy: clearCancellationPolicy
          ? null
          : cancellationPolicy ?? this.cancellationPolicy,
      checkInTime: clearCheckInTime ? null : checkInTime ?? this.checkInTime,
      isVerified: isVerified ?? this.isVerified,
      pricingType: pricingType ?? this.pricingType,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      fullNameError: clearFullNameError
          ? null
          : fullNameError ?? this.fullNameError,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      phoneError: clearPhoneError ? null : phoneError ?? this.phoneError,
      dateError: clearDateError ? null : dateError ?? this.dateError,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      cleaningFee: cleaningFee ?? this.cleaningFee,
      serviceFee: serviceFee ?? this.serviceFee,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      taxEnabled: taxEnabled ?? this.taxEnabled,
      taxAmount: taxAmount ?? this.taxAmount,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      maxAdults: maxAdults ?? this.maxAdults,
    );
  }

  @override
  List<Object?> get props => [
    stayType,
    cancellationPolicy,
    checkInTime,
    isVerified,
    pricingType,
    checkInDate,
    checkOutDate,
    adults,
    children,
    fullName,
    email,
    phone,
    gender,
    termsAccepted,
    fullNameError,
    emailError,
    phoneError,
    dateError,
    pricePerUnit,
    cleaningFee,
    serviceFee,
    status,
    errorMessage,
    taxEnabled,
    taxAmount,
    taxPercentage,
  ];
}

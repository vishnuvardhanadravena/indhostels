part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentInitialized extends PaymentEvent {
  final double pricePerNight;
  final String stayType;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? cancellationPolicy;
  final String? checkInTime;
  final bool isVerified;
  final String pricingType;

  final bool taxEnabled;
  final double taxAmount;

  final int maxAdults;

  const PaymentInitialized({
    required this.pricePerNight,
    required this.stayType,
    this.checkInDate,
    this.checkOutDate,
    this.cancellationPolicy,
    this.checkInTime,
    this.isVerified = false,
    required this.pricingType,
    this.taxEnabled = false,
    this.taxAmount = 0,
    required this.maxAdults,
  });
}

class PaymentDateRangeUpdated extends PaymentEvent {
  final DateTimeRange range;
  const PaymentDateRangeUpdated(this.range);
}

class PaymentAdultsChanged extends PaymentEvent {
  final int delta;
  const PaymentAdultsChanged(this.delta);
}

class PaymentChildrenChanged extends PaymentEvent {
  final int delta;
  const PaymentChildrenChanged(this.delta);
}

class PaymentFullNameChanged extends PaymentEvent {
  final String value;
  const PaymentFullNameChanged(this.value);
}

class PaymentEmailChanged extends PaymentEvent {
  final String value;
  const PaymentEmailChanged(this.value);
}

class PaymentPhoneChanged extends PaymentEvent {
  final String value;
  const PaymentPhoneChanged(this.value);
}

class PaymentGenderChanged extends PaymentEvent {
  final String gender;
  const PaymentGenderChanged(this.gender);
}

class PaymentTermsToggled extends PaymentEvent {
  const PaymentTermsToggled();
}

class PaymentCheckoutRequested extends PaymentEvent {
  final String propertyId;
  final String roomId;

  const PaymentCheckoutRequested({
    required this.propertyId,
    required this.roomId,
  });
}

class PaymentVerifyRequested extends PaymentEvent {
  final String paymentId;
  final String orderId;
  final String aco_id;
  final String room_id;
  final String signature;

  const PaymentVerifyRequested({
    required this.paymentId,
    required this.orderId,
    required this.aco_id,
    required this.room_id,
    required this.signature,
  });
}

class PaymentFailed extends PaymentEvent {
  final String message;

  const PaymentFailed(this.message);
}

class PaymentReset extends PaymentEvent {}

class PaymentPricingChanged extends PaymentEvent {
  final String pricingType;
  final double price;

  const PaymentPricingChanged(this.pricingType, this.price);
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:indhostels/data/models/bookings/coupons.dart';
import 'package:indhostels/data/repo/bookings_repo.dart';
import 'package:indhostels/services/payment/razorpay_gateway.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final BookingsRepository bookingsRepository;
  final RazorpayService razorpayService;

  static const int _minAdults = 1;
  static const int _minChildren = 0;
  static const int _maxChildren = 10;
  static const double _cleaningFee = 200;
  static const double _serviceFee = 100;

  PaymentBloc(this.bookingsRepository, this.razorpayService)
    : super(const PaymentState()) {
    on<PaymentInitialized>(_onInitialized);
    on<PaymentDateRangeUpdated>(_onDateRangeUpdated);
    on<PaymentAdultsChanged>(_onAdultsChanged);
    on<PaymentChildrenChanged>(_onChildrenChanged);
    on<PaymentFullNameChanged>(_onFullNameChanged);
    on<PaymentEmailChanged>(_onEmailChanged);
    on<PaymentPhoneChanged>(_onPhoneChanged);
    on<PaymentGenderChanged>(_onGenderChanged);
    on<PaymentTermsToggled>(_onTermsToggled);
    on<PaymentCheckoutRequested>(_onCheckoutRequested);
    on<PaymentVerifyRequested>(_onVerifyPayment);
    on<PaymentFailed>(_onPaymentFailed);
    // In constructor, register:
    on<GetCouponsRequested>(_onGetCoupons);
    on<CouponApplied>(_onCouponApplied);
    on<CouponRemoved>(_onCouponRemoved);
    on<PaymentReset>((event, emit) {
      emit(state.copyWith(status: PaymentStatus.initial, errorMessage: null));
    });
    on<PaymentPricingChanged>((event, emit) {
      emit(
        state.copyWith(
          pricingType: event.pricingType,
          pricePerUnit: event.price,
        ),
      );
    });
  }

  void _onInitialized(PaymentInitialized e, Emitter<PaymentState> emit) {
    final checkIn = e.checkInDate;

    final isMonthly = e.pricingType.toLowerCase().contains('month');

    final checkOut = isMonthly && checkIn != null
        ? checkIn.add(const Duration(days: 30))
        : e.checkOutDate;

    emit(
      state.copyWith(
        stayType: e.stayType,
        cancellationPolicy: e.cancellationPolicy,
        checkInTime: e.checkInTime,
        isVerified: e.isVerified,
        checkInDate: checkIn,
        checkOutDate: checkOut,
        pricePerUnit: e.pricePerNight,
        cleaningFee: _cleaningFee,
        serviceFee: _serviceFee,
        pricingType: e.pricingType,
        maxAdults: e.maxAdults,
        taxAmount: e.taxAmount,
        taxEnabled: e.taxEnabled,
      ),
    );
  }

  void _onDateRangeUpdated(
    PaymentDateRangeUpdated e,
    Emitter<PaymentState> emit,
  ) {
    final checkIn = e.range.start;

    final isMonthly = state.pricingType.toLowerCase().contains('month');

    final checkOut = isMonthly
        ? checkIn.add(const Duration(days: 30))
        : e.range.end;

    emit(state.copyWith(checkInDate: checkIn, checkOutDate: checkOut));
  }

  void _onAdultsChanged(PaymentAdultsChanged e, Emitter<PaymentState> emit) {
    final next = (state.adults + e.delta).clamp(_minAdults, state.maxAdults);

    emit(state.copyWith(adults: next));
  }

  void _onChildrenChanged(
    PaymentChildrenChanged e,
    Emitter<PaymentState> emit,
  ) {
    final next = (state.children + e.delta).clamp(_minChildren, _maxChildren);
    emit(state.copyWith(children: next));
  }

  void _onFullNameChanged(
    PaymentFullNameChanged e,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(fullName: e.value));
  }

  void _onEmailChanged(PaymentEmailChanged e, Emitter<PaymentState> emit) {
    emit(state.copyWith(email: e.value));
  }

  void _onPhoneChanged(PaymentPhoneChanged e, Emitter<PaymentState> emit) {
    emit(state.copyWith(phone: e.value));
  }

  void _onGenderChanged(PaymentGenderChanged e, Emitter<PaymentState> emit) {
    emit(state.copyWith(gender: e.gender));
  }

  void _onTermsToggled(PaymentTermsToggled e, Emitter<PaymentState> emit) {
    emit(state.copyWith(termsAccepted: !state.termsAccepted));
  }

  Map<String, dynamic> _buildBookingBody() {
    return {
      "check_in_date": _formatDate(state.checkInDate),
      "check_out_date": _formatDate(state.checkOutDate),
      "price_type": state.pricingType,
      "noofguests": state.adults + state.children,
      "guestdetails": {
        "fullname": state.fullName.trim(),
        "mobilenumber": int.tryParse(state.phone) ?? 0,
        "emailAddress": state.email,
        "agreed": true,
        "noofadults": state.adults,
        "noofchildrens": state.children,
        "gender": state.gender,
      },
      "paymentmode": "online",
      "bookingamount": state.grandTotal.toInt(),
      "couponCode": state.appliedCouponCode ?? "",
      "discountamount": state.discountAmount.toInt(),
    };
  }

  Future<void> _onCheckoutRequested(
    PaymentCheckoutRequested e,
    Emitter<PaymentState> emit,
  ) async {
    if (!state.canCheckout) {
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          errorMessage: "Fill all details",
        ),
      );
      return;
    }

    emit(state.copyWith(status: PaymentStatus.creatingOrder));

    try {
      final body = _buildBookingBody();

      final order = await bookingsRepository.createBooking(
        propertyId: e.propertyId,
        roomId: e.roomId,
        body: body,
      );

      emit(state.copyWith(status: PaymentStatus.openingGateway));

      razorpayService.openCheckout(
        orderId: order["id"],
        amount: order["ammount"],
        name: state.fullName,
        email: state.email,
        contact: state.phone,
        onSuccess: (paymentId, orderId, signature) {
          add(
            PaymentVerifyRequested(
              paymentId: paymentId,
              orderId: orderId,
              acoid: e.propertyId,
              roomid: e.roomId,
              signature: signature,
            ),
          );
        },
        onFailure: (error) {
          add(PaymentFailed(error));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onVerifyPayment(
    PaymentVerifyRequested e,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PaymentStatus.verifying));
      final body = {
        "razorpay_order_id": e.orderId,
        "razorpay_payment_id": e.paymentId,
        "razorpay_signature": e.signature,

        "orderData": {
          "accoid": e.acoid,
          "roomid": e.roomid,

          "check_in_date": _formatDate(state.checkInDate),
          "check_out_date": _formatDate(state.checkOutDate),
          "price_type": state.pricingType,

          "noofguests": state.adults + state.children,

          "guestdetails": {
            "fullname": state.fullName.trim(),
            "mobilenumber": int.tryParse(state.phone) ?? 0,
            "emailAddress": state.email,
            "agreed": true,
            "noofadults": state.adults,
            "noofchildrens": state.children,
            "gender": state.gender.toLowerCase(),
          },

          "paymentmode": "online",
          "bookingamount": state.grandTotal.toDouble(),
          "couponCode": "",
          "discountamount": 0,
        },
      };

      await bookingsRepository.verifyPayment(body: body);

      emit(state.copyWith(status: PaymentStatus.success));
    } catch (e) {
      // emit(state.copyWith(status: PaymentStatus.initial));
      emit(
        state.copyWith(
          status: PaymentStatus.failure,
          errorMessage: "Payment verification failed",
        ),
      );
    }
  }

  void _onPaymentFailed(PaymentFailed e, Emitter<PaymentState> emit) {
    emit(
      state.copyWith(status: PaymentStatus.failure, errorMessage: e.message),
    );
  }
  // Add these handler methods:

  Future<void> _onGetCoupons(
    GetCouponsRequested e,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(couponsLoading: true, clearCouponsError: true));
    try {
      final res = await bookingsRepository.getCoupons();
      emit(state.copyWith(coupons: res.data ?? [], couponsLoading: false));
    } catch (e) {
      emit(state.copyWith(couponsLoading: false, couponsError: e.toString()));
    }
  }

  void _onCouponApplied(CouponApplied e, Emitter<PaymentState> emit) {
    final coupon = state.coupons.firstWhere(
      (c) => c.couponCode == e.code,
      orElse: () => Coupons(),
    );

    if (coupon.couponCode == null) {
      emit(state.copyWith(couponsError: 'Invalid coupon code'));
      return;
    }

    if (coupon.status?.toLowerCase() != 'active') {
      emit(state.copyWith(couponsError: 'This coupon is no longer active'));
      return;
    }

    // Check expiry
    if (coupon.expireDate != null) {
      final expiry = DateTime.tryParse(coupon.expireDate!);
      if (expiry != null && DateTime.now().isAfter(expiry)) {
        emit(state.copyWith(couponsError: 'This coupon has expired'));
        return;
      }
    }

    // Check minimum amount
    if (coupon.minimumamount != null &&
        state.grandTotal < coupon.minimumamount!) {
      emit(
        state.copyWith(
          couponsError:
              'Minimum order amount ₹${coupon.minimumamount} required',
        ),
      );
      return;
    }

    double discount = 0;
    if (coupon.discounttype?.toLowerCase() == 'percentage') {
      discount = (state.roomTotal * (coupon.discountpercentage ?? 0)) / 100;
    } else {
      discount = (coupon.discountamount ?? 0).toDouble();
    }

    // Cap discount to grand total
    discount = discount.clamp(0, state.grandTotal);

    emit(
      state.copyWith(
        appliedCouponCode: coupon.couponCode,
        discountAmount: discount,
        clearCouponsError: true,
      ),
    );
  }

  void _onCouponRemoved(CouponRemoved e, Emitter<PaymentState> emit) {
    emit(
      state.copyWith(
        clearAppliedCoupon: true,
        discountAmount: 0,
        clearCouponsError: true,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/Serach/search_bloc.dart';
import 'package:indhostels/data/models/accomodation/accomodation_details_res.dart';
import 'package:indhostels/pages/category/category_screen.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:intl/intl.dart';
import 'package:indhostels/bloc/payment/payment_bloc.dart';
import 'package:indhostels/data/models/accomodation/room_card_model.dart';

class BookingSummaryScreen extends StatefulWidget {
  final RoomModel room;
  // final String stayType;
  // final double pricePerNight;
  // final String cancellationPolicy;
  // final String checkInTime;
  final Acommodation accommodation;

  const BookingSummaryScreen({
    super.key,
    required this.room,
    // required this.stayType,
    // required this.pricePerNight,
    // required this.cancellationPolicy,
    // required this.checkInTime,
    required this.accommodation,
  });
  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  late List<Map<String, dynamic>> pricingOptions;
  // @override
  // void initState() {
  //   super.initState();
  //   final searchState = context.read<SearchBloc>().state;

  //   final pricing = widget.room.pricingId?.primaryPricing;

  //   final price = pricing?.price ?? 0;
  //   final priceType = pricing?.priceType.toLowerCase() ?? 'per night';
  //   final stayType = widget.accommodation.propertyType ?? "";

  //   context.read<PaymentBloc>().add(
  //     PaymentInitialized(
  //       pricePerNight: price,
  //       stayType: stayType,
  //       pricingType: priceType,
  //       checkInDate: searchState.checkInDate,
  //       checkOutDate: searchState.checkOutDate,
  //       cancellationPolicy: widget.accommodation.cancellationPolicy,
  //       checkInTime: widget.accommodation.checkInTime,
  //       isVerified: false,
  //     ),
  //   );
  // }
  @override
  void initState() {
    super.initState();

    final searchState = context.read<SearchBloc>().state;

    final pricingList = widget.room.pricingId?.pricing ?? [];
    pricingOptions = pricingList
        .map(
          (e) => {"price": e.price, "type": e.priceType.toLowerCase().trim()},
        )
        .toList();

    pricingOptions = {
      for (var e in pricingOptions) e["type"]: e,
    }.values.toList();

    final defaultPricing = pricingOptions.isNotEmpty
        ? pricingOptions.first
        : null;
    final bool taxEnabled = widget.accommodation.tax ?? false;
    final double taxAmount = (widget.accommodation.taxAmount ?? 0).toDouble();
    // final double taxPercentage =
    //     (widget.accommodation.taxPercentage ?? 0).toDouble(); // if available
    context.read<PaymentBloc>().add(
      PaymentInitialized(
        pricePerNight: defaultPricing?["price"] ?? 0,
        stayType: widget.accommodation.propertyType ?? "",
        pricingType: defaultPricing?["type"] ?? "per day",
        checkInDate: searchState.checkInDate,
        checkOutDate: searchState.checkOutDate,
        cancellationPolicy: widget.accommodation.cancellationPolicy,
        checkInTime: widget.accommodation.checkInTime,
        isVerified: widget.accommodation.isverified ?? false,
        taxEnabled: taxEnabled,
        taxAmount: taxAmount,

        maxAdults: widget.room.bedsAvailable,
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _openDatePicker(BuildContext ctx, PaymentState ps) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final checkIn = ps.checkInDate ?? today;

    final checkOut = ps.stayType.toLowerCase().contains("Hostel".toLowerCase())
        ? DateTime(checkIn.year, checkIn.month + 1, checkIn.day)
        : (ps.checkOutDate ?? today.add(const Duration(days: 1)));

    final initial = DateTimeRange(
      start: checkIn,
      end: checkOut,
    );

    final result = await showModalBottomSheet<DateTimeRange>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          DateRangePickerSheet(initialRange: initial, type: ps.stayType),
    );

    if (result != null && ctx.mounted) {
      final newCheckIn = result.start;

      final newCheckOut =
          ps.stayType.toLowerCase().contains("Hostel".toLowerCase())
          ? DateTime(newCheckIn.year, newCheckIn.month + 1, newCheckIn.day)
          : result.end;

      ctx.read<PaymentBloc>().add(
        PaymentDateRangeUpdated(
          DateTimeRange(start: newCheckIn, end: newCheckOut),
        ),
      );

      ctx.read<SearchBloc>().add(
        UpdateSearchParams(checkInDate: newCheckIn, checkOutDate: newCheckOut),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMonthly(PaymentState ps) =>
        ps.pricingType.toLowerCase().contains('month');

    bool isWeekly(PaymentState ps) =>
        ps.pricingType.toLowerCase().contains('week');

    bool isDaily(PaymentState ps) =>
        ps.pricingType.toLowerCase().contains('day');
    return BlocListener<PaymentBloc, PaymentState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (ctx, state) {
        if (state.status == PaymentStatus.success) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Booking confirmed! 🎉'),
              backgroundColor: Color(0xFF5B4FCF),
            ),
          );
          context.go(RouteList.paymentsuccess);
        }

        if (state.status == PaymentStatus.failure &&
            state.errorMessage != null) {
          ctx.read<PaymentBloc>().add(PaymentReset());
          showFailureDialog(ctx, state.errorMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Booking Summary',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (ctx, ps) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle(
                          title: 'Stay Duration',
                          trailing: isMonthly(ps)
                              ? _Badge(label: '30 Days Fixed')
                              : isWeekly(ps)
                              ? _Badge(label: 'Week Based')
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _StayDurationRow(
                          ps: ps,
                          onTap: () => _openDatePicker(ctx, ps),
                        ),
                        if (ps.dateError != null) ...[
                          const SizedBox(height: 6),
                          _ErrorText(ps.dateError!),
                        ],

                        const SizedBox(height: 24),

                        _GuestCounter(
                          label: 'Adults',
                          count: ps.adults,
                          max: widget.room.bedsAvailable,
                          onDecrement: () => ctx.read<PaymentBloc>().add(
                            const PaymentAdultsChanged(-1),
                          ),
                          onIncrement: () => ctx.read<PaymentBloc>().add(
                            const PaymentAdultsChanged(1),
                          ),
                        ),
                        const Divider(color: Color(0xFFF0F0F0)),
                        _PricingDropdown(ps: ps, options: pricingOptions),
                        // _GuestCounter(
                        //   label: 'Children',
                        //   count: ps.children,
                        //   onDecrement: () => ctx.read<PaymentBloc>().add(
                        //     const PaymentChildrenChanged(-1),
                        //   ),
                        //   onIncrement: () => ctx.read<PaymentBloc>().add(
                        //     const PaymentChildrenChanged(1),
                        //   ),
                        // ),
                        const SizedBox(height: 24),

                        const _SectionTitle(title: 'Payment Details'),
                        const SizedBox(height: 12),
                        _PaymentDetails(ps: ps),

                        const SizedBox(height: 28),

                        _GuestInfoSection(
                          ps: ps,
                          nameCtrl: _nameCtrl,
                          emailCtrl: _emailCtrl,
                          phoneCtrl: _phoneCtrl,
                          onNameChanged: (v) => ctx.read<PaymentBloc>().add(
                            PaymentFullNameChanged(v),
                          ),
                          onEmailChanged: (v) => ctx.read<PaymentBloc>().add(
                            PaymentEmailChanged(v),
                          ),
                          onPhoneChanged: (v) => ctx.read<PaymentBloc>().add(
                            PaymentPhoneChanged(v),
                          ),
                          onGenderChanged: (v) => ctx.read<PaymentBloc>().add(
                            PaymentGenderChanged(v),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _TermsSection(
                          ps: ps,
                          onToggle: () => ctx.read<PaymentBloc>().add(
                            const PaymentTermsToggled(),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                _CheckoutButton(
                  isLoading:
                      ps.status == PaymentStatus.creatingOrder ||
                      ps.status == PaymentStatus.verifying,
                  enabled:
                      ps.canCheckout &&
                      ps.status != PaymentStatus.creatingOrder &&
                      ps.status != PaymentStatus.verifying,
                  onTap: () {
                    final bloc = ctx.read<PaymentBloc>();

                    bloc.add(PaymentFullNameChanged(_nameCtrl.text));
                    bloc.add(PaymentEmailChanged(_emailCtrl.text));
                    bloc.add(PaymentPhoneChanged(_phoneCtrl.text));

                    bloc.add(
                      PaymentCheckoutRequested(
                        propertyId:
                            widget.room.pricingId?.accommodationId ?? "",
                        roomId: widget.room.pricingId?.roomId ?? "",
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5B4FCF),
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String text;
  const _ErrorText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.redAccent, fontSize: 12),
    );
  }
}

class _StayDurationRow extends StatelessWidget {
  final PaymentState ps;
  final VoidCallback onTap;
  const _StayDurationRow({required this.ps, required this.onTap});

  String _fmt(DateTime? d) =>
      d != null ? DateFormat('MMM dd, yyyy').format(d) : '-- / -- / ----';

  bool get isMonthly => ps.pricingType.toLowerCase().contains('month');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DateCard(
            label: 'Check - In',
            value: _fmt(ps.checkInDate),
            onTap: onTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateCard(
            label: 'Check - Out',
            value: _fmt(ps.checkOutDate),
            onTap: onTap,
            locked: isMonthly, // ✅ fixed
          ),
        ),
      ],
    );
  }
}

class _DateCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool locked;

  const _DateCard({
    required this.label,
    required this.value,
    required this.onTap,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: locked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: locked ? const Color(0xFFF9F9F9) : const Color(0xFFF4F4FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: locked ? const Color(0xFFE8E8E8) : const Color(0xFFE0DFF5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              locked
                  ? Icons.lock_outline_rounded
                  : Icons.calendar_month_outlined,
              size: 16,
              color: locked ? const Color(0xFFAAAAAA) : const Color(0xFF5B4FCF),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: locked
                          ? const Color(0xFFAAAAAA)
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestCounter extends StatelessWidget {
  final String label;
  final int count;
  final int max; // 🔥 NEW
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _GuestCounter({
    required this.label,
    required this.count,
    required this.max,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final canIncrement = count < max;
    final canDecrement = count > 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),

          // 🔽 DECREMENT
          _CounterBtn(
            icon: Icons.remove,
            onTap: canDecrement ? onDecrement : null,
            disabled: !canDecrement,
          ),

          SizedBox(
            width: 34,
            child: Center(
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),

          // 🔼 INCREMENT
          _CounterBtn(
            icon: Icons.add,
            onTap: canIncrement ? onIncrement : null,
            filled: true,
            disabled: !canIncrement,
          ),
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;
  final bool disabled;

  const _CounterBtn({
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: disabled
              ? const Color(0xFFE5E7EB) // 🔥 disabled color
              : filled
              ? const Color(0xFF5B4FCF)
              : const Color(0xFFF4F4FB),
          shape: BoxShape.circle,
          border: filled || disabled
              ? null
              : Border.all(color: const Color(0xFFD0CEF0), width: 1.2),
        ),
        child: Icon(
          icon,
          size: 16,
          color: disabled
              ? const Color(0xFF9CA3AF)
              : filled
              ? Colors.white
              : const Color(0xFF5B4FCF),
        ),
      ),
    );
  }
}

class _PaymentDetails extends StatelessWidget {
  final PaymentState ps;
  const _PaymentDetails({required this.ps});

  @override
  Widget build(BuildContext context) {
    final type = ps.pricingType.toLowerCase();

    String label;

    if (type.contains('day')) {
      label = ps.totalNights > 0
          ? 'Total: ${ps.totalNights} Night${ps.totalNights > 1 ? 's' : ''} × ${ps.totalGuests} Guest${ps.totalGuests > 1 ? 's' : ''}'
          : 'Total (select dates)';
    } else if (type.contains('week')) {
      final weeks = (ps.totalNights / 7).ceil();
      label =
          'Total: $weeks Week${weeks > 1 ? 's' : ''} × ${ps.totalGuests} Guest${ps.totalGuests > 1 ? 's' : ''}';
    } else if (type.contains('month')) {
      final months = ((ps.totalNights == 0 ? 30 : ps.totalNights) / 30).ceil();
      label =
          'Total: $months Month${months > 1 ? 's' : ''} × ${ps.totalGuests} Guest${ps.totalGuests > 1 ? 's' : ''}';
    } else {
      label = 'Total';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _PriceRow(label: label, amount: ps.roomTotal),
          const SizedBox(height: 8),
          // _PriceRow(label: "Cleaning Fee", amount: ps.cleaningFee),
          // const SizedBox(height: 8),
          // _PriceRow(label: "Service Fee", amount: ps.serviceFee),
          const SizedBox(height: 8),
          if (ps.taxEnabled)
            _PriceRow(
              label: ps.taxAmount > 0
                  ? "Tax (${ps.taxAmount.toStringAsFixed(0)}%)"
                  : "Tax",
              amount: ps.taxTotal,
            ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFDDDDDD)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Total Payment:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Text(
                '₹${ps.grandTotal.toStringAsFixed(0)}/-',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5B4FCF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  const _PriceRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
        ),
        const Spacer(),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _GuestInfoSection extends StatelessWidget {
  final PaymentState ps;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onGenderChanged;

  const _GuestInfoSection({
    required this.ps,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 20,
                  color: Color(0xFF2DB89A),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Guest Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Row 1: Full Name + Gender
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FormField(
                  label: 'Full Name',
                  required: true,
                  controller: nameCtrl,
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person_outline_rounded,
                  error: ps.fullNameError,
                  onChanged: onNameChanged,
                  inputType: TextInputType.name,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _GenderField(
                  selected: ps.gender,
                  onChanged: onGenderChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Row 2: Email + Phone
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FormField(
                  label: 'Email Address',
                  required: true,
                  controller: emailCtrl,
                  hint: 'your@email.com',
                  prefixIcon: Icons.mail_outline_rounded,
                  error: ps.emailError,
                  onChanged: onEmailChanged,
                  inputType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _FormField(
                  label: 'Phone Number',
                  required: true,
                  controller: phoneCtrl,
                  hint: 'your mobile number',
                  prefixIcon: Icons.phone_outlined,
                  error: ps.phoneError,
                  onChanged: onPhoneChanged,
                  inputType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
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

class _FormField extends StatelessWidget {
  final String label;
  final bool required;
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final String? error;
  final ValueChanged<String> onChanged;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;

  const _FormField({
    required this.label,
    required this.required,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    required this.onChanged,
    this.error,
    this.inputType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
            children: required
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
            prefixIcon: Icon(prefixIcon, size: 18, color: Color(0xFF9CA3AF)),
            errorText: error,
            errorStyle: const TextStyle(fontSize: 11),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF5B4FCF),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderField extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _GenderField({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const options = ['Male', 'Female', 'Other'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Gender',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: options.map((opt) {
            final isSelected = selected == opt;
            return GestureDetector(
              onTap: () => onChanged(opt),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2DB89A)
                              : const Color(0xFFCCCCCC),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2DB89A),
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      opt,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFF6B7280),
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TermsSection extends StatelessWidget {
  final PaymentState ps;
  final VoidCallback onToggle;
  const _TermsSection({required this.ps, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final cancellation = ps.cancellationPolicy ?? 'before24hrs';
    final checkInTime = ps.checkInTime ?? 'NA';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Terms & Conditions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 14),
          _TermsPoint(label: 'Cancellation Policy:', value: cancellation),
          const SizedBox(height: 8),
          const _TermsPoint(label: 'Tax:', value: 'No tax'),
          const SizedBox(height: 8),
          _TermsPoint(
            label: 'Verified:',
            value: ps.isVerified ? '✓ Property is verified' : '✗ Not verified',
          ),
          const SizedBox(height: 8),
          _TermsPoint(label: 'Check-in Time:', value: checkInTime),
          const SizedBox(height: 16),

          // Checkbox row
          GestureDetector(
            onTap: onToggle,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: ps.termsAccepted
                          ? const Color(0xFF5B4FCF)
                          : const Color(0xFFCCCCCC),
                      width: 1.8,
                    ),
                    color: ps.termsAccepted
                        ? const Color(0xFF5B4FCF)
                        : Colors.transparent,
                  ),
                  child: ps.termsAccepted
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'I agree to the Terms & Conditions, Cancellation Policy, '
                    'and confirm that all the information provided is accurate. '
                    'I understand that $cancellation.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF555555),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsPoint extends StatelessWidget {
  final String label;
  final String value;
  const _TermsPoint({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•  ',
          style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
            children: [
              TextSpan(
                text: '$label ',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  final bool isLoading;
  final bool enabled;
  final VoidCallback onTap;

  const _CheckoutButton({
    required this.isLoading,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: GestureDetector(
        onTap: (enabled && !isLoading) ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFF5B4FCF) : const Color(0xFFB0ABDF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

void showFailureDialog(BuildContext context, String message) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Failure",
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("😔", style: TextStyle(fontSize: 50)),
                const SizedBox(height: 10),
                const Text(
                  "Payment Failed",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Try Again"),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: Curves.easeOutBack.transform(animation.value),
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}

class _PricingDropdown extends StatelessWidget {
  final PaymentState ps;
  final List<Map<String, dynamic>> options;

  const _PricingDropdown({required this.ps, required this.options});

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Pricing",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0DFF5)),
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF4F4FB),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: options.any((e) => e["type"] == ps.pricingType)
                  ? ps.pricingType
                  : options.first["type"],
              isExpanded: true,
              items: options.map((e) {
                return DropdownMenuItem<String>(
                  value: e["type"],
                  child: Text("${e["type"].toUpperCase()}  (₹${e["price"]})"),
                );
              }).toList(),
              onChanged: (value) {
                final selected = options.firstWhere((e) => e["type"] == value);

                context.read<PaymentBloc>().add(
                  PaymentPricingChanged(
                    selected["type"],
                    (selected["price"] as num).toDouble(),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

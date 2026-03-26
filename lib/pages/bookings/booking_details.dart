import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/bookings/bookings_bloc.dart';
import 'package:indhostels/data/models/bookings/booking_details_res.dart';
import 'package:indhostels/pages/acommadtion/acommadation_detailes.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/utils/shimmers/booking_detailes_screen.dart';
import 'package:indhostels/utils/theame/app_themes.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingsBloc>().add(FetchBookingDetailes(widget.bookingId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingsBloc, BookingsState>(
      listenWhen: (p, c) =>
          p.invoiceSuccess != c.invoiceSuccess ||
          p.invoiceError != c.invoiceError,
      listener: (context, state) async {
        if (state.invoiceSuccess && state.invoiceBytes != null) {
          try {
            await saveToDownloads(state.invoiceBytes!);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invoice downloaded successfully")),
            );

            context.read<BookingsBloc>().add(InvoiceReset());
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        }

        if (state.invoiceError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.invoiceError!)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A2E),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Details',
            style: TextStyle(
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocBuilder<BookingsBloc, BookingsState>(
          builder: (context, state) {
            if (state.bookingsDetailsLoading) {
              return const BookingDetailShimmer();
            }

            if (state.bookingsDetailsError != null) {
              return _ErrorView(
                error: state.bookingsDetailsError!,
                onRetry: () {
                  context.read<BookingsBloc>().add(
                    FetchBookingDetailes(widget.bookingId),
                  );
                },
              );
            }

            if (state.bookingDetail == null) {
              return const Center(child: Text("No data found"));
            }

            final booking = state.bookingDetail!;
            final isTab = MediaQuery.of(context).size.width >= 600;

            return isTab
                ? _TabLayout(booking: booking)
                : _MobileLayout(booking: booking);
          },
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final BookingDetail booking;
  const _MobileLayout({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
            child: Cardwrapwer(
              child: Column(
                children: [
                  _HeaderCard(booking: booking),
                  const SizedBox(height: 12),
                  MapSection(
                    address: booking.accommodation.location.displayArea,
                    mapUrl: booking.accommodation.location.locationUrl ?? "",
                    r: R(MediaQuery.of(context).size.width),
                    screenWidth: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 12),
                  _BookingDetailsCard(booking: booking),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.topLeft,
                    child: _AmenitiesCard(booking: booking),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color.fromARGB(255, 195, 194, 194),
                  ),
                  const SizedBox(height: 12),
                  _PaymentCard(booking: booking),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
        _BottomBar(booking: booking),
      ],
    );
  }
}

class _TabLayout extends StatelessWidget {
  final BookingDetail booking;
  const _TabLayout({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _HeaderCard(booking: booking),
                      const SizedBox(height: 16),
                      MapSection(
                        address: booking.accommodation.location.displayArea,
                        mapUrl:
                            booking.accommodation.location.locationUrl ?? "",
                        r: R(MediaQuery.of(context).size.width),
                        screenWidth: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.topLeft,
                        child: _AmenitiesCard(booking: booking),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _BookingDetailsCard(booking: booking),
                      const SizedBox(height: 16),
                      const Divider(),
                      _PaymentCard(booking: booking),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _BottomBar(booking: booking),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final BookingDetail booking;
  const _HeaderCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking ID : ${booking.shortBookingId}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text(
              'Status : ',
              style: TextStyle(fontSize: 12, color: Color(0xFF555555)),
            ),
            Text(
              _statusLabel(booking.status),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _statusColor(booking.status),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: booking.primaryImage,
                width: 78,
                height: 70,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 78,
                  height: 70,
                  color: const Color(0xFFF0EEFF),
                  child: const Icon(
                    Icons.home_work_outlined,
                    color: Color(0xFF5B4BCC),
                  ),
                ),
                errorWidget: (c, e, s) => Container(
                  width: 78,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EEFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.home_work_outlined,
                    color: Color(0xFF5B4BCC),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.accommodation.propertyName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: Color(0xFF888888),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          booking.accommodation.location.displayArea,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF888888),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  const SizedBox(height: 5),
                  // Price
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: booking.formattedRoomPrice,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
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
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                const SizedBox(width: 3),
                Text(
                  booking.accommodation.rating?.toStringAsFixed(1) ?? '4.0',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _statusLabel(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      default:
        return s[0].toUpperCase() + s.substring(1);
    }
  }

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFFFA726);
      case 'cancelled':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}

class _BookingDetailsCard extends StatelessWidget {
  final BookingDetail booking;
  const _BookingDetailsCard({required this.booking});

  static String _fmt(DateTime d) => DateFormat('dd MMM, yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Booking Details',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 14),
        _DetailRow(
          icon: Icons.calendar_month_outlined,
          label: 'Dates',
          value:
              '${_fmt(booking.checkInDate)} – ${_fmt(booking.checkOutDate)}'
              ' (${booking.days})',
        ),
        const _RowDivider(),
        _DetailRow(
          icon: Icons.people_outline,
          label: 'Guests',
          value: '${booking.guests} guest(s)',
        ),
        const _RowDivider(),
        _DetailRow(
          icon: Icons.bed_outlined,
          label: 'Room type',
          value: booking.roomType,
        ),
        const _RowDivider(),
        _DetailRow(
          icon: Icons.policy_outlined,
          label: 'Cancellation Policy',
          value: booking.accommodation.cancellationPolicy,
        ),
        const _RowDivider(),
        _DetailRow(
          icon: Icons.person_outline,
          label: 'Host',
          value:
              '${booking.accommodation.hostDetails.hostName}  ·  ${booking.accommodation.hostDetails.hostContact}',
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF666666)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
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

class _RowDivider extends StatelessWidget {
  const _RowDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0));
}

class _AmenitiesCard extends StatelessWidget {
  final BookingDetail booking;
  const _AmenitiesCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final amenities = booking.room.amenities;
    if (amenities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Room Amenities',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
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
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final BookingDetail booking;
  const _PaymentCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final p = booking.payment;
    final tax = p.tax;
    final discount = booking.discountAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: p.isPaid
                    ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                    : const Color(0xFFFFA726).withValues(alpha: 0.1),
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
        const SizedBox(height: 14),

        _PayRow(
          label: '${booking.formattedRoomPrice} × ${booking.days}',
          value: '₹${booking.roomPrice.toStringAsFixed(0)}',
        ),

        if (tax > 0) ...[
          const SizedBox(height: 8),
          _PayRow(label: 'Tax & Fees', value: '₹${tax.toStringAsFixed(0)}'),
        ],

        if (discount > 0) ...[
          const SizedBox(height: 8),
          _PayRow(
            label: booking.couponCode.isNotEmpty
                ? 'Discount (${booking.couponCode})'
                : 'Discount',
            value: '-₹${discount.toStringAsFixed(0)}',
            valueColor: const Color(0xFF4CAF50),
          ),
        ],

        const SizedBox(height: 10),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        const SizedBox(height: 10),

        _PayRow(
          label: 'Total Payment:',
          value: '₹${booking.bookingAmount.toStringAsFixed(0)}/-',
          isBold: true,
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Icon(
              p.isOnline ? Icons.credit_card : Icons.money,
              size: 14,
              color: const Color(0xFF888888),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                p.isOnline
                    ? 'Paid via Online · ${p.paymentInfo.paymentId}'
                    : 'Cash on Check-in',
                style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 14,
              color: Color(0xFF888888),
            ),
            const SizedBox(width: 6),
            Text(
              'Invoice: ${p.invoice}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
            ),
          ],
        ),
      ],
    );
  }
}

class _PayRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _PayRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? const Color(0xFF1A1A2E) : const Color(0xFF555555),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color:
                valueColor ??
                (isBold ? const Color(0xFF1A1A2E) : const Color(0xFF1A1A2E)),
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final BookingDetail booking;
  const _BottomBar({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Cancel Buton
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF5B4BCC), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 46),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF5B4BCC),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: BlocBuilder<BookingsBloc, BookingsState>(
              builder: (context, state) {
                final isLoading = state.invoiceLoading;

                return ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<BookingsBloc>().add(
                            InvoiceDownloadRequested(
                              bookingId: booking.bookingId,
                            ),
                          );
                        },
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.download_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                  label: Text(
                    isLoading ? "Downloading..." : "Invoice",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 46),
                    elevation: 0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load booking details',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class Cardwrapwer extends StatelessWidget {
  final Widget child;
  const Cardwrapwer({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}

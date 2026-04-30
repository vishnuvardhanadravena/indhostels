// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/bookings/bookings_bloc.dart';
import 'package:indhostels/data/models/bookings/booking_res.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/shimmers/booking_card_shimmer.dart';
import 'package:indhostels/utils/theame/app_themes.dart';
import 'package:indhostels/utils/widgets/authwidgts.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final ScrollController _bookedController = ScrollController();
  final ScrollController _historyController = ScrollController();
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    context.read<BookingsBloc>().add(const FetchBookings(page: 1, limit: 10));
    context.read<BookingsBloc>().add(
      const FetchBookingsHistory(page: 1, limit: 10),
    );

    _bookedController.addListener(_onBookedScroll);
    _historyController.addListener(_onHistoryScroll);
  }

  // ✅ BOOKED SCROLL
  void _onBookedScroll() {
    if (_bookedController.position.pixels >=
        _bookedController.position.maxScrollExtent - 200) {
      final bloc = context.read<BookingsBloc>();
      final state = bloc.state;

      if (!state.bookingsMoreLoading && !state.hasReachedMax) {
        bloc.add(FetchBookings(page: state.currentPage + 1, limit: 10));
      }
    }
  }

  // ✅ HISTORY SCROLL
  void _onHistoryScroll() {
    if (_historyController.position.pixels >=
        _historyController.position.maxScrollExtent - 200) {
      final bloc = context.read<BookingsBloc>();
      final state = bloc.state;

      if (!state.bookingshistoryMoreLoading && !state.historyhasReachedMax) {
        bloc.add(
          FetchBookingsHistory(page: state.historycurrentPage + 1, limit: 10),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        return MyBookingsScreen(
          onRefresh: () async {
            _selectedTab == 0
                ? context.read<BookingsBloc>().add(
                    const FetchBookings(page: 1, limit: 10),
                  )
                : context.read<BookingsBloc>().add(
                    const FetchBookingsHistory(page: 1, limit: 10),
                  );
          },
          selectedTab: _selectedTab,
          onTabChanged: (index) {
            setState(() {
              _selectedTab = index;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (index == 0 && _bookedController.hasClients) {
                _bookedController.jumpTo(0);
              } else if (index == 1 && _historyController.hasClients) {
                _historyController.jumpTo(0);
              }
            });
          },
          bookings: state.bookings,
          bookingshistory: state.bookingshistory,
          isLoading: _selectedTab == 0
              ? state.bookingsLoading
              : state.bookingsHistoryLoading,
          scrollController: _selectedTab == 0
              ? _bookedController
              : _historyController,
          isLoadingMore: _selectedTab == 0
              ? state.bookingsMoreLoading
              : state.bookingshistoryMoreLoading,
        );
      },
    );
  }
}

class MyBookingsScreen extends StatefulWidget {
  final List<BookingModel> bookings;
  final List<BookingModel> bookingshistory;
  final bool isLoading;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final int selectedTab;
  final Function(int) onTabChanged;
  final Future<void> Function()? onRefresh;

  const MyBookingsScreen({
    super.key,
    required this.bookingshistory,
    required this.bookings,
    required this.scrollController,
    this.isLoading = false,
    this.isLoadingMore = false,
    required this.selectedTab,
    required this.onTabChanged,
    this.onRefresh,
  });

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<BookingModel> get _booked => widget.bookings
      .where(
        (b) => b.checkOut.isAfter(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      )
      .toList();

  List<BookingModel> get _history => widget.bookingshistory;
  // .where((b) => b.checkOut.isBefore(DateTime.now()))
  // .toList();

  List<BookingModel> get _current =>
      widget.selectedTab == 0 ? _booked : _history;

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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                itemCount: 6,
                itemBuilder: (context, index) => const BookingCardSkeleton(),
              ),
            )
          else if (_current.isEmpty)
            _buildEmpty(isTab)
          else
            Expanded(
              child: isTab ? _buildMobileList(isTab) : _buildMobileList(isTab),
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
              // '${widget.bookings.length} Total',
              "total",
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
      selectedIndex: widget.selectedTab,
      tabs: ['Booked (${_booked.length})', 'History (${_history.length})'],
      onTabSelected: widget.onTabChanged,
    ),
  );

  Widget _buildMobileList(bool isTab) => RefreshIndicator(
    color: AppColors.primary,
    onRefresh: () async => widget.onRefresh?.call(),
    child: ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _current.length + (widget.isLoadingMore ? 1 : 0),

      itemBuilder: (_, i) {
        if (i >= _current.length) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return BookingCard(
          booking: _current[i],
          isTab: isTab,
          isHistory: widget.selectedTab == 1,
          onPrimaryAction: () => _handlePrimary(_current[i]),
          onSecondaryAction: () => _handleSecondary(_current[i]),
        );
      },
    ),
  );

  // Widget _buildTabGrid(bool isTab) => RefreshIndicator(
  //   color: AppColors.primary,
  //   onRefresh: () async => widget.onRefresh?.call(),
  //   child: GridView.builder(
  //     controller: widget.scrollController,
  //     padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 20,
  //       mainAxisSpacing: 4,
  //       childAspectRatio: 1.2,
  //     ),
  //     itemCount: _current.length + (widget.isLoadingMore ? 1 : 0),
  //     itemBuilder: (_, i) {
  //       if (i >= _current.length) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //       return BookingCard(
  //         booking: _current[i],
  //         isTab: isTab,
  //         isHistory: widget.selectedTab == 1,
  //         onPrimaryAction: () => _handlePrimary(_current[i]),
  //         onSecondaryAction: () => _handleSecondary(_current[i]),
  //       );
  //     },
  //   ),
  // );

  Widget _buildEmpty(bool isTab) => Expanded(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.selectedTab == 0
                ? Icons.hotel_outlined
                : Icons.history_rounded,
            size: isTab ? 72 : 56,
            color: const Color(0xFFD0C8FF),
          ),
          const SizedBox(height: 16),
          Text(
            widget.selectedTab == 0 ? 'No active bookings' : 'No past bookings',
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

  void _handlePrimary(BookingModel booking) {
    if (widget.selectedTab == 0) {
      context.push(
        RouteList.bookingDetails,
        extra: {"bookingId": booking.bookingId},
      );
    } else {
      context.push(
        RouteList.accommodationDetails,
        extra: {"id": booking.accommodation.id},
      );
    }
  }

  void _handleSecondary(BookingModel booking) {
    if (widget.selectedTab == 0) {
      _showCancelDialog(booking);
    } else {
      context.push(RouteList.updatereviews, extra: {"booking": booking});
    }
  }

  void _showCancelDialog(BookingModel booking) {
    final outerContext = context; // ✅ Capture before dialog opens

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocConsumer<BookingsBloc, BookingsState>(
          listener: (_, state) {
            final errorMessage = state.cancelError;
            if (state.cancelSuccess) {
              if (Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop();
              }
              AppToast.success('Booking cancelled successfully');
              outerContext.read<BookingsBloc>().add(
                const FetchBookings(page: 1, limit: 10),
              );
            }
            if (errorMessage != null) {
              if (Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop();
              }
              showDialog(
                context: outerContext,
                builder: (ctx) => AlertDialog(
                  title: const Text("Cancellation Failed"),
                  content: Text(errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                  onPressed: state.cancelLoading
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop();
                        },
                  child: const Text(
                    'Keep',
                    style: TextStyle(color: Color(0xFF5B4BCC)),
                  ),
                ),
                ElevatedButton(
                  onPressed: state.cancelLoading
                      ? null
                      : () {
                          context.read<BookingsBloc>().add(
                            CancelBookingRequested(bookingId: booking.id),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: state.cancelLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

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
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          // const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          _buildHotelInfo(),
          // const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final shortId = booking.bookingId.replaceFirst('BOKindhostels', '');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HotelImageCard(
            imageUrl: booking.accommodation.imageUrls.first,
            width: isTab ? 100 : 84,
            height: isTab ? 90 : 82,
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
                          color: const Color.fromARGB(
                            233,
                            26,
                            34,
                            126,
                          ).withValues(alpha: 0.1),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Color(0xFF888888),
                    ),
                    const SizedBox(width: 4),

                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            booking.locationDisplay,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),

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
                    ),
                  ],
                ),
                // const SizedBox(height: 4),
                // Text(
                //   booking.roomType,
                //   style: const TextStyle(
                //     fontSize: 11,
                //     color: Color(0xFF888888),
                //   ),
                // ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
            : const Color(0xFFFFA726).withValues(alpha: 0.1),
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
        color: status.color.withValues(alpha: 0.1),
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
                backgroundColor: AppColors.primary,
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
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: Color(0xFF5B4BCC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _buildChild(AppColors.primary),
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
        errorBuilder: (c, e, s) => Container(
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
        Icon(icon, size: isTab ? 20 : 16, color: AppColors.primary),
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

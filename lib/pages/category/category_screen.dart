import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/Serach/search_bloc.dart';
import 'package:indhostels/bloc/accommodation/accommodation_bloc.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/widgets/app_hostel_card.dart';
import 'package:indhostels/utils/widgets/wisth_listbutton.dart';
import 'package:intl/intl.dart';

const _kPrimary = Color(0xFF4F46E5);
const _kPrimaryLight = Color(0xFFEEEDFB);
const _kText = Color(0xFF1A1A2E);
const _kSubText = Color(0xFF6B7280);
const _kCardBg = Colors.white;
const _kBg = Color(0xFFF7F8FC);

class HotelsScreen extends StatefulWidget {
  final String title;

  const HotelsScreen({super.key, required this.title});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final type = widget.title == "Hostel"
          ? "hostels"
          : widget.title == "PG"
          ? "pgs"
          : "hotel";

      context.read<AccommodationBloc>().add(
        LikedAcommodationRequested(type: type),
      );
    });
  }

  String _formatDate(DateTime d) => DateFormat('dd MMM, yy').format(d);

  String _formatApiDate(DateTime d) {
    return DateFormat('yyyy-MM-dd').format(d);
  }

  Future<void> _openDatePicker(
    BuildContext context,
    DateTimeRange range,
  ) async {
    final result = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DateRangePickerSheet(initialRange: range),
    );

    if (result != null) {
      context.read<SearchBloc>().add(
        UpdateSearchParams(checkInDate: result.start, checkOutDate: result.end),
      );
    }
  }

  Future<void> _openCityPicker(
    BuildContext context,
    String selectedCity,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CityPickerSheet(
        selected: selectedCity,
        onSelect: (city) {
          context.read<SearchBloc>().add(UpdateSearchParams(city: city));
        },
      ),
    );
  }

  void _onSearch(BuildContext context, SearchState state) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final checkIn = state.checkInDate ?? today;
    final checkOut = state.checkOutDate ?? today.add(const Duration(days: 5));
    final city = state.city ?? "Hyderabad";

    context.read<SearchBloc>().add(
      UpdateSearchParams(
        city: city,
        checkInDate: checkIn,
        checkOutDate: checkOut,
      ),
    );

    debugPrint("City: $city");
    debugPrint("CheckIn: ${DateFormat('yyyy-MM-dd').format(checkIn)}");
    debugPrint("CheckOut: ${DateFormat('yyyy-MM-dd').format(checkOut)}");

    context.pushNamed(RouteList.hotelListing);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final start = state.checkInDate ?? DateTime.now();
        final end =
            state.checkOutDate ?? DateTime.now().add(const Duration(days: 1));

        final range = DateTimeRange(start: start, end: end);

        final nights = range.end.difference(range.start).inDays;

        return Scaffold(
          backgroundColor: _kBg,
          appBar: AppBar(
            backgroundColor: _kCardBg,
            elevation: 0,
            centerTitle: true,
            leading: const BackButton(color: _kText),
            title: Text(
              widget.title,
              style: const TextStyle(
                color: _kText,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              final hPad = isWide ? 32.0 : 16.0;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Find Your Stay'),
                    const SizedBox(height: 10),

                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isWide ? 520 : double.infinity,
                        ),
                        child: SearchCard(
                          city: state.city ?? "hyderabad",
                          dateRange: range,
                          nights: nights,
                          formatDate: _formatDate,
                          onCityTap: () =>
                              _openCityPicker(context, state.city ?? ""),
                          onDateTap: () => _openDatePicker(context, range),
                          onSearch: () => _onSearch(context, state),
                          isSearching: state.searchLoading,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _SectionTitle('Featured Deals'),
                    const SizedBox(height: 10),
                    BlocConsumer<AccommodationBloc, AccommodationState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state.lIkedAcommodationsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.lIkedAcommodationsError != null) {
                          return Center(
                            child: Text(
                              state.lIkedAcommodationsError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final deals = state.lIkedAcommodations ?? [];

                        if (deals.isEmpty) {
                          return const Center(child: Text("No Hotels Found"));
                        }

                        return SizedBox(
                          height: 260,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: deals.length,
                            itemBuilder: (context, index) {
                              final deal = deals[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 180,
                                    maxWidth: 240,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      context.push(
                                        RouteList.accommodationDetails,
                                        extra: {"id": deal.sId},
                                      );
                                    },
                                    child: AppHotelCard(
                                      trailingWidget: WishlistButton(
                                        accommodationId: deal.sId??"",
                                      ),
                                      amenities: const [],
                                      imageUrl:
                                          deal.imagesUrl?.isNotEmpty == true
                                          ? deal.imagesUrl!.first
                                          : null,
                                      location: deal.location?.area ?? '',
                                      price:
                                          deal
                                              .pricingData
                                              ?.first
                                              .pricing
                                              ?.first
                                              .price
                                              ?.toString() ??
                                          '',
                                      rating: deal.averageRating ?? 0,
                                      title: deal.propertyName ?? '',
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SearchCard extends StatelessWidget {
  final String city;
  final DateTimeRange dateRange;
  final int nights;
  final String Function(DateTime) formatDate;
  final VoidCallback onCityTap, onDateTap, onSearch;
  final bool isSearching;

  const SearchCard({
    required this.city,
    required this.dateRange,
    required this.nights,
    required this.formatDate,
    required this.onCityTap,
    required this.onDateTap,
    required this.onSearch,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _FieldRow(
            icon: Icons.location_on_outlined,
            onTap: onCityTap,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    city,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: _kText,
                    ),
                  ),
                ),
                _NearMeChip(onTap: onCityTap),
              ],
            ),
          ),

          Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),

          _FieldRow(
            icon: Icons.calendar_today_outlined,
            onTap: onDateTap,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${formatDate(dateRange.start)} – ${formatDate(dateRange.end)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: _kText,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _kBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$nights Night${nights == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: _kSubText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Search',
              isLoading: isSearching,
              onPressed: isSearching ? null : onSearch,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Choose your city, dates and guests to find available options',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: _kSubText),
          ),
        ],
      ),
    );
  }
}

class DateRangePickerSheet extends StatefulWidget {
  final DateTimeRange initialRange;
  const DateRangePickerSheet({super.key, required this.initialRange});

  @override
  State<DateRangePickerSheet> createState() => _DateRangePickerSheetState();
}

class _DateRangePickerSheetState extends State<DateRangePickerSheet> {
  late DateTime _start;
  DateTime? _end;

  static const int _totalMonths = 24;
  late final DateTime _firstMonth;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange.start;
    _end = widget.initialRange.end;
    final now = DateTime.now();
    _firstMonth = DateTime(now.year, now.month);
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_end != null || day.isBefore(_start)) {
        _start = day;
        _end = null;
      } else if (day.isAfter(_start)) {
        _end = day;
      } else {
        _start = day;
        _end = null;
      }
    });
  }

  int get _nights => _end != null ? _end!.difference(_start).inDays : 0;

  bool _isStart(DateTime d) => _same(d, _start);
  bool _isEnd(DateTime d) => _end != null && _same(d, _end!);
  bool _inRange(DateTime d) =>
      _end != null && d.isAfter(_start) && d.isBefore(_end!);
  static bool _same(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    // final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            margin: EdgeInsets.all(0),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Select Dates',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _kText,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 20, color: _kText),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 14),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _kSubText,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 0.5),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _totalMonths,
              itemBuilder: (_, index) {
                final month = DateTime(
                  _firstMonth.year,
                  _firstMonth.month + index,
                );
                return _MonthGrid(
                  month: month,
                  isStart: _isStart,
                  isEnd: _isEnd,
                  inRange: _inRange,
                  onDayTap: _onDayTap,
                  minDate: DateTime.now().subtract(const Duration(days: 1)),
                );
              },
            ),
          ),

          const Divider(height: 1, thickness: 0.5),

          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.18,
            // padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottomPad),
            child: Card(
              elevation: 4,
              margin: EdgeInsets.only(top: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _DateTile(label: 'Check – In', date: _start),
                        ),
                        Container(
                          width: 1,
                          height: 38,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _DateTile(
                            label: 'Check – Out',
                            date: _end,
                            placeholder: 'Select date',
                          ),
                        ),
                      ],
                    ),
                    if (_nights > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$_nights Night${_nights == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _kPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Apply',
                        isLoading: false,
                        onPressed: _end != null
                            ? () => Navigator.pop(
                                context,
                                DateTimeRange(start: _start, end: _end!),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final bool Function(DateTime) isStart;
  final bool Function(DateTime) isEnd;
  final bool Function(DateTime) inRange;
  final ValueChanged<DateTime> onDayTap;
  final DateTime minDate;

  const _MonthGrid({
    required this.month,
    required this.isStart,
    required this.isEnd,
    required this.inRange,
    required this.onDayTap,
    required this.minDate,
  });

  @override
  Widget build(BuildContext context) {
    final totalDays = DateTime(month.year, month.month + 1, 0).day;
    final offset = DateTime(month.year, month.month, 1).weekday - 1;
    final totalCells = offset + totalDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text(
          DateFormat('MMMM yyyy').format(month),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _kText,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 44,
            mainAxisSpacing: 2,
          ),
          itemCount: totalCells,
          itemBuilder: (_, i) {
            if (i < offset) return const SizedBox();
            final day = DateTime(month.year, month.month, i - offset + 1);
            final isPast = day.isBefore(minDate);
            final start = isStart(day);
            final end = isEnd(day);
            final range = inRange(day);
            final selected = start || end;

            return GestureDetector(
              onTap: isPast ? null : () => onDayTap(day),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (range || start || end)
                    Positioned.fill(
                      child: _RangeBg(
                        isStart: start,
                        isEnd: end,
                        inRange: range,
                      ),
                    ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: selected ? _kPrimary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: selected
                            ? Colors.white
                            : isPast
                            ? Colors.grey.shade400
                            : range
                            ? _kPrimary
                            : _kText,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _RangeBg extends StatelessWidget {
  final bool isStart, isEnd, inRange;
  const _RangeBg({
    required this.isStart,
    required this.isEnd,
    required this.inRange,
  });

  @override
  Widget build(BuildContext context) {
    if (!inRange && !isStart && !isEnd) return const SizedBox();
    BorderRadius? br;
    if (isStart) {
      br = const BorderRadius.horizontal(left: Radius.circular(10));
    } else if (isEnd) {
      br = const BorderRadius.horizontal(right: Radius.circular(10));
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: _kPrimaryLight, borderRadius: br),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final String placeholder;

  const _DateTile({
    required this.label,
    required this.date,
    this.placeholder = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _kSubText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date != null
                ? DateFormat('MMM d, yyyy').format(date!)
                : placeholder,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: date != null ? _kText : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

class CityPickerSheet extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const CityPickerSheet({required this.selected, required this.onSelect});

  @override
  State<CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<CityPickerSheet> {
  final _cities = [
    'Hyderabad',
    'Bangalore',
    'Mumbai',
    'Delhi',
    'Chennai',
    'Pune',
    'Kolkata',
    'Ahmedabad',
    'Jaipur',
    'Goa',
  ];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _cities
        .where((c) => c.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select City',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _kText,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search city...',
                prefixIcon: const Icon(Icons.search, color: _kSubText),
                filled: true,
                fillColor: _kBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                controller: controller,
                itemCount: filtered.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, thickness: 0.5),
                itemBuilder: (_, i) {
                  final city = filtered[i];
                  final isSelected = city == widget.selected;
                  return ListTile(
                    leading: Icon(
                      Icons.location_city,
                      color: isSelected ? _kPrimary : _kSubText,
                    ),
                    title: Text(
                      city,
                      style: TextStyle(
                        color: isSelected ? _kPrimary : _kText,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: _kPrimary, size: 18)
                        : null,
                    onTap: () {
                      widget.onSelect(city);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPrimary,
        disabledBackgroundColor: _kPrimary.withOpacity(0.5),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final IconData icon;
  final Widget child;
  final VoidCallback onTap;

  const _FieldRow({
    required this.icon,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: _kSubText),
            const SizedBox(width: 10),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: _kText,
    ),
  );
}

class _NearMeChip extends StatelessWidget {
  final VoidCallback onTap;
  const _NearMeChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: _kPrimary, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Near Me',
          style: TextStyle(
            color: _kPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

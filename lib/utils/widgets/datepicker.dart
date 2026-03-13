import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _kPrimary = Color(0xFF3D35C0);
const _kPrimaryLight = Color(0xFFEEEDFB);
const _kText = Color(0xFF1A1A2E);
const _kSubText = Color(0xFF6B7280);

Future<DateTimeRange?> showDateRangePickerSheet(
  BuildContext context, {
  required DateTimeRange initialRange,
}) {
  return showModalBottomSheet<DateTimeRange>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DatePickerSheet(initialRange: initialRange),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// SHEET WIDGET
// ══════════════════════════════════════════════════════════════════════════════

class _DatePickerSheet extends StatefulWidget {
  final DateTimeRange initialRange;
  const _DatePickerSheet({required this.initialRange});

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime _start;
  late DateTime? _end;

  // We show 12 months starting from today's month
  final DateTime _firstMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  static const int _totalMonths = 12;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange.start;
    _end = widget.initialRange.end;
  }

  // ── Selection logic ────────────────────────────────────────────────────────
  void _onDayTap(DateTime day) {
    setState(() {
      if (_end != null || day.isBefore(_start)) {
        // Start fresh
        _start = day;
        _end = null;
      } else if (day.isAfter(_start)) {
        _end = day;
      } else {
        // Same day tapped again → reset
        _start = day;
        _end = null;
      }
    });
  }

  int get _nights =>
      _end != null ? _end!.difference(_start).inDays : 0;

  bool _isStart(DateTime d) => _isSameDay(d, _start);
  bool _isEnd(DateTime d) => _end != null && _isSameDay(d, _end!);
  bool _inRange(DateTime d) =>
      _end != null && d.isAfter(_start) && d.isBefore(_end!);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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

          const SizedBox(height: 12),

          // ── Weekday header (fixed) ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 12,
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

          const SizedBox(height: 6),
          const Divider(height: 1, thickness: 0.5),

          // ── Scrollable months ────────────────────────────────────────────
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

          // ── Footer ──────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottomPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Check-in / Check-out row
                Row(
                  children: [
                    Expanded(
                      child: _DateSummaryTile(
                        label: 'Check – In',
                        date: _start,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: Colors.grey.shade200,
                    ),
                    Expanded(
                      child: _DateSummaryTile(
                        label: 'Check – Out',
                        date: _end,
                        placeholder: 'Select date',
                      ),
                    ),
                  ],
                ),

                if (_nights > 0) ...[
                  const SizedBox(height: 6),
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

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _end != null
                        ? () => Navigator.pop(
                              context,
                              DateTimeRange(start: _start, end: _end!),
                            )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimary,
                      disabledBackgroundColor: _kPrimary.withOpacity(0.5),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
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

// ══════════════════════════════════════════════════════════════════════════════
// MONTH GRID
// ══════════════════════════════════════════════════════════════════════════════

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
    // Monday = 1 → offset 0, Sunday = 7 → offset 6
    final firstDayOfWeek =
        DateTime(month.year, month.month, 1).weekday; // 1=Mon, 7=Sun
    final offset = firstDayOfWeek - 1; // 0-based Mon start
    final totalCells = offset + totalDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
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
                  // Range highlight background (extends full cell width)
                  if (range || (start && isEnd(day) == false) || (end && isStart(day) == false))
                    Positioned.fill(
                      child: _RangeBackground(
                        isStart: start,
                        isEnd: end,
                        inRange: range,
                      ),
                    ),

                  // Day circle
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: selected ? _kPrimary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: range
                          ? Border.all(color: _kPrimary.withOpacity(0.3))
                          : null,
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

// ── Range background strip ────────────────────────────────────────────────────

class _RangeBackground extends StatelessWidget {
  final bool isStart, isEnd, inRange;
  const _RangeBackground({
    required this.isStart,
    required this.isEnd,
    required this.inRange,
  });

  @override
  Widget build(BuildContext context) {
    if (!inRange && !isStart && !isEnd) return const SizedBox();

    BorderRadius? radius;
    if (isStart) {
      radius = const BorderRadius.horizontal(left: Radius.circular(10));
    } else if (isEnd) {
      radius = const BorderRadius.horizontal(right: Radius.circular(10));
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: (isStart || isEnd) ? 0 : 0,
      ),
      decoration: BoxDecoration(
        color: _kPrimaryLight,
        borderRadius: radius,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DATE SUMMARY TILE
// ══════════════════════════════════════════════════════════════════════════════

class _DateSummaryTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final String placeholder;

  const _DateSummaryTile({
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

// ══════════════════════════════════════════════════════════════════════════════
// PREVIEW (remove in production)
// ══════════════════════════════════════════════════════════════════════════════

void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatefulWidget {
  const _PreviewApp();
  @override
  State<_PreviewApp> createState() => _PreviewAppState();
}

class _PreviewAppState extends State<_PreviewApp> {
  DateTimeRange _range = DateTimeRange(
    start: DateTime(2026, 1, 12),
    end: DateTime(2026, 1, 17),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${DateFormat('dd MMM yy').format(_range.start)}  →  ${DateFormat('dd MMM yy').format(_range.end)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final result = await showDateRangePickerSheet(
                    context,
                    initialRange: _range,
                  );
                  if (result != null) setState(() => _range = result);
                },
                child: const Text('Open Date Picker'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
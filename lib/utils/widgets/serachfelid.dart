import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:indhostels/data/models/accomodation/search_res.dart';

class FilterSelection {
  final RangeValues priceRange;
  final Set<String> selectedRoomTypes; // multi-select (List from API)
  final Set<String> selectedAmenities; // multi-select
  final String? selectedCategory; // single-select (plain string to API)
  final String? selectedLocation; // single-select (plain string to API)

  const FilterSelection({
    required this.priceRange,
    this.selectedRoomTypes = const {},
    this.selectedAmenities = const {},
    this.selectedCategory,
    this.selectedLocation,
  });

  bool get isEmpty =>
      selectedRoomTypes.isEmpty &&
      selectedAmenities.isEmpty &&
      selectedCategory == null &&
      selectedLocation == null;

  int get activeCount {
    int c = 0;
    if (selectedCategory != null) c++;
    if (selectedLocation != null) c++;
    c += selectedRoomTypes.length;
    c += selectedAmenities.length;
    return c;
  }

  Map<String, dynamic> toApiParams({
    int page = 1,
    int limit = 10,
    String? checkInDate,
    String? checkOutDate,
    List<String>? stayTypes,
    double? rating,
  }) {
    final params = <String, dynamic>{'page': page, 'limit': limit};

    if (checkInDate != null) params['check_in_date'] = checkInDate;
    if (checkOutDate != null) params['check_out_date'] = checkOutDate;

    // plain strings
    if ((selectedCategory ?? '').isNotEmpty) {
      params['category'] = selectedCategory;
    }
    if ((selectedLocation ?? '').isNotEmpty) {
      params['location'] = selectedLocation;
    }

    // JSON-encoded arrays
    if (stayTypes != null && stayTypes.isNotEmpty) {
      params['staytype'] = jsonEncode(stayTypes);
    }
    if (selectedRoomTypes.isNotEmpty) {
      params['roomtype'] = jsonEncode(selectedRoomTypes.toList());
    }
    if (selectedAmenities.isNotEmpty) {
      params['amenities'] = jsonEncode(selectedAmenities.toList());
    }

    // price
    params['minprice'] = priceRange.start;
    params['maxprice'] = priceRange.end;

    if (rating != null) params['rating'] = rating;

    return params;
  }
}

class SearchFilterBar extends StatefulWidget {
  final ValueChanged<String>? onSearch;

  final Filters? filters;

  final Future<Filters?> Function(FilterSelection selection)? onFilterChanged;

  final ValueChanged<FilterSelection>? onFilterApplied;
  final FilterSelection? activeSelection;
  const SearchFilterBar({
    super.key,
    this.onSearch,
    this.filters,
    this.onFilterChanged,
    this.onFilterApplied,
    this.activeSelection,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final _ctrl = TextEditingController();
  int _activeFilterCount = 0;

  static const _purple = Color(0xFF5B4FCF);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _openFilterSheet() async {
    if (widget.filters == null) return;

    final result = await showModalBottomSheet<FilterSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => _FilterBottomSheet(
        initialFilters: widget.filters!,
        initialSelection: widget.activeSelection,
        onFilterChanged: widget.onFilterChanged,
      ),
    );

    if (result != null && mounted) {
      setState(() => _activeFilterCount = result.activeCount);
      widget.onFilterApplied?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          // ── Search field ──────────────────────────────────────
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _ctrl,
                onChanged: widget.onSearch,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
                decoration: const InputDecoration(
                  hintText: 'Search here...',
                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: Color(0xFFAAAAAA),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 40,
                    minHeight: 44,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ── Filter button + badge ─────────────────────────────
          GestureDetector(
            onTap: _openFilterSheet,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: widget.filters == null
                        ? Colors.grey.shade300
                        : _purple,
                  ),
                ),
                if (_activeFilterCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: _purple,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$_activeFilterCount',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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

// ─────────────────────────────────────────────
// FILTER BOTTOM SHEET
// ─────────────────────────────────────────────
class _FilterBottomSheet extends StatefulWidget {
  final Filters initialFilters;
  final Future<Filters?> Function(FilterSelection)? onFilterChanged;
  final FilterSelection? initialSelection;
  const _FilterBottomSheet({
    required this.initialFilters,
    this.onFilterChanged,
    this.initialSelection,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  // ── Live filter options (swapped in-place from API) ───────────
  late Filters _filters;

  // ── User selections ───────────────────────────────────────────
  late RangeValues _priceRange;
  final Set<String> _selectedRoomTypes = {}; // multi-select checkboxes
  final Set<String> _selectedAmenities = {}; // multi-select checkboxes
  String? _selectedCategory; // single-select radio
  String? _selectedLocation; // single-select radio

  // ── UI state ──────────────────────────────────────────────────
  bool _isLoading = false;

  // ── Theme ─────────────────────────────────────────────────────
  static const _purple = Color(0xFF5B4FCF);
  static const _lightPurple = Color(0xFFEDE9FF);
  static const _dividerClr = Color(0xFFEEEEEE);
  static const _labelColor = Color(0xFF222222);
  static const _headerStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: _labelColor,
  );

  // ─── lifecycle ────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _filters = widget.initialFilters;

    final min = (_filters.minPrice ?? 0).toDouble();
    final max = (_filters.maxPrice ?? 20000).toDouble();
    final safeMax = max > min ? max : min + 1;

    final sel = widget.initialSelection;

    if (sel != null) {
      double start = sel.priceRange.start;
      double end = sel.priceRange.end;

      start = start.clamp(min, safeMax);
      end = end.clamp(min, safeMax);

      if (start > end) {
        start = min;
        end = safeMax;
      }

      _priceRange = RangeValues(start, end);

      _selectedRoomTypes.addAll(sel.selectedRoomTypes);
      _selectedAmenities.addAll(sel.selectedAmenities);
      _selectedCategory = sel.selectedCategory;
      _selectedLocation = sel.selectedLocation;
    } else {
      _priceRange = RangeValues(min, safeMax);
    }
  }

  void _initPriceRange() {
    final min = (_filters.minPrice ?? 0).toDouble();
    final max = (_filters.maxPrice ?? 20000).toDouble();
    _priceRange = RangeValues(min, max > min ? max : min + 1);
  }

  FilterSelection get _current => FilterSelection(
    priceRange: _priceRange,
    selectedRoomTypes: Set.from(_selectedRoomTypes),
    selectedAmenities: Set.from(_selectedAmenities),
    selectedCategory: _selectedCategory,
    selectedLocation: _selectedLocation,
  );

  String _fmt(double v) => '₹${v.toInt()}';

  Future<void> _triggerUpdate() async {
    if (widget.onFilterChanged == null) return;
    if (mounted) setState(() => _isLoading = true);

    try {
      final fresh = await widget.onFilterChanged!(_current);
      if (!mounted || fresh == null) return;

      setState(() {
        final newRoomTypes = fresh.roomTypes ?? [];
        final newAmenities = fresh.amenities ?? [];
        final newCategories = fresh.category ?? [];
        final newLocations = fresh.location ?? [];

        _selectedRoomTypes.removeWhere((r) => !newRoomTypes.contains(r));
        _selectedAmenities.removeWhere((a) => !newAmenities.contains(a));

        if (_selectedCategory != null &&
            !newCategories.contains(_selectedCategory)) {
          _selectedCategory = null;
        }
        if (_selectedLocation != null &&
            !newLocations.contains(_selectedLocation)) {
          _selectedLocation = null;
        }

        // Clamp price range to new bounds
        final newMin = (fresh.minPrice ?? 0).toDouble();
        final newMax = (fresh.maxPrice ?? 20000).toDouble();
        final safeMax = newMax > newMin ? newMax : newMin + 1;

        _priceRange = RangeValues(
          _priceRange.start.clamp(newMin, safeMax),
          _priceRange.end.clamp(newMin, safeMax),
        );

        _filters = fresh;
      });
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearAll() {
    setState(() {
      _initPriceRange();
      _selectedRoomTypes.clear();
      _selectedAmenities.clear();
      _selectedCategory = null;
      _selectedLocation = null;
    });
    _triggerUpdate();
  }

  void _apply() => Navigator.pop(context, _current);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final roomTypes = _filters.roomTypes ?? [];
    final amenities = _filters.amenities ?? [];
    final categories = _filters.category ?? [];
    final locations = _filters.location ?? [];

    final sliderMin = (_filters.minPrice ?? 0).toDouble();
    final sliderMax = (_filters.maxPrice ?? 20000).toDouble();
    final safeMax = sliderMax > sliderMin ? sliderMax : sliderMin + 1;

    return Container(
      constraints: BoxConstraints(maxHeight: mq.size.height * 0.88),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: Text(
                    'Filter By',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _labelColor,
                    ),
                  ),
                ),
                if (_isLoading)
                  const Positioned(
                    right: 0,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _purple,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: _dividerClr),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text('Price Range', style: _headerStyle),
                      const SizedBox(width: 6),
                      Text(
                        '(Per Night)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AbsorbPointer(
                    absorbing: _isLoading,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: _purple,
                        inactiveTrackColor: _lightPurple,
                        thumbColor: _purple,
                        overlayColor: _purple.withOpacity(0.12),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                      ),
                      child: RangeSlider(
                        min: sliderMin,
                        max: safeMax,
                        values: RangeValues(
                          _priceRange.start.clamp(sliderMin, safeMax),
                          _priceRange.end.clamp(sliderMin, safeMax),
                        ),
                        onChanged: (v) => setState(() => _priceRange = v),
                        onChangeEnd: (_) => _triggerUpdate(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _priceLabel(
                          _fmt(_priceRange.start),
                          'Min',
                          CrossAxisAlignment.start,
                        ),
                        _priceLabel(
                          _fmt(_priceRange.end),
                          'Max',
                          CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ),

                  // ── Room Type (multi-select checkboxes) ─────
                  if (roomTypes.isNotEmpty) ...[
                    _sectionDivider(),
                    const Text('Room Type', style: _headerStyle),
                    const SizedBox(height: 6),
                    ...roomTypes.map(
                      (rt) => _checkboxTile(
                        label: rt,
                        checked: _selectedRoomTypes.contains(rt),
                        enabled: !_isLoading,
                        onTap: () async {
                          setState(
                            () => _selectedRoomTypes.contains(rt)
                                ? _selectedRoomTypes.remove(rt)
                                : _selectedRoomTypes.add(rt),
                          );
                          await _triggerUpdate();
                        },
                      ),
                    ),
                  ],

                  // ── Amenities (multi-select checkboxes) ─────
                  if (amenities.isNotEmpty) ...[
                    _sectionDivider(),
                    const Text('Amenities', style: _headerStyle),
                    const SizedBox(height: 6),
                    ...amenities.map(
                      (a) => _checkboxTile(
                        label: a,
                        checked: _selectedAmenities.contains(a),
                        enabled: !_isLoading,
                        onTap: () async {
                          setState(
                            () => _selectedAmenities.contains(a)
                                ? _selectedAmenities.remove(a)
                                : _selectedAmenities.add(a),
                          );
                          await _triggerUpdate();
                        },
                      ),
                    ),
                  ],

                  // ── Category / Meals (single-select radio) ──
                  if (categories.isNotEmpty) ...[
                    _sectionDivider(),
                    const Text('Meals', style: _headerStyle),
                    const SizedBox(height: 6),
                    ...categories.map(
                      (c) => _radioTile(
                        label: c,
                        selected: _selectedCategory == c,
                        enabled: !_isLoading,
                        onTap: () async {
                          setState(
                            () => _selectedCategory = _selectedCategory == c
                                ? null
                                : c,
                          );
                          await _triggerUpdate();
                        },
                      ),
                    ),
                  ],

                  // ── Location (single-select radio) ──────────
                  if (locations.isNotEmpty) ...[
                    _sectionDivider(),
                    const Text('Location', style: _headerStyle),
                    const SizedBox(height: 6),
                    ...locations.map(
                      (l) => _radioTile(
                        label: l,
                        selected: _selectedLocation == l,
                        enabled: !_isLoading,
                        onTap: () async {
                          setState(
                            () => _selectedLocation = _selectedLocation == l
                                ? null
                                : l,
                          );
                          await _triggerUpdate();
                        },
                      ),
                    ),
                  ],

                  // ── Empty state ──────────────────────────────
                  if (roomTypes.isEmpty &&
                      amenities.isEmpty &&
                      categories.isEmpty &&
                      locations.isEmpty &&
                      !_isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'No filter options available',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Sticky bottom buttons ──────────────────────────────
          const Divider(height: 1, thickness: 1, color: _dividerClr),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + mq.padding.bottom),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _clearAll,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _purple,
                      disabledForegroundColor: _purple.withOpacity(0.4),
                      side: BorderSide(
                        color: _isLoading ? _purple.withOpacity(0.3) : _purple,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _apply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      disabledBackgroundColor: _purple.withOpacity(0.5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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

  // ─── sub-widgets ──────────────────────────────────────────────

  Widget _sectionDivider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Container(height: 1, color: _dividerClr),
  );

  Widget _priceLabel(String amount, String label, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          amount,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _purple,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  /// Single-select — used for Category & Location
  Widget _radioTile({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                height: 40,
                child: Radio<bool>(
                  value: true,
                  groupValue: selected ? true : null,
                  activeColor: _purple,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  onChanged: enabled ? (_) => onTap() : null,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: selected ? _purple : const Color(0xFF333333),
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Multi-select — used for Room Type & Amenities
  Widget _checkboxTile({
    required String label,
    required bool checked,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                height: 40,
                child: Checkbox(
                  value: checked,
                  activeColor: _purple,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: enabled ? (_) => onTap() : null,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: checked ? _purple : const Color(0xFF333333),
                    fontWeight: checked ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/Serach/search_bloc.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/utils/constants/icons_contants.dart';


class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(const LocationFetchAll());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _pick(String value) {
  _controller.text = value;
  _focusNode.unfocus();

  context.read<SearchBloc>().add(LocationItemSelected(value));

  context.pop(value); 
}

  @override
  Widget build(BuildContext context) {
    final r = R(MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.screenPadH,
                vertical: r.screenPadV,
              ),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Icon(AppIcons.back,
                    size: r.backIconSize, color: Colors.black87),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: r.screenPadH),
              child: _SearchBar(
                r: r,
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (q) =>
                    context.read<SearchBloc>().add(LocationSearchChanged(q)),
                onClear: () {
                  _controller.clear();
                  context
                      .read<SearchBloc>()
                      .add(const LocationSearchCleared());
                },
              ),
            ),

            SizedBox(height: r.fieldGap),

            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                buildWhen: (prev, curr) =>
                    prev.locationLoading != curr.locationLoading ||
                    prev.locationError != curr.locationError ||
                    prev.locationSuggestions != curr.locationSuggestions ||
                    prev.locationRecentSearches !=
                        curr.locationRecentSearches ||
                    prev.popularCities != curr.popularCities ||
                    prev.locationSearchActive != curr.locationSearchActive,
                builder: (context, state) {
                  if (state.locationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.locationError != null) {
                    return _EmptyState(
                      r: r,
                      title: 'Something went wrong',
                      subtitle: state.locationError!,
                    );
                  }

                  if (state.locationSearchActive) {
                    final suggestions = state.locationSuggestions ?? [];
                    if (suggestions.isEmpty) {
                      return _EmptyState(
                        r: r,
                        title: 'No results found',
                        subtitle: 'Try a different city, area, or stay type.',
                      );
                    }
                    return _SuggestionList(
                      r: r,
                      suggestions: suggestions,
                      onTap: _pick,
                    );
                  }

                  return _IdleBody(
                    r: r,
                    recentSearches: state.locationRecentSearches,
                    popularCities: state.popularCities,
                    onTap: _pick,
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

class _SearchBar extends StatelessWidget {
  final R r;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.r,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: r.searchBarHeight,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(r.searchBarRadius),
      ),
      padding: EdgeInsets.symmetric(horizontal: r.cardPadH * 0.6),
      child: Row(
        children: [
          Icon(Icons.search, size: r.searchIconSize, color: Colors.grey.shade500),
          SizedBox(width: r.iconGap * 0.7),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              style:
                  TextStyle(fontSize: r.searchHintFont, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search city, area, stay type…',
                hintStyle: TextStyle(
                    fontSize: r.searchHintFont, color: Colors.grey.shade400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) => value.text.isNotEmpty
                ? GestureDetector(
                    onTap: onClear,
                    child: Icon(Icons.close,
                        size: r.searchIconSize, color: Colors.grey.shade500),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _IdleBody extends StatelessWidget {
  final R r;
  final List<String> recentSearches;
  final List<PopularCity> popularCities;
  final ValueChanged<String> onTap;

  const _IdleBody({
    required this.r,
    required this.recentSearches,
    required this.popularCities,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: r.screenPadH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current location row
          GestureDetector(
            onTap: () => onTap('yousufguda hyderabad'),
            child: Row(
              children: [
                Icon(Icons.my_location_outlined,
                    size: r.currentLocIconSize, color: Colors.black87),
                SizedBox(width: r.iconGap),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Use current location',
                        style: TextStyle(
                            fontSize: r.currentLocTitleFont,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text('yousufguda hyderabad',
                        style: TextStyle(
                            fontSize: r.currentLocSubFont,
                            color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          ),

          if (recentSearches.isNotEmpty) ...[
            SizedBox(height: r.sectionGap * 0.5),
            Divider(height: r.dividerH, color: Colors.grey.shade200),
            SizedBox(height: r.sectionGap * 0.5),
            _SectionTitle(title: 'Recent Searches', r: r),
            SizedBox(height: r.headerGap * 0.7),
            ...recentSearches.map(
              (s) => Padding(
                padding: EdgeInsets.only(bottom: r.itemGap),
                child: _LocationTile(
                  icon: Icons.history,
                  title: s,
                  subtitle: '08 Jan – 09 Jan | 2 Guests | 1 Room',
                  r: r,
                  onTap: () => onTap(s),
                ),
              ),
            ),
          ],

          SizedBox(height: r.sectionGap * 0.5),
          Divider(height: r.dividerH, color: Colors.grey.shade200),
          SizedBox(height: r.sectionGap * 0.5),

          _SectionTitle(title: 'Popular Locations', r: r),
          SizedBox(height: r.headerGap * 0.7),
          ...popularCities.map(
            (c) => Padding(
              padding: EdgeInsets.only(bottom: r.itemGap),
              child: _LocationTile(
                icon: Icons.location_on_outlined,
                title: _capitalise(c.city),
                subtitle: '${c.hotelCount} Hotels',
                r: r,
                onTap: () => onTap(c.city),
              ),
            ),
          ),

          SizedBox(height: r.screenPadV * 2),
        ],
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  final R r;
  final List<Suggestion> suggestions;
  final ValueChanged<String> onTap;

  const _SuggestionList({
    required this.r,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
          horizontal: r.screenPadH, vertical: r.screenPadV * 0.5),
      itemCount: suggestions.length,
      separatorBuilder: (ctx, index) => SizedBox(height: r.itemGap),
      itemBuilder: (_, i) {
        final s = suggestions[i];
        return _LocationTile(
          icon: _iconFor(s.type),
          title: s.label,
          subtitle: _labelFor(s.type),
          r: r,
          onTap: () => onTap(s.label),
        );
      },
    );
  }

  IconData _iconFor(SuggestionType t) {
    switch (t) {
      case SuggestionType.city:
        return Icons.location_city_outlined;
      case SuggestionType.area:
        return Icons.location_on_outlined;
      case SuggestionType.stayType:
        return Icons.hotel_outlined;
      case SuggestionType.roomType:
        return Icons.bed_outlined;
      case SuggestionType.amenity:
        return Icons.star_outline;
    }
  }

  String _labelFor(SuggestionType t) {
    switch (t) {
      case SuggestionType.city:
        return 'City';
      case SuggestionType.area:
        return 'Area';
      case SuggestionType.stayType:
        return 'Stay type';
      case SuggestionType.roomType:
        return 'Room type';
      case SuggestionType.amenity:
        return 'Amenity';
    }
  }
}

class _EmptyState extends StatelessWidget {
  final R r;
  final String title;
  final String subtitle;

  const _EmptyState(
      {required this.r, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.screenPadH * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_outlined,
                size: r.emptyIconSize, color: Colors.grey.shade300),
            SizedBox(height: r.headerGap),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: r.emptyTitleFont,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: r.emptySubFont, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final R r;
  final VoidCallback onTap;

  const _LocationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.r,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.itemRadius),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: r.itemPadH, vertical: r.itemPadV),
        child: Row(
          children: [
            Icon(icon, size: r.itemIconSize, color: Colors.black54),
            SizedBox(width: r.iconGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: r.itemTitleFont,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: r.itemSubFont,
                          color: Colors.grey.shade500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final R r;
  const _SectionTitle({required this.title, required this.r});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: TextStyle(
            fontSize: r.sectionTitleFont,
            fontWeight: FontWeight.w700,
            color: Colors.black87),
      );
}

String _capitalise(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
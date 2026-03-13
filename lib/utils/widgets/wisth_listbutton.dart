// lib/widgets/wishlist_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/wishlist/wishlist_bloc.dart';

/// Drop-in heart button — pass [accommodationId], it handles everything.
///
/// Usage on a property card:
/// ```dart
/// WishlistButton(accommodationId: '6954ea01ce0dada4efae5bcf')
/// ```
class WishlistButton extends StatelessWidget {
  const WishlistButton({
    super.key,
    required this.accommodationId,
    this.size = 24,
    this.activeColor = const Color(0xFFE53935),
    this.inactiveColor = Colors.white,
    this.backgroundColor,
    this.padding,
  });

  final String accommodationId;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  /// Wraps icon in a circular container when set (great for card overlays).
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistBloc, WishlistState>(
      // Only rebuild when THIS item's wishlisted/pending state changes
      buildWhen: (prev, curr) =>
          _wishlisted(prev) != _wishlisted(curr) ||
          _isPending(prev) != _isPending(curr),
      listenWhen: (_, curr) => curr is WishlistToggleError,
      listener: (context, state) {
        if (state is WishlistToggleError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFFE53935),
              ),
            );
        }
      },
      builder: (context, state) {
        final isWishlisted = _wishlisted(state);
        final isPending = _isPending(state);

        return GestureDetector(
          onTap: isPending
              ? null
              : () => context.read<WishlistBloc>().add(
                  ToggleWishlistEvent(accommodationId),
                ),
          child: _buildIcon(isWishlisted, isPending),
        );
      },
    );
  }

  Widget _buildIcon(bool isWishlisted, bool isPending) {
    Widget icon;

    if (isPending) {
      icon = SizedBox(
        width: size * 0.75,
        height: size * 0.75,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: isWishlisted ? activeColor : inactiveColor,
        ),
      );
    } else {
      icon = AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isWishlisted ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isWishlisted),
          size: size,
          color: isWishlisted ? activeColor : inactiveColor,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
        ),
      );
    }

    if (backgroundColor != null) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: padding ?? const EdgeInsets.all(8),
        child: icon,
      );
    }

    return Padding(padding: padding ?? EdgeInsets.zero, child: icon);
  }

  bool _wishlisted(WishlistState state) => switch (state) {
    WishlistLoaded s => s.isWishlisted(accommodationId),
    WishlistToggleError s => s.isWishlisted(accommodationId),
    _ => false,
  };

  bool _isPending(WishlistState state) => switch (state) {
    WishlistLoaded s => s.isPending(accommodationId),
    _ => false,
  };
}

// ─── TOTAL BADGE ─────────────────────────────────────────────────────────────

/// App bar / nav bar wishlist icon with live count badge.
class WishlistCountBadge extends StatelessWidget {
  const WishlistCountBadge({
    super.key,
    this.iconSize = 28,
    this.badgeColor = const Color(0xFFE53935),
    this.iconColor,
    this.onTap,
  });

  final double iconSize;
  final Color badgeColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      buildWhen: (prev, curr) => _total(prev) != _total(curr),
      builder: (context, state) {
        final count = _total(state);
        return GestureDetector(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.favorite_border,
                size: iconSize,
                color: iconColor ?? Theme.of(context).iconTheme.color,
              ),
              if (count > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  int _total(WishlistState state) => switch (state) {
    WishlistLoaded s => s.total,
    WishlistToggleError s => s.total,
    _ => 0,
  };
}

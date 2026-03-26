import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/wishlist/wishlist_bloc.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';

class WishlistButton extends StatelessWidget {
  const WishlistButton({
    super.key,
    required this.accommodationId,
    this.size = 24,
    this.activeColor = const Color(0xFFE53935),
    this.inactiveColor = Colors.black,
    this.backgroundColor,
    this.padding,
  });

  final String accommodationId;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistBloc, WishlistState>(
      buildWhen: (prev, curr) =>
          prev.isWishlisted(accommodationId) !=
              curr.isWishlisted(accommodationId) ||
          prev.isPending(accommodationId) != curr.isPending(accommodationId),

      listenWhen: (prev, curr) =>
          prev.addSuccess != curr.addSuccess ||
          prev.removeSuccess != curr.removeSuccess ||
          prev.addError != curr.addError ||
          prev.removeError != curr.removeError ||
          prev.error != curr.error,

      listener: (context, state) {
        if (state.addSuccess) {
          AppToast.success("Added to wishlist", position: ToastPosition.top);
        }

        if (state.removeSuccess) {
          AppToast.success(
            "Removed from wishlist",
            position: ToastPosition.top,
          );
        }

        if (state.addError != null) {
          AppToast.error(state.addError!, position: ToastPosition.top);
        }

        if (state.removeError != null) {
          AppToast.error(state.removeError!, position: ToastPosition.top);
        }

        if (state.error != null) {
          AppToast.error(state.error!, position: ToastPosition.top);
        }
      },
      builder: (context, state) {
        final isWishlisted = state.isWishlisted(accommodationId);
        final isPending = state.isPending(accommodationId);
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
              color: Colors.black.withValues(alpha:0.15),
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
}

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
      buildWhen: (prev, curr) => prev.total != curr.total,
      builder: (context, state) {
        final count = state.total;

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
}

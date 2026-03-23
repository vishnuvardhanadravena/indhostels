import 'dart:math' as math;
import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════
//  FULLY REUSABLE  EmptyStateCard
//  Pass anything: asset image, network image, icon, or widget
// ════════════════════════════════════════════════════════════

/// How the illustration is provided
enum EmptyStateImageType { asset, network, icon, widget }

class EmptyStateCard extends StatefulWidget {
  const EmptyStateCard({
    super.key,

    // ── Text ──
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,

    // ── Illustration ──
    /// Pass ONE of the four image sources below.
    this.assetImage, // e.g. 'assets/images/no_hotel.png'
    this.networkImage, // e.g. 'https://example.com/img.png'
    this.icon, // e.g. Icons.hotel_outlined
    this.customIllustration, // any widget — painter, Lottie, etc.

    this.imageSize = 90,
    this.iconColor,
    this.showCircleBackground = true, // One UI circle behind illustration
    // ── Action button ──
    this.buttonLabel,
    this.onButtonTap,
    this.buttonColor,

    // ── Card appearance ──
    this.backgroundColor = Colors.white,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.elevation = 0.0,
    this.border,

    // ── Animations ──
    this.enableFloatAnimation = true,
    this.enableEntryAnimation = true,
  });

  // ── Text ──
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  // ── Illustration ──
  final String? assetImage;
  final String? networkImage;
  final IconData? icon;
  final Widget? customIllustration;
  final double imageSize;
  final Color? iconColor;
  final bool showCircleBackground;

  // ── Action button ──
  final String? buttonLabel;
  final VoidCallback? onButtonTap;
  final Color? buttonColor;

  // ── Card ──
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double elevation;
  final BoxBorder? border;

  // ── Animations ──
  final bool enableFloatAnimation;
  final bool enableEntryAnimation;

  @override
  State<EmptyStateCard> createState() => _EmptyStateCardState();
}

class _EmptyStateCardState extends State<EmptyStateCard>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _floatAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Float loop
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _floatAnim = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    if (widget.enableFloatAnimation) _floatCtrl.repeat(reverse: true);

    // Entry
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.elasticOut));
    if (widget.enableEntryAnimation) {
      _entryCtrl.forward();
    } else {
      _entryCtrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        // child: Container(
        //   margin: widget.margin,
        //   decoration: BoxDecoration(
        //     color: widget.backgroundColor,
        //     borderRadius: BorderRadius.circular(widget.borderRadius),
        //     border: widget.border ??
        //         Border.all(color: const Color(0xFFE8EAF0), width: 1),
        //     boxShadow: widget.elevation > 0
        //         ? [
        //             BoxShadow(
        //               color: Colors.black.withOpacity(0.06),
        //               blurRadius: widget.elevation * 6,
        //               offset: Offset(0, widget.elevation * 2),
        //             ),
        //           ]
        //         : [
        //             BoxShadow(
        //               color: Colors.black.withOpacity(0.05),
        //               blurRadius: 20,
        //               offset: const Offset(0, 4),
        //             ),
        //           ],
        //   ),
        child: Padding(
          padding: widget.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Illustration ──
              AnimatedBuilder(
                animation: _floatAnim,
                builder: (_, child) => Transform.translate(
                  offset: Offset(
                    0,
                    widget.enableFloatAnimation ? _floatAnim.value : 0,
                  ),
                  child: child,
                ),
                child: _buildIllustration(),
              ),

              const SizedBox(height: 24),

              // ── Title ──
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style:
                    widget.titleStyle ??
                    const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C1E),
                      letterSpacing: -0.3,
                      height: 1.35,
                    ),
              ),

              // ── Subtitle ──
              if (widget.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subtitle!,
                  textAlign: TextAlign.center,
                  style:
                      widget.subtitleStyle ??
                      const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8E8E93),
                        height: 1.55,
                        letterSpacing: 0.1,
                      ),
                ),
              ],

              // ── Button ──
              if (widget.buttonLabel != null && widget.onButtonTap != null) ...[
                const SizedBox(height: 28),
                _EmptyStateButton(
                  label: widget.buttonLabel!,
                  onTap: widget.onButtonTap!,
                  color:
                      widget.buttonColor ??
                      Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
        // ),
      ),
    );
  }

  Widget _buildIllustration() {
    // Resolve the inner illustration
    Widget inner;

    if (widget.customIllustration != null) {
      inner = SizedBox(
        width: widget.imageSize,
        height: widget.imageSize,
        child: widget.customIllustration,
      );
    } else if (widget.assetImage != null) {
      inner = Image.asset(
        widget.assetImage!,
        width: widget.imageSize,
        height: widget.imageSize,
        fit: BoxFit.contain,
      );
    } else if (widget.networkImage != null) {
      inner = Image.network(
        widget.networkImage!,
        width: widget.imageSize,
        height: widget.imageSize,
        fit: BoxFit.contain,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : SizedBox(
                width: widget.imageSize,
                height: widget.imageSize,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
      );
    } else if (widget.icon != null) {
      inner = Icon(
        widget.icon,
        size: widget.imageSize * 0.55,
        color: widget.iconColor ?? const Color(0xFFBFC5D0),
      );
    } else {
      // Default — built-in house painter
      inner = CustomPaint(
        size: Size(widget.imageSize * 0.8, widget.imageSize * 0.8),
        painter: _HousePainter(),
      );
    }

    if (!widget.showCircleBackground) return inner;

    // One UI neumorphic circle
    final circleSize = widget.imageSize * 1.8;
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEEF0F5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Center(child: inner),
    );
  }
}

// ─────────────────────────────────────────────────
//  Built-in default house painter (fallback)
// ─────────────────────────────────────────────────
class _HousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    final stroke = Paint()
      ..color = const Color(0xFFBFC5D0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()..style = PaintingStyle.fill;

    const double bW = 38, bH = 30;
    final bLeft = cx - bW / 2;
    final bTop = cy + 4;

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bLeft, bTop, bW, bH),
      const Radius.circular(4),
    );
    fill.color = const Color(0xFFE8ECF2);
    canvas.drawRRect(bodyRect, fill);
    canvas.drawRRect(bodyRect, stroke);

    // Roof
    final roof = Path()
      ..moveTo(cx - bW / 2 - 5, bTop)
      ..lineTo(cx, cy - 16)
      ..lineTo(cx + bW / 2 + 5, bTop)
      ..close();
    fill.color = const Color(0xFFD0D6E0);
    canvas.drawPath(roof, fill);
    canvas.drawPath(roof, stroke);

    // Windows
    for (final xOff in [-10.0, 10.0]) {
      final w = RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + xOff - 5, bTop + 6, 10, 9),
        const Radius.circular(2),
      );
      fill.color = const Color(0xFFC5CBD8);
      canvas.drawRRect(w, fill);
      canvas.drawRRect(w, stroke);
    }

    // Door
    final door = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 5, bTop + 16, 10, 14),
      const Radius.circular(3),
    );
    fill.color = const Color(0xFFBFC5D0);
    canvas.drawRRect(door, fill);
    canvas.drawRRect(door, stroke);

    // Sad face
    final face = Paint()
      ..color = const Color(0xFFA0A8B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(cx - 2, bTop + 21),
      0.8,
      Paint()..color = const Color(0xFFA0A8B8),
    );
    canvas.drawCircle(
      Offset(cx + 2, bTop + 21),
      0.8,
      Paint()..color = const Color(0xFFA0A8B8),
    );

    final mouth = Path()
      ..moveTo(cx - 2.5, bTop + 25)
      ..quadraticBezierTo(cx, bTop + 23.5, cx + 2.5, bTop + 25);
    canvas.drawPath(mouth, face);

    // Stars
    for (final s in [
      [cx - bW / 2 - 4, bTop - 10.0, 3.5],
      [cx + bW / 2 + 6, bTop - 5.0, 2.5],
      [cx + 2, cy - 22.0, 2.0],
    ]) {
      _star(canvas, Offset(s[0], s[1]), s[2], const Color(0xFFCBD2DF));
    }
  }

  void _star(Canvas canvas, Offset c, double r, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final a = i * math.pi / 4;
      canvas.drawLine(
        Offset(c.dx + math.cos(a) * r, c.dy + math.sin(a) * r),
        Offset(c.dx - math.cos(a) * r, c.dy - math.sin(a) * r),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _EmptyStateButton extends StatefulWidget {
  const _EmptyStateButton({
    required this.label,
    required this.onTap,
    required this.color,
  });
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  State<_EmptyStateButton> createState() => _EmptyStateButtonState();
}

class _EmptyStateButtonState extends State<_EmptyStateButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
        decoration: BoxDecoration(
          color: _pressed ? widget.color.withOpacity(0.82) : widget.color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: widget.color.withOpacity(0.32),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

// void main() => runApp(const _DemoApp());

// class _DemoApp extends StatelessWidget {
//   const _DemoApp();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           colorScheme:
//               ColorScheme.fromSeed(seedColor: const Color(0xFF4A90D9)),
//           useMaterial3: true),
//       home: const _DemoScreen(),
//     );
//   }
// }

// class _DemoScreen extends StatelessWidget {
//   const _DemoScreen();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F4F8),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF2F4F8),
//         elevation: 0,
//         title: const Text('EmptyStateCard demos',
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1A1A1A))),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(vertical: 24),
//         children: [
//           const _Label('Default — built-in painter'),
//           EmptyStateCard(
//             title: 'No Accommodations Found',
//             subtitle:
//                 'Try adjusting your filters or search criteria',
//             buttonLabel: 'Search Again',
//             onButtonTap: () {},
//           ),
//           const SizedBox(height: 24),

//           const _Label('Custom widget (emoji)'),
//           EmptyStateCard(
//             title: 'No Accommodations Found',
//             subtitle:
//                 'Try adjusting your filters or search criteria',
//             customIllustration: const Text('🏠',
//                 style: TextStyle(fontSize: 52)),
//             imageSize: 60,
//           ),
//           const SizedBox(height: 24),

// const _Label('Icon illustration'),
// EmptyStateCard(
//   title: 'No Hotels Available',
//   subtitle: 'No hotels match your dates.\nTry different dates.',
//   icon: Icons.hotel_outlined,
//   iconColor: const Color(0xFF4A90D9),
//   imageSize: 80,
//   buttonLabel: 'Change Dates',
//   onButtonTap: () {},
//   buttonColor: const Color(0xFF4A90D9),
// ),
//           const SizedBox(height: 24),

//           const _Label('Asset image  (swap path)'),
//           EmptyStateCard(
//             title: 'No Accommodations Found',
//             subtitle: 'Try adjusting your filters or search criteria',
//             customIllustration: Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFFDDE3EE),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: const Icon(Icons.image_outlined,
//                   size: 40, color: Color(0xFFAEB5C4)),
//             ),
//             imageSize: 70,
//           ),
//           const SizedBox(height: 24),

//           const _Label('No circle bg — card style like screenshot'),
//           EmptyStateCard(
//             title: 'No Accommodations Found',
//             subtitle: 'Try adjusting your filters or search criteria',
//             customIllustration: const Text('🏠',
//                 style: TextStyle(fontSize: 64)),
//             imageSize: 64,
//             showCircleBackground: false,
//             enableFloatAnimation: false,
//             borderRadius: 20,
//           ),
//           const SizedBox(height: 32),
//         ],
//       ),
//     );
//   }
// }

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8E8E93),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isTablet;

  final Widget? action;

  final bool showAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isTablet,
    this.action,
    this.showAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isTablet ? 72 : 56,
              color: const Color(0xFFD0C8FF),
            ),

            const SizedBox(height: 16),

            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 18 : 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF888888),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: const Color(0xFFAAAAAA),
              ),
            ),

            if (showAction && action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/notification/notification_bloc.dart';
import 'package:indhostels/pages/profile/profile.dart';

class NotificationDetailPage extends StatefulWidget {
  final String notificationId;
  final int heroIndex;

  const NotificationDetailPage({
    super.key,
    required this.notificationId,
    required this.heroIndex,
  });

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _initAnimation();

    /// 🔥 CALL BLOC EVENT
    context.read<NotificationBloc>().add(
      NotificationDetailRequested(widget.notificationId),
    );
  }

  void _initAnimation() {
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.15, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _scale = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = R(MediaQuery.of(context).size.width);

    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        /// 🔄 LOADING
        if (state.detailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.detailError != null) {
          return Scaffold(body: Center(child: Text(state.detailError!)));
        }

        final n = state.selectedNotification;

        if (n == null) {
          return const Scaffold(
            body: Center(child: Text("No notification found")),
          );
        }

        final t = (n.notificationtitle).toLowerCase();

        IconData icon;
        if (t.contains('booking')) {
          icon = Icons.confirmation_number_rounded;
        } else if (t.contains('discount')) {
          icon = Icons.local_offer_rounded;
        } else if (t.contains('payment')) {
          icon = Icons.payment_rounded;
        } else if (t.contains('cancel')) {
          icon = Icons.cancel_rounded;
        } else {
          icon = Icons.notifications_rounded;
        }

        Color accent;
        if (t.contains('booking')) {
          accent = const Color(0xFF5B9BF8);
        } else if (t.contains('discount')) {
          accent = const Color(0xFFFF8A65);
        } else if (t.contains('payment')) {
          accent = const Color(0xFF26A69A);
        } else if (t.contains('cancel')) {
          accent = Colors.redAccent;
        } else {
          accent = Colors.grey;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Hero(
                  tag: 'notif-bg-${widget.heroIndex}',
                  child: Container(
                    height: r.isTablet ? 320 : 260,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent.withOpacity(0.85),
                          accent.withOpacity(0.35),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(r.cardRadius),
                        bottomRight: Radius.circular(r.cardRadius),
                      ),
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.screenPadH / 2,
                        vertical: r.screenPadV / 4,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: r.backIconSize,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          Text(
                            "Notification",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: r.titleFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(width: r.backIconSize * 2),
                        ],
                      ),
                    ),

                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: r.avatarGap),
                        child: Hero(
                          tag: 'notif-icon-${widget.heroIndex}',
                          child: Container(
                            width: r.avatarRadius * 2,
                            height: r.avatarRadius * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accent.withOpacity(0.3),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              icon,
                              color: accent,
                              size: r.iconSize * 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: r.sectionGap),

                    Expanded(
                      child: FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: ScaleTransition(
                            scale: _scale,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: r.screenPadH,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n.notificationtitle,
                                    style: TextStyle(
                                      fontSize: r.detailTitleFont,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),

                                  SizedBox(height: r.fieldGap),

                                  Text(
                                    n.notificationmessage,
                                    style: TextStyle(
                                      fontSize: r.detailBodyFont,
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                    ),
                                  ),

                                  SizedBox(height: r.sectionGap),

                                  /// DATE
                                  Text(
                                    "${n.createdAt.day}-${n.createdAt.month}-${n.createdAt.year}",
                                    style: TextStyle(
                                      fontSize: r.badgeFontSize,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const Spacer(),

                                  /// BUTTON
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: accent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: r.logoutPadB,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            r.logoutRadius,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Got it",
                                        style: TextStyle(
                                          fontSize: r.logoutFont,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: r.logoutPadB),
                                ],
                              ),
                            ),
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
      },
    );
  }
}

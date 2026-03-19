import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/notification/notification_bloc.dart';
import 'package:indhostels/data/models/notification/notification_res.dart';
import 'package:indhostels/routing/route_constants.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const NotificationsFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1A1A2E),
            size: 20,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1A1A2E)),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const _SkeletonLoader();
          }

          if (state.error != null) {
            return _ErrorView(
              message: state.error!,
              onRetry: () => context.read<NotificationBloc>().add(
                const NotificationsFetchRequested(),
              ),
            );
          }

          if (state.grouped.isEmpty) {
            return const _EmptyView();
          }

          final sections = state.grouped.entries.toList();
          int heroCounter = 0;

          return RefreshIndicator(
            color: const Color(0xFF5B9BF8),
            onRefresh: () async {
              context.read<NotificationBloc>().add(
                const NotificationsFetchRequested(),
              );
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: sections.fold<int>(
                0,
                (sum, e) => sum + 1 + e.value.length,
              ),
              itemBuilder: (context, index) {
                int cursor = 0;
                for (final section in sections) {
                  if (index == cursor) {
                    return _SectionHeader(label: section.key);
                  }
                  cursor++;
                  if (index < cursor + section.value.length) {
                    final item = section.value[index - cursor];
                    final hi = heroCounter++;
                    return _NotificationCard(notification: item, heroIndex: hi);
                  }
                  cursor += section.value.length;
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class NotificationUI {
  final IconData icon;
  final Color color;

  const NotificationUI({required this.icon, required this.color});
}

NotificationUI getNotificationUI(String title) {
  final t = title.toLowerCase();

  if (t.contains('booking') || t.contains('congratulation')) {
    return const NotificationUI(
      icon: Icons.confirmation_number_rounded,
      color: Color(0xFF5B9BF8),
    );
  }

  if (t.contains('discount') || t.contains('%') || t.contains('offer')) {
    return const NotificationUI(
      icon: Icons.local_offer_rounded,
      color: Color(0xFFFF8A65),
    );
  }

  if (t.contains('payment') || t.contains('paid')) {
    return const NotificationUI(
      icon: Icons.payment_rounded,
      color: Color(0xFF26A69A),
    );
  }

  if (t.contains('cancel')) {
    return const NotificationUI(
      icon: Icons.cancel_rounded,
      color: Colors.redAccent,
    );
  }

  if (t.contains('review') || t.contains('rating')) {
    return const NotificationUI(icon: Icons.star_rounded, color: Colors.amber);
  }

  return const NotificationUI(
    icon: Icons.notifications_rounded,
    color: Colors.grey,
  );
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final int heroIndex;

  const _NotificationCard({
    required this.notification,
    required this.heroIndex,
  });

  // String _timeAgo(DateTime dt) {
  //   final diff = DateTime.now().difference(dt);
  //   if (diff.inMinutes < 60) return '${diff.inMinutes} min Ago';
  //   if (diff.inHours < 24) return '${diff.inHours} hours Ago';

  //   final h = dt.hour;
  //   final m = dt.minute.toString().padLeft(2, '0');
  //   final period = h < 12 ? 'am' : 'pm';
  //   final hour = (h % 12 == 0 ? 12 : h % 12).toString().padLeft(2, '0');

  //   return '$hour:$m $period';
  // }

  void _openDetail(BuildContext context) {
    context.pushNamed(
      RouteList.notificationDetail,
      extra: {"notificationid": notification.id, "heroIndex": heroIndex},
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = getNotificationUI(notification.notificationTitle);
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Icon with Hero Animation
              Hero(
                tag: 'notif-icon-$heroIndex',
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: ui.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(ui.icon, color: ui.color, size: 22),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      notification.notificationTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   _timeAgo(notification.createdAt),
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.grey.shade500,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonLoader extends StatefulWidget {
  const _SkeletonLoader();

  @override
  State<_SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<_SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final opacity = 0.35 + _anim.value * 0.45;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(7, (i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (i == 0 || i == 4)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: 150,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300.withOpacity(opacity),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 74,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(opacity),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 62, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B9BF8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 62,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 14),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

IconData getIcon(NotificationType type) {
  switch (type) {
    case NotificationType.booking:
      return Icons.confirmation_number_rounded;
    case NotificationType.offer:
      return Icons.local_offer_rounded;
    case NotificationType.payment:
      return Icons.payment_rounded;
    case NotificationType.cancellation:
      return Icons.cancel_rounded;
    case NotificationType.review:
      return Icons.star_rounded;
    default:
      return Icons.notifications_rounded;
  }
}

Color getColor(NotificationType type) {
  switch (type) {
    case NotificationType.booking:
      return const Color(0xFF5B9BF8);
    case NotificationType.offer:
      return const Color(0xFFFF8A65);
    case NotificationType.payment:
      return const Color(0xFF26A69A);
    case NotificationType.cancellation:
      return Colors.redAccent;
    case NotificationType.review:
      return Colors.amber;
    default:
      return Colors.grey;
  }
}

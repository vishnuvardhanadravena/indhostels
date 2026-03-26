import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/Serach/search_bloc.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/bloc/auth/auth_state.dart';
import 'package:indhostels/bloc/profile/profile_bloc.dart';
import 'package:indhostels/bloc/profile/profile_event.dart';
import 'package:indhostels/bloc/profile/profile_state.dart';
import 'package:indhostels/bloc/wishlist/wishlist_bloc.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';
import 'package:indhostels/services/init.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/widgets/confromation_pop.dart';
import 'package:indhostels/utils/widgets/file_pickers.dart';

class ProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String route;

  const ProfileMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    required this.route,
  });
}

class R {
  final bool isTablet;

  R(double width) : isTablet = width >= 600;

  // Screen padding
  double get screenPadH => isTablet ? 48.0 : 18.0;
  double get screenPadV => isTablet ? 24.0 : 16.0;

  // Spacing
  double get sectionGap => isTablet ? 42.0 : 36.0;
  double get fieldGap => isTablet ? 20.0 : 20.0;
  double get headerGap => isTablet ? 28.0 : 20.0;

  // App bar / titles
  double get titleFontSize => isTablet ? 26.0 : 20.0;
  double get backIconSize => isTablet ? 26.0 : 22.0;

  // Avatar
  double get avatarRadius => isTablet ? 56.0 : 40.0;
  double get avatarGap => isTablet ? 24.0 : 18.0;

  // Profile text
  double get nameFontSize => isTablet ? 22.0 : 18.0;
  double get emailFontSize => isTablet ? 14.0 : 13.0;

  // Gender selection
  double get genderFontSize => isTablet ? 15.0 : 13.0;
  double get genderIconSize => isTablet ? 22.0 : 18.0;
  double get radioGap => isTablet ? 28.0 : 20.0;

  // Cards
  double get cardRadius => isTablet ? 24.0 : 18.0;
  double get cardPadH => isTablet ? 28.0 : 20.0;
  double get cardPadV => isTablet ? 28.0 : 20.0;

  // Menu items
  double get itemPadH => isTablet ? 24.0 : 20.0;
  double get itemPadV => isTablet ? 20.0 : 18.0;
  double get iconBox => isTablet ? 46.0 : 38.0;
  double get iconBoxRadius => isTablet ? 13.0 : 10.0;
  double get iconSize => isTablet ? 24.0 : 20.0;
  double get iconGap => isTablet ? 16.0 : 14.0;
  double get labelFontSize => isTablet ? 17.0 : 15.0;
  double get chevronSize => isTablet ? 26.0 : 22.0;

  double get logoutH => isTablet ? 62.0 : 52.0;
  double get logoutRadius => isTablet ? 18.0 : 14.0;
  double get logoutFont => isTablet ? 18.0 : 16.0;
  double get logoutIcon => isTablet ? 22.0 : 20.0;
  double get logoutPadH => isTablet ? 20.0 : 16.0;
  double get logoutPadB => isTablet ? 20.0 : 16.0;

  double get roomImageHeight => isTablet ? 260.0 : 190.0;
  double get roomTitleFont => isTablet ? 20.0 : 16.0;
  double get roomDescFont => isTablet ? 14.0 : 12.0;
  double get roomPriceFont => isTablet ? 22.0 : 17.0;
  double get roomPriceSufFont => isTablet ? 13.0 : 11.0;
  double get badgeFontSize => isTablet ? 13.0 : 11.0;
  double get badgePadH => isTablet ? 12.0 : 8.0;
  double get badgePadV => isTablet ? 6.0 : 4.0;
  double get badgeRadius => isTablet ? 20.0 : 16.0;
  double get ratingFont => isTablet ? 14.0 : 12.0;
  double get ratingIconSize => isTablet ? 16.0 : 13.0;
  double get taxFont => isTablet ? 12.0 : 10.0;
  double get amenityFont => isTablet ? 13.0 : 11.0;
  double get emptyIconSize => isTablet ? 120.0 : 90.0;
  double get emptyTitleFont => isTablet ? 24.0 : 20.0;
  double get emptySubFont => isTablet ? 16.0 : 14.0;
  double get detailImageHeight => isTablet ? 320.0 : 220.0;
  double get detailTitleFont => isTablet ? 22.0 : 18.0;
  double get detailBodyFont => isTablet ? 15.0 : 13.0;
  double get detailSectionTitle => isTablet ? 18.0 : 15.0;
  double get detailGridLabelFont => isTablet ? 13.0 : 11.5;
  double get detailGridValueFont => isTablet ? 15.0 : 13.0;
  double get detailGridIconSize => isTablet ? 22.0 : 18.0;
  double get facilityChipFont => isTablet ? 13.0 : 11.5;
  double get facilityChipIconSize => isTablet ? 18.0 : 15.0;
  double get facilityChipPadH => isTablet ? 14.0 : 10.0;
  double get facilityChipPadV => isTablet ? 8.0 : 6.0;
  double get bottomBarHeight => isTablet ? 90.0 : 74.0;
  double get bookBtnFont => isTablet ? 18.0 : 15.0;
  double get bookBtnRadius => isTablet ? 16.0 : 12.0;
  double get bookBtnPadH => isTablet ? 36.0 : 28.0;
  double get detailPriceFont => isTablet ? 26.0 : 20.0;
  double get detailPriceSufFont => isTablet ? 14.0 : 12.0;
  double get featureCardRadius => isTablet ? 16.0 : 12.0;
  double get featureCardPad => isTablet ? 20.0 : 14.0;
  double get reviewAvatarRadius => isTablet ? 36.0 : 26.0;
  double get reviewNameFont => isTablet ? 18.0 : 15.0;
  double get reviewDateFont => isTablet ? 13.0 : 11.0;
  double get reviewBodyFont => isTablet ? 15.0 : 13.0;
  double get reviewStarSize => isTablet ? 18.0 : 14.0;
  double get reviewRatingFont => isTablet ? 16.0 : 13.0;
  double get reviewCountFont => isTablet ? 18.0 : 15.0;
  double get reviewDividerH => isTablet ? 1.0 : 0.8;
  double get reviewItemGapV => isTablet ? 20.0 : 16.0;
  double get reviewAvatarContentGap => isTablet ? 16.0 : 12.0;
  double get reviewAvgSubFont => isTablet ? 14.0 : 12.0;
  double get reviewBadgeFont => isTablet ? 12.0 : 10.5;
  double get reviewBadgePadH => isTablet ? 10.0 : 8.0;
  double get reviewBadgePadV => isTablet ? 5.0 : 4.0;
  double get reviewBadgeRadius => isTablet ? 20.0 : 14.0;
  double get supportTabFont => isTablet ? 15.0 : 13.0;
  double get supportTabPadH => isTablet ? 22.0 : 16.0;
  double get supportTabPadV => isTablet ? 13.0 : 10.0;
  double get supportTabRadius => isTablet ? 30.0 : 24.0;
  double get supportFieldRadius => isTablet ? 16.0 : 12.0;
  double get supportFieldFont => isTablet ? 15.0 : 14.0;
  double get supportLabelFont => isTablet ? 15.0 : 14.0;
  double get supportMsgHeight => isTablet ? 160.0 : 120.0;
  double get supportBtnHeight => isTablet ? 62.0 : 52.0;
  double get supportBtnFont => isTablet ? 18.0 : 16.0;
  double get supportBtnRadius => isTablet ? 18.0 : 14.0;
  double get supportUploadFont => isTablet ? 15.0 : 13.0;
  double get supportUploadIcon => isTablet ? 22.0 : 18.0;
  double get supportUploadH => isTablet ? 64.0 : 52.0;
  double get searchBarHeight => isTablet ? 60.0 : 50.0;
  double get searchBarRadius => isTablet ? 16.0 : 12.0;
  double get searchHintFont => isTablet ? 16.0 : 14.0;
  double get searchIconSize => isTablet ? 22.0 : 18.0;

  double get currentLocTitleFont => isTablet ? 17.0 : 15.0;
  double get currentLocSubFont => isTablet ? 13.0 : 12.0;
  double get currentLocIconSize => isTablet ? 24.0 : 20.0;

  double get sectionTitleFont => isTablet ? 19.0 : 16.0;
  double get itemTitleFont => isTablet ? 16.0 : 14.5;
  double get itemSubFont => isTablet ? 13.0 : 12.0;
  double get itemIconSize => isTablet ? 22.0 : 18.0;
  // double get itemPadH => isTablet ? 20.0 : 16.0;
  // double get itemPadV => isTablet ? 16.0 : 13.0;
  double get itemRadius => isTablet ? 16.0 : 12.0;
  double get itemGap => isTablet ? 10.0 : 8.0;
  double get dividerH => isTablet ? 1.0 : 0.8;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static final _menuItems = [
    ProfileMenuItem(
      icon: Icons.edit_outlined,
      label: 'Edit Profile',
      route: RouteList.editProfile,
    ),
    ProfileMenuItem(
      icon: Icons.lock_outline_rounded,
      label: 'Change Password',
      route: RouteList.changePassword,
    ),
    ProfileMenuItem(
      icon: Icons.favorite_border_rounded,
      label: 'Wishlist',
      route: RouteList.wishlist,
    ),
    ProfileMenuItem(
      icon: Icons.notifications_none_rounded,
      label: 'Notifications',
      route: RouteList.notifications,
    ),
    ProfileMenuItem(
      icon: Icons.shield_outlined,
      label: 'Privacy Policy',
      route: RouteList.privacy,
    ),
    ProfileMenuItem(
      icon: Icons.help_outline_rounded,
      label: 'Help & Support',
      route: RouteList.tickets,
    ),
    ProfileMenuItem(
      icon: Icons.help_outline_rounded,
      label: 'contact us',
      route: RouteList.contactus,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final isProfileLoading =
        context.watch<ProfileBloc>().state is ProfileImgLoading;
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is LogoutReqSuccess) {
            await sl<AppSecureStorage>().writeString("token", "");
            await sl<AppSecureStorage>().writeBool("login", false);
            await UserSession().clear();
            context.read<WishlistBloc>().add(ResetWishlistEvent());
            context.read<SearchBloc>().add(ResetSearchEvent());

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
              context.go(RouteList.login);
            });

            AppToast.success("Logged out successfully");
          }

          if (state is LogoutReqError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
            });

            AppToast.error(state.message);
          }

          if (state is DeActivateReqSuccess) {
            await sl<AppSecureStorage>().writeString("token", "");
            await sl<AppSecureStorage>().writeBool("login", false);
            await UserSession().clear();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
              context.go(RouteList.login);
            });

            AppToast.success("Account Deactivated successfully");
          }

          if (state is DeActivateReqError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
            });

            AppToast.error(state.message);
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final r = R(constraints.maxWidth);
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.37,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 182, 154, 235),
                            Color(0xFFE8E0F8),
                            Colors.white,
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.screenPadH,
                          vertical: r.screenPadV,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TopBar(r: r),
                            SizedBox(height: r.headerGap),
                            _ProfileHeader(r: r),
                            SizedBox(height: r.sectionGap),
                            _MenuCard(menuItems: _menuItems, r: r),
                            SizedBox(height: r.sectionGap),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isProfileLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha:0.4),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final R r;
  const _TopBar({required this.r});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: r.titleFontSize,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1340),
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatefulWidget {
  final R r;

  const _ProfileHeader({required this.r});

  @override
  State<_ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<_ProfileHeader> {
  late final r = widget.r;
  final user = UserSession();
  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileImgLoading) {}
        if (state is ProfileImgError) {
          setState(() {
            _pickedImage = null;
          });
          AppToast.error(state.message);
        }
        if (state is ProfileImgLoaded) {
          AppToast.success("Profle image updated");
          // context.read<ProfileBloc>().add(ProfileLoadEvent());
        }
        if (state is ProfileLoaded) {
          setState(() {});
        }
      },
      builder: (context, state) {
        return Row(
          children: [
            AvatarWidget(
              r: r,
              heroTag: "profile_avatar",
              fileImage: _pickedImage,
              imageUrl: user.user?.profileUrl,
              onEditTap: () async {
                final file = await ImagePickerSheet.show(context);
                if (file == null) return;
                setState(() {
                  _pickedImage = file;
                });
                context.read<ProfileBloc>().add(
                  ProfileImgUpdateEvent(img: file),
                );
              },
            ),
            SizedBox(width: r.avatarGap),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserSession().user?.fullname ?? "",
                  style: TextStyle(
                    fontSize: r.nameFontSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1340),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  UserSession().user?.email ?? "",
                  style: TextStyle(
                    fontSize: r.emailFontSize,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1A1340).withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class AvatarWidget extends StatelessWidget {
  final R r;
  final String? imageUrl;
  final File? fileImage;
  final VoidCallback? onEditTap;
  final String heroTag;

  const AvatarWidget({
    super.key,
    required this.r,
    required this.heroTag,
    this.imageUrl,
    this.fileImage,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarImage;

    if (fileImage != null) {
      avatarImage = CircleAvatar(
        radius: r.avatarRadius,
        backgroundImage: FileImage(fileImage!),
        backgroundColor: const Color(0xFFD6CEF0),
      );
    } else {
      avatarImage = CircleAvatar(
        radius: r.avatarRadius,
        backgroundColor: const Color(0xFFD6CEF0),
        child: ClipOval(
          child: Image.network(
            imageUrl ?? "https://i.pravatar.cc/150?img=47",
            width: r.avatarRadius * 2,
            height: r.avatarRadius * 2,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;

              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            },
            errorBuilder: (_, __, ___) {
              return const Icon(Icons.person, size: 40);
            },
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: heroTag,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4B3FC8).withValues(alpha:0.20),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: avatarImage,
          ),
        ),

        if (onEditTap != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: r.avatarRadius * 0.55,
                height: r.avatarRadius * 0.55,
                decoration: BoxDecoration(
                  color: const Color(0xFF4B3FC8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4B3FC8).withValues(alpha:0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit_rounded,
                  size: r.avatarRadius * 0.28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<ProfileMenuItem> menuItems;
  final R r;

  const _MenuCard({required this.menuItems, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.cardRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B3FC8).withValues(alpha:0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ...List.generate(menuItems.length, (index) {
            return _MenuItem(
              item: menuItems[index],
              showDivider: index != menuItems.length - 1,
              r: r,
            );
          }),
          Padding(
            padding: EdgeInsets.fromLTRB(
              r.logoutPadH,
              4,
              r.logoutPadH,
              r.logoutPadB,
            ),
            child: _LogoutButton(
              buttonTitle: 'DeActivate',
              r: r,
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final loading = state is DeActivateReqLoading;

                        return ConfirmationPopup(
                          illustrationAsset: 'assets/log-out.png',
                          title: 'DeActivate',
                          message:
                              'Are you sure you want to DeActivate your account?',
                          confirmLabel: 'DeActivate',
                          loading: loading,
                          onConfirm: () {
                            context.read<AuthBloc>().add(DeActivateRequested());
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              r.logoutPadH,
              1,
              r.logoutPadH,
              r.logoutPadB,
            ),
            child: _LogoutButton(
              buttonTitle: 'Logout',
              r: r,
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final loading = state is LogoutReqLoading;

                        return ConfirmationPopup(
                          illustrationAsset: 'assets/log-out.png',
                          title: 'Log Out',
                          message:
                              'Are you sure you want to log out of your account?',
                          confirmLabel: 'Log Out',
                          loading: loading,
                          onConfirm: () {
                            context.read<AuthBloc>().add(LogoutRequested());
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final ProfileMenuItem item;
  final bool showDivider;
  final R r;

  const _MenuItem({
    required this.item,
    required this.showDivider,
    required this.r,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () {
            context.push(widget.item.route);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            color: _pressed
                ? const Color(0xFF4B3FC8).withValues(alpha:0.04)
                : Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: r.itemPadH,
              vertical: r.itemPadV,
            ),
            child: Row(
              children: [
                Container(
                  width: r.iconBox,
                  height: r.iconBox,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B3FC8).withValues(alpha:0.08),
                    borderRadius: BorderRadius.circular(r.iconBoxRadius),
                  ),
                  child: Icon(
                    widget.item.icon,
                    size: r.iconSize,
                    color: const Color(0xFF4B3FC8),
                  ),
                ),
                SizedBox(width: r.iconGap),
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: TextStyle(
                      fontSize: r.labelFontSize,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A1340),
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: r.chevronSize,
                  color: const Color(0xFF1A1340).withValues(alpha:0.35),
                ),
              ],
            ),
          ),
        ),
        if (widget.showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: r.itemPadH,
            endIndent: r.itemPadH,
            color: const Color(0xFFF0EDF8),
          ),
      ],
    );
  }
}

class _LogoutButton extends StatefulWidget {
  final VoidCallback onPressed;
  final R r;
  final String buttonTitle;
  const _LogoutButton({
    required this.onPressed,
    required this.r,
    required this.buttonTitle,
  });

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTapDown(TapDownDetails _) async => _controller.forward();
  Future<void> _onTapUp(TapUpDetails _) async {
    await _controller.reverse();
    widget.onPressed();
  }

  Future<void> _onTapCancel() async => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          width: double.infinity,
          height: r.logoutH,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5A4FD4), Color(0xFF3D33B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(r.logoutRadius),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4B3FC8).withValues(alpha:0.40),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.buttonTitle == 'Logout'
                  ? Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: r.logoutIcon,
                    )
                  : SizedBox(),
              const SizedBox(width: 8),
              Text(
                widget.buttonTitle == 'Logout' ? 'Logout' : widget.buttonTitle,
                style: TextStyle(
                  fontSize: r.logoutFont,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/data/models/accomodation/accomodation_details_res.dart';
import 'package:indhostels/data/models/accomodation/room_card_model.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/routing/app_roter.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/widgets/room_card.dart';

class RoomsScreen extends StatelessWidget {
  // final List<RoomModel> rooms;
  final VoidCallback? onRetry;
  final void Function(RoomModel room)? onRoomTap;
  final Acommodation? acommodation;
  // final String? pgName;
  // final String? location;
  // final String? checkInTime;
  // final String? staytype;
  // final String? cancellationPolicy;

  const RoomsScreen({
    super.key,
    // required this.rooms,
    this.onRetry,
    this.onRoomTap,
    this.acommodation,
    // this.pgName,
    // this.location,
    // this.checkInTime,
    // this.cancellationPolicy,
    // this.staytype,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final r = R(constraints.maxWidth);
        final rooms = (acommodation?.roomId ?? [])
            .map((e) => RoomModel.fromRoomId(e))
            .toList();
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FC),
          appBar: RoomsAppBar(title: 'Rooms', r: r),
          body: rooms.isEmpty
              ? EmptyRoomsWidget(r: r, onRetry: onRetry)
              : _RoomsList(
                  taxamount: acommodation?.taxAmount ?? 0,
                  taxenable: acommodation?.tax ?? false,
                  rooms: rooms,
                  r: r,
                  onRoomTap:
                      onRoomTap ??
                      (room) => context.pushNamed(
                        RouteList.roomDetails,
                        extra: RoomDetailArgs(
                          room: room,
                          acommodation: acommodation,
                          // pgName: acommodation?.propertyName ?? "N?A",
                          // location: acommodation?.location?.address ?? "N?A",
                          // checkInTime: acommodation?.checkInTime ?? "N?A",
                          // cancellationPolicy:
                          //     acommodation?.cancellationPolicy ?? "N?A",
                          // staytype: acommodation?.propertyType ?? "hostels",
                        ),
                      ),
                ),
        );
      },
    );
  }
}

class _RoomsList extends StatelessWidget {
  final List<RoomModel> rooms;
  final bool taxenable;
  final int taxamount;
  final R r;
  final void Function(RoomModel room)? onRoomTap;

  const _RoomsList({
    required this.rooms,
    required this.r,
    this.onRoomTap,
    required this.taxamount,
    required this.taxenable,
  });

  @override
  Widget build(BuildContext context) {
    if (r.isTablet) {
      return _tabletGrid(context);
    }
    return _mobileList();
  }

  Widget _mobileList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: r.screenPadH,
        vertical: r.screenPadV,
      ),
      itemCount: rooms.length,
      separatorBuilder: (context, index) => SizedBox(height: r.fieldGap),
      itemBuilder: (context, index) => RoomCard(
        taxamount: taxamount,
        taxenable: taxenable,
        room: rooms[index],
        r: r,
        onTap: () => onRoomTap?.call(rooms[index]),
      ),
    );
  }

  Widget _tabletGrid(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: r.screenPadH,
        vertical: r.screenPadV,
      ),
      child: Wrap(
        spacing: r.fieldGap,
        runSpacing: r.fieldGap,
        children: rooms.map((room) {
          return SizedBox(
            width: (width - (r.screenPadH * 2) - r.fieldGap) / 2,
            child: RoomCard(
              taxamount: taxamount,
              taxenable: taxenable,
              room: room,
              r: r,
              onTap: () => onRoomTap?.call(room),
            ),
          );
        }).toList(),
      ),
    );
  }
}

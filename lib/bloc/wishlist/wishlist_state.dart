
part of 'wishlist_bloc.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

final class WishlistInitial extends WishlistState {}

final class WishlistLoading extends WishlistState {}

final class WishlistLoaded extends WishlistState {
  const WishlistLoaded({
    required this.items,
    this.pendingId, 
  });

  final List<WishlistItem> items;
  final String? pendingId;

  int get total => items.length;

  bool isWishlisted(String accommodationId) =>
      items.any((e) => e.accommodationId == accommodationId);

  bool isPending(String accommodationId) => pendingId == accommodationId;

  WishlistLoaded copyWith({
    List<WishlistItem>? items,
    String? pendingId,
    bool clearPending = false,
  }) =>
      WishlistLoaded(
        items: items ?? this.items,
        pendingId: clearPending ? null : (pendingId ?? this.pendingId),
      );

  @override
  List<Object?> get props => [items, pendingId];
}

final class WishlistToggleError extends WishlistState {
  const WishlistToggleError({required this.items, required this.message});

  final List<WishlistItem> items;
  final String message;

  int get total => items.length;
  bool isWishlisted(String id) => items.any((e) => e.accommodationId == id);

  @override
  List<Object?> get props => [items, message];
}

final class WishlistError extends WishlistState {
  const WishlistError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
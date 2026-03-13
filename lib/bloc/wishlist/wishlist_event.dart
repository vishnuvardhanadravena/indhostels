
part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

final class FetchWishlistEvent extends WishlistEvent {
  const FetchWishlistEvent();
}

final class ToggleWishlistEvent extends WishlistEvent {
  const ToggleWishlistEvent(this.accommodationId);

  final String accommodationId;

  @override
  List<Object?> get props => [accommodationId];
}

final class AddToWishlistEvent extends WishlistEvent {
  const AddToWishlistEvent(this.accommodationId);

  final String accommodationId;

  @override
  List<Object?> get props => [accommodationId];
}

final class RemoveFromWishlistEvent extends WishlistEvent {
  const RemoveFromWishlistEvent(this.accommodationId);

  final String accommodationId;

  @override
  List<Object?> get props => [accommodationId];
}
part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class FetchWishlistEvent extends WishlistEvent {}

class ToggleWishlistEvent extends WishlistEvent {
  final String accommodationId;

  const ToggleWishlistEvent(this.accommodationId);

  @override
  List<Object?> get props => [accommodationId];
}

class AddToWishlistEvent extends WishlistEvent {
  final String accommodationId;

  const AddToWishlistEvent(this.accommodationId);

  @override
  List<Object?> get props => [accommodationId];
}

class RemoveFromWishlistEvent extends WishlistEvent {
  final String accommodationId;

  const RemoveFromWishlistEvent(this.accommodationId);

  @override
  List<Object?> get props => [accommodationId];
}

class ResetWishlistEvent extends WishlistEvent {}

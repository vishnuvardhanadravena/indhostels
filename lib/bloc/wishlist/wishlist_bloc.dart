
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indhostels/data/models/wishlist/wish_list_res.dart';
import 'package:indhostels/data/repo/wish_list_repo.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(this._repository) : super(WishlistInitial()) {
    on<FetchWishlistEvent>(_onFetch);
    on<ToggleWishlistEvent>(_onToggle);
    on<AddToWishlistEvent>(_onAdd);
    on<RemoveFromWishlistEvent>(_onRemove);
  }

  final WishlistRepository _repository;


  Future<void> _onFetch(
    FetchWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());
    try {
      List<WishlistItem> items;
      try {
        items = await _repository.fetchWishlist();
      } catch (_) {
        items = await _repository.getLocalWishlist();
      }
      emit(WishlistLoaded(items: items));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }


  Future<void> _onToggle(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final alreadyAdded = _currentItems().any(
      (e) => e.accommodationId == event.accommodationId,
    );

    if (alreadyAdded) {
      add(RemoveFromWishlistEvent(event.accommodationId));
    } else {
      add(AddToWishlistEvent(event.accommodationId));
    }
  }


  Future<void> _onAdd(
    AddToWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final currentItems = _currentItems();

    // Show per-item spinner
    emit(WishlistLoaded(items: currentItems, pendingId: event.accommodationId));

    try {
      final newItem = await _repository.addToWishlist(event.accommodationId);

      final updated = List<WishlistItem>.from(currentItems)
        ..removeWhere((e) => e.accommodationId == event.accommodationId)
        ..add(newItem);
      emit(WishlistLoaded(items: updated));
    } catch (e) {
      emit(
        WishlistToggleError(
          items: currentItems,
          message: 'Could not add to wishlist. Please try again.',
        ),
      );
    }
  }


  Future<void> _onRemove(
    RemoveFromWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final currentItems = _currentItems();

    emit(WishlistLoaded(items: currentItems, pendingId: event.accommodationId));

    try {
      await _repository.removeFromWishlist(event.accommodationId);

      final updated = currentItems
          .where((e) => e.accommodationId != event.accommodationId)
          .toList();

      emit(WishlistLoaded(items: updated));
    } catch (e) {
      emit(
        WishlistToggleError(
          items: currentItems,
          message: 'Could not remove from wishlist. Please try again.',
        ),
      );
    }
  }


  List<WishlistItem> _currentItems() => switch (state) {
    WishlistLoaded s => List<WishlistItem>.from(s.items),
    WishlistToggleError s => List<WishlistItem>.from(s.items),
    _ => [],
  };
}

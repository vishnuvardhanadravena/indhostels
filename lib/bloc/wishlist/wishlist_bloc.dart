import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indhostels/data/models/wishlist/wish_list_res.dart';
import 'package:indhostels/data/repo/wish_list_repo.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository repository;

  WishlistBloc(this.repository) : super(const WishlistState()) {
    on<FetchWishlistEvent>(_fetch);
    on<ToggleWishlistEvent>(_toggle);
    on<AddToWishlistEvent>(_add);
    on<RemoveFromWishlistEvent>(_remove);
  }

  /// ───────── FETCH ─────────
  Future<void> _fetch(
    FetchWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {

    emit(state.copyWith(loading: true, error: null));

    try {

      final localItems = await repository.getLocalWishlist();

      emit(state.copyWith(
        loading: false,
        items: localItems,
      ));

      try {

        final apiItems = await repository.fetchWishlist();

        emit(state.copyWith(items: apiItems));

      } catch (_) {}

    } catch (e) {

      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));

    }
  }

  /// ───────── TOGGLE ─────────
  Future<void> _toggle(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {

    final exists = state.items.any(
      (e) => e.accommodationId == event.accommodationId,
    );

    if (exists) {
      add(RemoveFromWishlistEvent(event.accommodationId));
    } else {
      add(AddToWishlistEvent(event.accommodationId));
    }
  }

  /// ───────── ADD ─────────
  Future<void> _add(
    AddToWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {

    emit(state.copyWith(
      pendingId: event.accommodationId,
      addError: null,
      addSuccess: false,
    ));

    try {

      final newItem =
          await repository.addToWishlist(event.accommodationId);

      final updated = List<WishlistItem>.from(state.items)
        ..removeWhere((e) => e.accommodationId == event.accommodationId)
        ..add(newItem);

      emit(state.copyWith(
        items: updated,
        clearPending: true,
        addSuccess: true,
      ));

      /// reset success
      emit(state.copyWith(addSuccess: false));

    } catch (e) {

      emit(state.copyWith(
        clearPending: true,
        addError: "Failed to add wishlist",
      ));

    }
  }

  /// ───────── REMOVE ─────────
  Future<void> _remove(
    RemoveFromWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {

    emit(state.copyWith(
      pendingId: event.accommodationId,
      removeError: null,
      removeSuccess: false,
    ));

    try {

      await repository.removeFromWishlist(event.accommodationId);

      final updated = state.items
          .where((e) => e.accommodationId != event.accommodationId)
          .toList();

      emit(state.copyWith(
        items: updated,
        clearPending: true,
        removeSuccess: true,
      ));

      /// reset success
      emit(state.copyWith(removeSuccess: false));

    } catch (e) {

      emit(state.copyWith(
        clearPending: true,
        removeError: "Failed to remove wishlist",
      ));

    }
  }
}
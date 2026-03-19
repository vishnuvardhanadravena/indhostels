part of 'wishlist_bloc.dart';

class WishlistState extends Equatable {
  final bool loading;

  final String? error;

  final List<WishlistItem> items;

  final String? pendingId;

  final bool addSuccess;
  final bool removeSuccess;

  final String? addError;
  final String? removeError;

  const WishlistState({
    this.loading = false,
    this.error,
    this.items = const [],
    this.pendingId,
    this.addSuccess = false,
    this.removeSuccess = false,
    this.addError,
    this.removeError,
  });

  int get total => items.length;

  bool isWishlisted(String accommodationId) =>
      items.any((e) => e.accommodationId == accommodationId);

  bool isPending(String accommodationId) => pendingId == accommodationId;

  WishlistState copyWith({
    bool? loading,
    String? error,
    List<WishlistItem>? items,
    String? pendingId,
    bool clearPending = false,

    bool? addSuccess,
    bool? removeSuccess,
    String? addError,
    String? removeError,
  }) {
    return WishlistState(
      loading: loading ?? this.loading,
      error: error,
      items: items ?? this.items,
      pendingId: clearPending ? null : (pendingId ?? this.pendingId),

      addSuccess: addSuccess ?? false,
      removeSuccess: removeSuccess ?? false,
      addError: addError,
      removeError: removeError,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    error,
    items,
    pendingId,
    addSuccess,
    removeSuccess,
    addError,
    removeError,
  ];
}

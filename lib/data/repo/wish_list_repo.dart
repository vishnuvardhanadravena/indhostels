import 'dart:convert';
import 'package:indhostels/data/models/wishlist/wish_list_res.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class WishlistRepository {
  WishlistRepository(this._apiClient, this._storage);

  final ApiClient _apiClient;
  final AppSecureStorage _storage;
  static const _storageKey = 'wishlist_items';
  Future<List<WishlistItem>> getLocalWishlist() async {
    final raw = await _storage.readString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (e) =>
              WishlistItem.fromStorageJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  Future<void> _saveLocalWishlist(List<WishlistItem> items) async {
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _storage.writeString(_storageKey, encoded);
  }

  Future<void> _addToLocal(WishlistItem item) async {
    final items = await getLocalWishlist();
    items.removeWhere((e) => e.accommodationId == item.accommodationId);
    items.add(item);
    await _saveLocalWishlist(items);
  }

  Future<void> _removeFromLocal(String accommodationId) async {
    final items = await getLocalWishlist();
    items.removeWhere((e) => e.accommodationId == accommodationId);
    await _saveLocalWishlist(items);
  }

  /// Looks up the wishlistItemId stored locally for a given accommodationId.
  /// Returns null if not found (item was never added or cache is stale).
  Future<String?> getWishlistItemId(String accommodationId) async {
    final items = await getLocalWishlist();
    try {
      return items
          .firstWhere((e) => e.accommodationId == accommodationId)
          .wishlistItemId;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearLocalWishlist() => _storage.delete(_storageKey);

  Future<List<WishlistItem>> fetchWishlist() async {
    final response = await _apiClient.get(ApiConstants.fetchWishlist);

    final body = Map<String, dynamic>.from(response.data as Map);
    final rawList = (body['data']['wishlist'] as List? ?? []);

    final items = rawList
        .map(
          (e) => WishlistItem.fromGetJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();

    await _saveLocalWishlist(items);
    return items;
  }

  /// Sends accommodationId to API.
  /// Response contains the new wishlistItemId (_id) — stored locally.
  Future<WishlistItem> addToWishlist(String accommodationId) async {
    final response = await _apiClient.post(
      ApiConstants.addToWishlist,
      data: {"accommodationid": accommodationId},
    );

    final body = Map<String, dynamic>.from(response.data as Map);
    final rawList = body['data'] as List;

    // API returns the updated wishlist array; last entry is the newly added item
    final newItem = WishlistItem.fromAddJson(
      Map<String, dynamic>.from(rawList.last as Map),
    );
    // newItem.wishlistItemId = the "_id" from API  ✅
    // newItem.accommodationId = "6954ea01..."       ✅

    await _addToLocal(newItem);
    return newItem;
  }

  /// You call this with [accommodationId].
  /// Internally it looks up the [wishlistItemId] and passes THAT to the API.
  /// Only removes locally if the API call succeeds.
  Future<void> removeFromWishlist(String accommodationId) async {
    final wishlistItemId = await getWishlistItemId(accommodationId);
    if (wishlistItemId == null) {
      return;
    }
    await _apiClient.delete(
      ApiConstants.deleteFromWishlist,
      queryParameters: {"wishlistid": wishlistItemId},
    );
    await _removeFromLocal(accommodationId);
  }
}

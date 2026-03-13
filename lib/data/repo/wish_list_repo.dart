// lib/data/repo/wish_list_repo.dart

import 'dart:convert';
import 'package:indhostels/data/models/wishlist/wish_list_res.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';

class WishlistRepository {
  WishlistRepository(this._apiClient, this._storage);

  final ApiClient _apiClient;
  final AppSecureStorage _storage;

  static const _storageKey = 'wishlist_items';

  // ─── LOCAL STORAGE ───────────────────────────────────────────────────────

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
    // Replace if already exists (keeps wishlistItemId fresh)
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

  // ─── API: GET ────────────────────────────────────────────────────────────

  Future<List<WishlistItem>> fetchWishlist() async {
    final response = await _apiClient.get('/wishlist');

    final body = Map<String, dynamic>.from(response.data as Map);
    final rawList = (body['data']['wishlist'] as List? ?? []);

    final items = rawList
        .map(
          (e) => WishlistItem.fromGetJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();

    // Sync entire list to local — this also refreshes all wishlistItemIds
    await _saveLocalWishlist(items);
    return items;
  }

  // ─── API: ADD ────────────────────────────────────────────────────────────

  /// Sends accommodationId to API.
  /// Response contains the new wishlistItemId (_id) — stored locally.
  Future<WishlistItem> addToWishlist(String accommodationId) async {
    final response = await _apiClient.post('/wishlist/$accommodationId');

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

  // ─── API: DELETE ─────────────────────────────────────────────────────────

  /// You call this with [accommodationId].
  /// Internally it looks up the [wishlistItemId] and passes THAT to the API.
  /// Only removes locally if the API call succeeds.
  Future<void> removeFromWishlist(String accommodationId) async {
    // 1️⃣  Find the wishlistItemId for this accommodation
    final wishlistItemId = await getWishlistItemId(accommodationId);

    if (wishlistItemId == null) {
      // Not in local cache — nothing to delete
      return;
    }

    // 2️⃣  Call API with wishlistItemId (not accommodationId)
    await _apiClient.delete('/wishlist/$wishlistItemId');

    // 3️⃣  Remove from local only after API succeeds
    await _removeFromLocal(accommodationId);
  }
}

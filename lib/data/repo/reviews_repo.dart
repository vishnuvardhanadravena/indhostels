import 'package:indhostels/data/models/Reviews/reviews_res.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class ReviewRepository {
  final ApiClient api;

  ReviewRepository(this.api);

  Future<ReviewsRes> getReviews({
    required String propertyId,
    required int page,
    required int limit,
  }) async {
    final response = await api.get(
      ApiConstants.reviews(propertyId),
      query: {"page": page, "limit": limit},
    );

    return ReviewsRes.fromJson(response.data);
  }
}

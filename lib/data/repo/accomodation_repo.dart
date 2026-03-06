import 'package:indhostels/data/models/accomodation/popular_hstl_res.dart';
import 'package:indhostels/data/models/accomodation/top_hstl_res.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class AccommodationRepository {
  final ApiClient api;
  AccommodationRepository(this.api);
  Future<AccomdationTopHstl> getTophstl() async {
    final response = await api.get(ApiConstants.getTopHstl);
    return AccomdationTopHstl.fromJson(response.data);
  }

Future<AccomdationPoppularHstl> getBudgetHstl({
  required String type,
  required int page,
  required int limit,
}) async {
    final response = await api.get(
      ApiConstants.getBudgetHstl,
      query: {"page": page, "limit": limit, "type": type},
    );
    return AccomdationPoppularHstl.fromJson(response.data);
  }
}

import 'package:indhostels/data/models/auth_models/auth_req.dart';
import 'package:indhostels/data/models/auth_models/auth_res.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class AuthRepository {
  final ApiClient api;

  AuthRepository(this.api);

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await api.post(
      "https://api.indhostel.com/indhostels/auth/user/signin",
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(response.data);
  }

  // Future<SignupResponseModel> signup(SignupRequestModel request) async {
  //   final response = await api.post(
  //     ApiConstants.signup,
  //     data: request.toJson(),
  //   );

  //   return SignupResponseModel.fromJson(response.data);
  // }
}

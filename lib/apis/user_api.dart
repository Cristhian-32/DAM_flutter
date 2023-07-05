import 'package:dio/dio.dart';
import 'package:flutter_manager/models/user.dart';
import 'package:flutter_manager/util/UrlApi.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';

part 'user_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;
  static UserApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return UserApi(dio);
  }

  @POST("/api/auth/login")
  Future<TokenModel> login(@Body() UserModel user);

  @POST("/api/auth/register/user")
  Future<void> store(@Body() UserModel user);
}

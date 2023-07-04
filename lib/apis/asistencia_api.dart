import 'package:dio/dio.dart';
import 'package:flutter_manager/models/asistenciaModel.dart';
import 'package:flutter_manager/util/UrlApi.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';

part 'asistencia_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class AsistenciaApi {
  factory AsistenciaApi(Dio dio, {String baseUrl}) = _AsistenciaApi;
  static AsistenciaApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return AsistenciaApi(dio);
  }

  @GET("/api/asistencias")
  Future<RespAsistenciaModel> index(@Header("Authorizacion") String token);

  @POST("/api/asistencias")
  Future<RespAsistenciaModel> store(@Header("Authorization") String token,
      @Body() AsistenciaModel asistencia);

  @DELETE("/api/act/{id}")
  Future<RespAsistenciaModel> delete(
      @Header("Authorization") String token, @Path("id") int id);
}

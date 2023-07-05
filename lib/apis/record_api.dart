import 'package:dio/dio.dart';
import 'package:flutter_manager/models/RecordModel.dart';
import 'package:flutter_manager/models/asistenciaModel.dart';
import 'package:flutter_manager/util/UrlApi.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';

part 'record_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class RecordApi {
  factory RecordApi(Dio dio, {String baseUrl}) = _RecordApi;
  static RecordApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return RecordApi(dio);
  }

  @GET("/api/records")
  Future<RespRecordModel> index(@Header("Authorization") String token);

  @POST("/api/records")
  Future<RespRecordModel> store(@Header("Authorization") String token,
      @Body() RecordModel record);

  @DELETE("/api/records/{id}")
  Future<RespRecordModel> delete(
      @Header("Authorization") String token, @Path("id") int id);
}

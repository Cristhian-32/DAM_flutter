import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AsistenciaModel {
  late int activityId;
  late String code;
  late String level;
  late String date;

  AsistenciaModel(
      {required this.activityId, required this.code, required this.level});

  AsistenciaModel.unlaunched();

  AsistenciaModel.fromJson(Map<String, dynamic> json) {
    activityId = json['activity_id'];
    code = json['code'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity_id'] = this.activityId;
    data['code'] = this.code;
    data['level'] = this.level;
    return data;
  }
}

class RespAsistenciaModel {
  late bool success;
  late List<AsistenciaModel> data;
  late String message;

  RespAsistenciaModel(
      {required this.success, required this.data, required this.message});
  RespAsistenciaModel.unlaunched();

  RespAsistenciaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = (json['data'] as List)
        .map((e) => AsistenciaModel.fromJson(e as Map<String, dynamic>))
        .toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data.map((e) => e.toJson()).toList();
    data['message'] = this.message;
    return data;
  }
}

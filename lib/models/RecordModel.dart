import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class RecordModel {
  late int recordId = 0;
  late int activity_id;
  late String name;
  late String code;
  late String school;
  late String level;
  late String date;
  late String time;

  RecordModel({required this.activity_id});

  RecordModel.unlaunched();

  RecordModel.fromJson(Map<String, dynamic> json) {
    activity_id = json['activity_id'];
    name = json['name'];
    code = json['code'];
    school = json['school'];
    level = json['level'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity_id'] = this.activity_id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['school'] = this.school;
    data['level'] = this.level;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}

class RespRecordModel {
  late bool success;
  late List<RecordModel> data;
  late String message;

  RespRecordModel(
      {required this.success, required this.data, required this.message});
  RespRecordModel.unlaunched();

  RespRecordModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = (json['data'] as List)
        .map((e) => RecordModel.fromJson(e as Map<String, dynamic>))
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

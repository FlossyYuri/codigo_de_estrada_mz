import 'package:flutter/material.dart';

class AppInfo {
  String platform;
  String version;
  int bundle;
  bool state;
  AppInfo({
    @required this.platform,
    @required this.bundle,
    @required this.state,
    @required this.version,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json){
    return AppInfo(
      platform: json['platform'],
      version: json['version'],
      bundle: json['bundle'],
      state: json['state'],
    );
  }

  AppInfo.fromMap(Map<String,dynamic> map) {
    platform = map["platform"];
    bundle = map["bundle"];
    state = map["state"];
    version = map["version"];
  }


  Map<String, dynamic> toJson(){
    return {
      "platform": version,
      "version": version,
      "bundle": bundle,
      "state": state,
    };
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["platform"] = version;
    map["version"] = version;
    map["bundle"] = bundle;
    map["state"] = state;
    return map;
  }
}

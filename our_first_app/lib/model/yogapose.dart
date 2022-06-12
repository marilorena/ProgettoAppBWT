import 'package:flutter/cupertino.dart';

class YogaPose {
  final int id;
  final String name;
  final String sanskritName;

  YogaPose({required this.id, required this.name, required this.sanskritName});

  factory YogaPose.fromJson(Map<String, dynamic> json){
    return YogaPose(
      id: json["id"], 
      name: json["english_name"], 
      sanskritName: json["sanskrit_name"], 
    );
  }
}
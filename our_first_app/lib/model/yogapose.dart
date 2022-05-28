import 'package:flutter/cupertino.dart';

class YogaPose {
  final int id;
  final String name;
  final String sanskritName;
  final String imageUrl;

  YogaPose({required this.id, required this.name, required this.sanskritName, required this.imageUrl});

  factory YogaPose.fromJson(Map<String, dynamic> json){
    return YogaPose(
      id: json["id"], 
      name: json["english_name"], 
      sanskritName: json["sanskrit_name"], 
      imageUrl: json["img_url"]
    );
  }
}